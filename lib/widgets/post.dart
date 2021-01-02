import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../pages/full_post.dart';
import '../url_launcher.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../util/more_icon.dart';
import 'bottom_modal.dart';
import 'fullscreenable_image.dart';
import 'info_table_popup.dart';
import 'markdown_text.dart';
import 'save_post_button.dart';

enum MediaType {
  image,
  gallery,
  video,
  other,
  none,
}

MediaType whatType(String url) {
  if (url == null || url.isEmpty) return MediaType.none;

  // TODO: make detection more nuanced
  if (url.endsWith('.jpg') ||
      url.endsWith('.jpeg') ||
      url.endsWith('.png') ||
      url.endsWith('.gif') ||
      url.endsWith('.webp') ||
      url.endsWith('.bmp') ||
      url.endsWith('.wbpm')) {
    return MediaType.image;
  }
  return MediaType.other;
}

/// A post overview card
class Post extends HookWidget {
  final PostView post;
  final String instanceHost;
  final bool fullPost;

  Post(this.post, {this.fullPost = false}) : instanceHost = post.instanceHost;

  // == ACTIONS ==

  static void showMoreMenu(BuildContext context, PostView post) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomModal(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.open_in_browser),
              title: Text('Open in browser'),
              onTap: () async => await ul.canLaunch(post.apId)
                  ? ul.launch(post.apId)
                  : Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("can't open in browser"))),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Nerd stuff'),
              onTap: () {
                showInfoTablePopup(context, {
                  'id': post.id,
                  'apId': post.apId,
                  'upvotes': post.upvotes,
                  'downvotes': post.downvotes,
                  'score': post.score,
                  '% of upvotes':
                      '''${(100 * (post.upvotes / (post.upvotes + post.downvotes))).toInt()}%''',
                  'hotRank': post.hotRank,
                  'hotRank active': post.hotRankActive,
                  'local': post.local,
                  'published': post.published,
                  'updated': post.updated ?? 'never',
                  'newestActivityTime': post.newestActivityTime,
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // == UI ==

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void _openLink() => linkLauncher(
        context: context, url: post.url, instanceHost: instanceHost);

    final urlDomain = () {
      if (whatType(post.url) == MediaType.none) return null;

      final url = post.url.split('/')[2];
      if (url.startsWith('www.')) return url.substring(4);
      return url;
    }();

    /// assemble info section
    Widget info() => Column(children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (post.communityIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => goToCommunity.byId(
                            context, instanceHost, post.communityId),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: CachedNetworkImage(
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: imageProvider,
                                ),
                              ),
                            ),
                            imageUrl: post.communityIcon,
                            errorWidget: (context, url, error) =>
                                Text(error.toString()),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Column(
                children: [
                  Row(children: [
                    RichText(
                      overflow: TextOverflow.ellipsis, // TODO: fix overflowing
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 15,
                            color: theme.textTheme.bodyText1.color),
                        children: [
                          TextSpan(
                              text: '!',
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          TextSpan(
                              text: post.communityName,
                              style: TextStyle(fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => goToCommunity.byId(
                                    context, instanceHost, post.communityId)),
                          TextSpan(
                              text: '@',
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          TextSpan(
                              text: post.originInstanceHost,
                              style: TextStyle(fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => goToInstance(
                                    context, post.originInstanceHost)),
                        ],
                      ),
                    )
                  ]),
                  Row(children: [
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: 13,
                              color: theme.textTheme.bodyText1.color),
                          children: [
                            TextSpan(
                                text: 'by',
                                style: TextStyle(fontWeight: FontWeight.w300)),
                            TextSpan(
                              text:
                                  ''' ${post.creatorPreferredUsername ?? post.creatorName}''',
                              style: TextStyle(fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => goToUser.byId(
                                    context, post.instanceHost, post.creatorId),
                            ),
                            TextSpan(
                                text:
                                    ''' · ${timeago.format(post.published, locale: 'en_short')}'''),
                            if (post.locked) TextSpan(text: ' · 🔒'),
                            if (post.stickied) TextSpan(text: ' · 📌'),
                            if (post.nsfw) TextSpan(text: ' · '),
                            if (post.nsfw)
                              TextSpan(
                                  text: 'NSFW',
                                  style: TextStyle(color: Colors.red)),
                            if (urlDomain != null)
                              TextSpan(text: ' · $urlDomain'),
                            if (post.removed) TextSpan(text: ' · REMOVED'),
                            if (post.deleted) TextSpan(text: ' · DELETED'),
                          ],
                        ))
                  ]),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Spacer(),
              if (!fullPost)
                Column(
                  children: [
                    IconButton(
                      onPressed: () => showMoreMenu(context, post),
                      icon: Icon(moreIcon),
                      iconSize: 24,
                      padding: EdgeInsets.all(0),
                      visualDensity: VisualDensity.compact,
                    )
                  ],
                )
            ]),
          ),
        ]);

    /// assemble title section
    Widget title() => Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                flex: 100,
                child: Text(
                  '${post.name}',
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (whatType(post.url) == MediaType.other &&
                  post.thumbnailUrl != null) ...[
                Spacer(),
                InkWell(
                  onTap: _openLink,
                  child: Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: post.thumbnailUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Text(error.toString()),
                        )),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.launch,
                        size: 20,
                      ),
                    )
                  ]),
                )
              ]
            ],
          ),
        );

    /// assemble link preview
    Widget linkPreview() {
      assert(post.url != null);

      return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: _openLink,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1,
                    color: Theme.of(context).iconTheme.color.withAlpha(170)),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(children: [
                    Spacer(),
                    Text('$urlDomain ',
                        style: theme.textTheme.caption
                            .apply(fontStyle: FontStyle.italic)),
                    Icon(Icons.launch, size: 12),
                  ]),
                  Row(children: [
                    Flexible(
                        child: Text('${post.embedTitle ?? ''}',
                            style: theme.textTheme.subtitle1
                                .apply(fontWeightDelta: 2)))
                  ]),
                  if (post.embedDescription != null &&
                      post.embedDescription.isNotEmpty)
                    Row(children: [
                      Flexible(child: Text(post.embedDescription))
                    ]),
                ],
              ),
            ),
          ),
        ),
      );
    }

    /// assemble image
    Widget postImage() {
      assert(post.url != null);

      return FullscreenableImage(
        url: post.url,
        child: CachedNetworkImage(
          imageUrl: post.url,
          errorWidget: (_, __, ___) => Icon(Icons.warning),
          progressIndicatorBuilder: (context, url, progress) =>
              CircularProgressIndicator(value: progress.progress),
        ),
      );
    }

    /// assemble actions section
    Widget actions() => Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            children: [
              Icon(Icons.comment),
              Expanded(
                flex: 999,
                child: Text(
                  '''  ${NumberFormat.compact().format(post.numberOfComments)} comment${post.numberOfComments == 1 ? '' : 's'}''',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              Spacer(),
              if (!fullPost)
                IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () => Share.text('Share post url', post.apId,
                        'text/plain')), // TODO: find a way to mark it as url
              if (!fullPost) SavePostButton(post),
              _Voting(post),
            ],
          ),
        );

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black54)],
        color: theme.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: InkWell(
        onTap: fullPost
            ? null
            : () => goTo(context, (context) => FullPostPage.fromPostView(post)),
        child: Column(
          children: [
            info(),
            title(),
            if (whatType(post.url) != MediaType.other &&
                whatType(post.url) != MediaType.none)
              postImage()
            else if (post.url != null && post.url.isNotEmpty)
              linkPreview(),
            if (post.body != null)
              // TODO: trim content
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: MarkdownText(post.body, instanceHost: instanceHost)),
            actions(),
          ],
        ),
      ),
    );
  }
}

class _Voting extends HookWidget {
  final PostView post;

  final bool wasVoted;

  _Voting(this.post)
      : wasVoted = (post.myVote ?? VoteType.none) != VoteType.none;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myVote = useState(post.myVote ?? VoteType.none);
    final loading = useDelayedLoading(Duration(milliseconds: 500));
    final loggedInAction = useLoggedInAction(post.instanceHost);

    vote(VoteType vote, Jwt token) async {
      final api = LemmyApi(post.instanceHost).v1;

      loading.start();
      try {
        final res = await api.createPostLike(
            postId: post.id, score: vote, auth: token.raw);
        myVote.value = res.myVote;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('voting failed :(')));
        return;
      }
      loading.cancel();
    }

    return Row(
      children: [
        IconButton(
            icon: Icon(
              Icons.arrow_upward,
              color: myVote.value == VoteType.up ? theme.accentColor : null,
            ),
            onPressed: loggedInAction(
              (token) => vote(
                myVote.value == VoteType.up ? VoteType.none : VoteType.up,
                token,
              ),
            )),
        if (loading.loading)
          SizedBox(child: CircularProgressIndicator(), width: 20, height: 20)
        else
          Text(NumberFormat.compact()
              .format(post.score + (wasVoted ? 0 : myVote.value.value))),
        IconButton(
            icon: Icon(
              Icons.arrow_downward,
              color: myVote.value == VoteType.down ? Colors.red : null,
            ),
            onPressed: loggedInAction(
              (token) => vote(
                myVote.value == VoteType.down ? VoteType.none : VoteType.down,
                token,
              ),
            )),
      ],
    );
  }
}

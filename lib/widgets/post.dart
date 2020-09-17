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

import '../pages/full_post.dart';
import '../url_launcher.dart';
import '../util/api_extensions.dart';
import '../util/goto.dart';
import 'bottom_modal.dart';
import 'fullscreenable_image.dart';
import 'markdown_text.dart';

enum MediaType {
  image,
  gallery,
  video,
  other,
}

MediaType whatType(String url) {
  if (url == null) return MediaType.other;

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

class Post extends HookWidget {
  final PostView post;
  final String instanceUrl;
  final bool fullPost;

  Post(this.post, {this.fullPost = false}) : instanceUrl = post.instanceUrl;

  // == ACTIONS ==

  void _savePost() {
    print('SAVE POST');
  }

  void _upvotePost() {
    print('UPVOTE POST');
  }

  void _downvotePost() {
    print('DOWNVOTE POST');
  }

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
                showDialog(
                  context: context,
                  child: SimpleDialog(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    children: [
                      Table(
                        children: [
                          TableRow(children: [
                            Text('upvotes:'),
                            Text(post.upvotes.toString()),
                          ]),
                          TableRow(children: [
                            Text('downvotes:'),
                            Text(post.downvotes.toString()),
                          ]),
                          TableRow(children: [
                            Text('score:'),
                            Text(post.score.toString()),
                          ]),
                          TableRow(children: [
                            Text('% of upvotes:'),
                            Text(
                                '''${(100 * (post.upvotes / (post.upvotes + post.downvotes))).toInt()}%'''),
                          ]),
                          TableRow(children: [
                            Text('hotrank:'),
                            Text(post.hotRank.toString()),
                          ]),
                          TableRow(children: [
                            Text('hotrank active:'),
                            Text(post.hotRankActive.toString()),
                          ]),
                          TableRow(children: [
                            Text('published:'),
                            Text(
                                '''${DateFormat.yMMMd().format(post.published)}'''
                                ''' ${DateFormat.Hms().format(post.published)}'''),
                          ]),
                          TableRow(children: [
                            Text('updated:'),
                            Text(post.updated != null
                                ? '''${DateFormat.yMMMd().format(post.updated)}'''
                                    ''' ${DateFormat.Hms().format(post.updated)}'''
                                : 'never'),
                          ]),
                        ],
                      ),
                    ],
                  ),
                );
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
    void _openLink() =>
        linkLauncher(context: context, url: post.url, instanceUrl: instanceUrl);

    final urlDomain = () {
      if (post.url == null) return null;

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
                            context, instanceUrl, post.communityId),
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
                                    context, instanceUrl, post.communityId)),
                          TextSpan(
                              text: '@',
                              style: TextStyle(fontWeight: FontWeight.w300)),
                          TextSpan(
                              text: instanceUrl,
                              style: TextStyle(fontWeight: FontWeight.w600),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => goToInstance(context, instanceUrl)),
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
                                    context, post.instanceUrl, post.creatorId),
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
                      icon: Icon(Icons.more_vert),
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
              if (post.url != null &&
                  whatType(post.url) == MediaType.other &&
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
                        child: Text('${post.embedTitle}',
                            style: theme.textTheme.subtitle1
                                .apply(fontWeightDelta: 2)))
                  ]),
                  if (post.embedDescription != null)
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
              if (!fullPost)
                IconButton(
                    icon: post.saved == true
                        ? Icon(Icons.bookmark)
                        : Icon(Icons.bookmark_border),
                    onPressed: _savePost),
              IconButton(
                  icon: Icon(Icons.arrow_upward), onPressed: _upvotePost),
              Text(NumberFormat.compact().format(post.score)),
              IconButton(
                  icon: Icon(Icons.arrow_downward), onPressed: _downvotePost),
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
            : () => goTo(
                context,
                (context) =>
                    FullPostPage.fromPostView(post)), //, instanceUrl, post.id),
        child: Column(
          children: [
            info(),
            title(),
            if (whatType(post.url) != MediaType.other)
              postImage()
            else if (post.url != null)
              linkPreview(),
            if (post.body != null)
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: MarkdownText(post.body, instanceUrl: instanceUrl)),
            actions(),
          ],
        ),
      ),
    );
  }
}

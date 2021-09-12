import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../pages/create_post.dart';
import '../pages/full_post.dart';
import '../stores/accounts_store.dart';
import '../url_launcher.dart';
import '../util/cleanup_url.dart';
import '../util/extensions/api.dart';
import '../util/extensions/datetime.dart';
import '../util/goto.dart';
import '../util/more_icon.dart';
import '../util/share.dart';
import 'avatar.dart';
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

MediaType whatType(String? url) {
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
class PostWidget extends HookWidget {
  final PostView post;
  final String instanceHost;
  final bool fullPost;

  PostWidget(this.post, {this.fullPost = false})
      : instanceHost = post.instanceHost;

  // == ACTIONS ==

  static void showMoreMenu({
    required BuildContext context,
    required PostView post,
    bool fullPost = false,
  }) {
    final isMine = context
            .read<AccountsStore>()
            .defaultUserDataFor(post.instanceHost)
            ?.userId ==
        post.creator.id;

    showBottomModal(
      context: context,
      builder: (context) => Column(
        children: [
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: const Text('Open in browser'),
            onTap: () async => await ul.canLaunch(post.post.apId)
                ? ul.launch(post.post.apId)
                : ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("can't open in browser"))),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Nerd stuff'),
            onTap: () {
              showInfoTablePopup(context: context, table: {
                '% of upvotes':
                    '${(100 * (post.counts.upvotes / (post.counts.upvotes + post.counts.downvotes))).toInt()}%',
                ...post.toJson(),
              });
            },
          ),
          if (isMine)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () async {
                final postView = await showCupertinoModalPopup<PostView>(
                  context: context,
                  builder: (_) => CreatePostPage.edit(post.post),
                );

                if (postView != null) {
                  Navigator.of(context).pop();
                  if (fullPost) {
                    await goToReplace(
                      context,
                      (_) => FullPostPage.fromPostView(postView),
                    );
                  } else {
                    await goTo(
                      context,
                      (_) => FullPostPage.fromPostView(postView),
                    );
                  }
                }
              },
            ),
        ],
      ),
    );
  }

  // == UI ==

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void _openLink(String url) =>
        linkLauncher(context: context, url: url, instanceHost: instanceHost);

    final urlDomain = () {
      if (whatType(post.post.url) == MediaType.none) return null;

      return urlHost(post.post.url!);
    }();

    /// assemble info section
    Widget info() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (post.community.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => goToCommunity.byId(
                                context, instanceHost, post.community.id),
                            child: Avatar(
                              url: post.community.icon,
                              noBlank: true,
                              radius: 20,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          RichText(
                            overflow:
                                TextOverflow.ellipsis, // TODO: fix overflowing
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 15,
                                  color: theme.textTheme.bodyText1?.color),
                              children: [
                                const TextSpan(
                                    text: '!',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: post.community.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => goToCommunity.byId(
                                          context,
                                          instanceHost,
                                          post.community.id)),
                                const TextSpan(
                                    text: '@',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: post.post.originInstanceHost,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => goToInstance(context,
                                          post.post.originInstanceHost)),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: 13,
                                  color: theme.textTheme.bodyText1?.color),
                              children: [
                                TextSpan(
                                  text: L10n.of(context)!.by,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                                TextSpan(
                                  text: ' ${post.creator.originPreferredName}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => goToUser.fromPersonSafe(
                                          context,
                                          post.creator,
                                        ),
                                ),
                                TextSpan(
                                    text:
                                        ' · ${post.post.published.fancyShort}'),
                                if (post.post.locked)
                                  const TextSpan(text: ' · 🔒'),
                                if (post.post.stickied)
                                  const TextSpan(text: ' · 📌'),
                                if (post.post.nsfw) const TextSpan(text: ' · '),
                                if (post.post.nsfw)
                                  TextSpan(
                                      text: L10n.of(context)!.nsfw,
                                      style:
                                          const TextStyle(color: Colors.red)),
                                if (urlDomain != null)
                                  TextSpan(text: ' · $urlDomain'),
                                if (post.post.removed)
                                  const TextSpan(text: ' · REMOVED'),
                                if (post.post.deleted)
                                  const TextSpan(text: ' · DELETED'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (!fullPost)
                    Column(
                      children: [
                        IconButton(
                          onPressed: () =>
                              showMoreMenu(context: context, post: post),
                          icon: Icon(moreIcon),
                          padding: const EdgeInsets.all(0),
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    )
                ],
              ),
            ),
          ],
        );

    /// assemble title section
    Widget title() => Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              Expanded(
                flex: 100,
                child: Text(
                  post.post.name,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              if (whatType(post.post.url) == MediaType.other &&
                  post.post.thumbnailUrl != null) ...[
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openLink(post.post.url!),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: post.post.thumbnailUrl!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Text(error.toString()),
                        ),
                      ),
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.launch,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                )
              ]
            ],
          ),
        );

    /// assemble link preview
    Widget linkPreview() {
      assert(post.post.url != null);

      return Padding(
        padding: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () => _openLink(post.post.url!),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).iconTheme.color!.withAlpha(170)),
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text('$urlDomain ',
                          style: theme.textTheme.caption
                              ?.apply(fontStyle: FontStyle.italic)),
                      const Icon(Icons.launch, size: 12),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          post.post.embedTitle ?? '',
                          style: theme.textTheme.subtitle1
                              ?.apply(fontWeightDelta: 2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  if (post.post.embedDescription != null &&
                      post.post.embedDescription!.isNotEmpty)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            post.post.embedDescription!,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    /// assemble image
    Widget postImage() {
      assert(post.post.url != null);

      return FullscreenableImage(
        url: post.post.url!,
        child: CachedNetworkImage(
          imageUrl: post.post.url!,
          errorWidget: (_, __, ___) => const Icon(Icons.warning),
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
              const Icon(Icons.comment),
              const SizedBox(width: 6),
              Expanded(
                flex: 999,
                child: Text(
                  L10n.of(context)!.number_of_comments(post.counts.comments),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              const Spacer(),
              if (!fullPost)
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => share(post.post.apId, context: context),
                ),
              if (!fullPost) SavePostButton(post),
              _Voting(post),
            ],
          ),
        );

    return Container(
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black45)],
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: fullPost
            ? null
            : () => goTo(context, (context) => FullPostPage.fromPostView(post)),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              info(),
              title(),
              if (whatType(post.post.url) != MediaType.other &&
                  whatType(post.post.url) != MediaType.none)
                postImage()
              else if (post.post.url != null && post.post.url!.isNotEmpty)
                linkPreview(),
              if (post.post.body != null && fullPost)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: MarkdownText(
                    post.post.body!,
                    instanceHost: instanceHost,
                    selectable: true,
                  ),
                ),
              if (post.post.body != null && !fullPost)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final span = TextSpan(
                      text: post.post.body,
                    );
                    final tp = TextPainter(
                      text: span,
                      maxLines: 10,
                      textDirection: Directionality.of(context),
                    )..layout(maxWidth: constraints.maxWidth - 20);

                    if (tp.didExceedMaxLines) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: tp.height),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor: 0.8,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: MarkdownText(post.post.body!,
                                        instanceHost: instanceHost)),
                              ),
                            ),
                            Container(
                              height: tp.preferredLineHeight * 2.5,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    theme.cardColor.withAlpha(0),
                                    theme.cardColor,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: MarkdownText(post.post.body!,
                              instanceHost: instanceHost));
                    }
                  },
                ),
              actions(),
            ],
          ),
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
    final loading = useDelayedLoading();
    final showScores =
        useConfigStoreSelect((configStore) => configStore.showScores);
    final loggedInAction = useLoggedInAction(post.instanceHost);

    vote(VoteType vote, Jwt token) async {
      final api = LemmyApiV3(post.instanceHost);

      loading.start();
      try {
        final res = await api.run(
            CreatePostLike(postId: post.post.id, score: vote, auth: token.raw));
        myVote.value = res.myVote ?? VoteType.none;
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('voting failed :(')));
        return;
      }
      loading.cancel();
    }

    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
            color: myVote.value == VoteType.up
                ? theme.colorScheme.secondary
                : null,
          ),
          onPressed: loggedInAction(
            (token) => vote(
              myVote.value == VoteType.up ? VoteType.none : VoteType.up,
              token,
            ),
          ),
        ),
        if (loading.loading)
          const SizedBox(
              width: 20, height: 20, child: CircularProgressIndicator())
        else if (showScores)
          Text(NumberFormat.compact()
              .format(post.counts.score + (wasVoted ? 0 : myVote.value.value))),
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
          ),
        ),
      ],
    );
  }
}

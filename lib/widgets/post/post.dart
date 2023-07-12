import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:nested/nested.dart';

import '../../actions/post.dart';
import '../../hooks/logged_in_action.dart';
import '../../pages/full_post/full_post.dart';
import '../../stores/config_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../nsfw_hider.dart';
import '../swipe_actions.dart';
import 'post_actions.dart';
import 'post_body.dart';
import 'post_info_section.dart';
import 'post_link_preview.dart';
import 'post_media.dart';
import 'post_status.dart';
import 'post_store.dart';
import 'post_title.dart';

class PostTile extends StatelessWidget {
  final PostStore postStore;
  final IsFullPost fullPost;

  static const double rounding = 10;

  const PostTile.fromPostStore(this.postStore, {this.fullPost = true});
  PostTile.fromPostView(PostView post, {this.fullPost = false})
      : postStore = PostStore(post);

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: [
        MobxProvider.value(value: postStore),
        Provider.value(value: fullPost),
        AsyncStoreListener(asyncStore: postStore.savingState),
        AsyncStoreListener(asyncStore: postStore.votingState),
        AsyncStoreListener<BlockedPerson>(
          asyncStore: postStore.userBlockingState,
          successMessageBuilder: (context, state) {
            final name = state.personView.person.preferredName;
            return state.blocked ? '$name blocked' : '$name unblocked';
          },
        ),
        AsyncStoreListener<PostReportView>(
          asyncStore: postStore.reportingState,
          successMessageBuilder: (context, data) => 'Post reported',
        ),
      ],
      child: const _Post(),
    );
  }
}

/// A post overview card
class _Post extends HookWidget {
  const _Post();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFullPost = context.read<IsFullPost>();

    final loggedInAction = useLoggedInAction(context
        .select<PostStore, String>((store) => store.postView.instanceHost));

    final postStore = context.read<PostStore>();
    const sensitiveContent = Column(
      children: [
        PostMedia(),
        PostLinkPreview(),
        PostBody(),
      ],
    );
    final possiblyBlurred = postStore.postView.post.nsfw
        ? const NSFWHider(child: sensitiveContent)
        : sensitiveContent;

    return GestureDetector(
      onTap: isFullPost
          ? null
          : () {
              final postStore = context.read<PostStore>();
              Navigator.of(context)
                  .push(FullPostPage.fromPostStoreRoute(postStore));
            },
      child: ObserverBuilder<ConfigStore>(
        builder: (context, store) => WithSwipeActions(
          actions: [
            PostUpvoteAction(post: postStore, context: context),
            PostSaveAction(post: postStore, context: context),
          ],
          onTrigger: (action) => loggedInAction(action.invoke)(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: store.postCardShadow
                  ? const [BoxShadow(blurRadius: 15, color: Colors.black45)]
                  : null,
              color: theme.cardColor,
              borderRadius: store.postRoundedCorners
                  ? const BorderRadius.all(Radius.circular(PostTile.rounding))
                  : const BorderRadius.all(Radius.circular(5)),
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Column(
                children: [
                  if (isFullPost) ...[
                    const PostInfoSection(),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(children: [
                          const PostTitle(),
                          possiblyBlurred,
                          const PostActions(),
                        ]),
                      ),
                    ),
                  ] else if (store.compactPostView) ...[
                    const PostInfoSection(),
                    const PostTitle(),
                    const PostActions(),
                  ] else ...[
                    const PostInfoSection(),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            const PostTitle(),
                            possiblyBlurred,
                            const PostActions(),
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

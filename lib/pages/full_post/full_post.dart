import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:nested/nested.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../hooks/logged_in_action.dart';
import '../../stores/accounts_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/icons.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../util/share.dart';
import '../../widgets/failed_to_load.dart';
import '../../widgets/post/post.dart';
import '../../widgets/post/post_more_menu.dart';
import '../../widgets/post/post_store.dart';
import '../../widgets/post/save_post_button.dart';
import '../../widgets/pull_to_refresh.dart';
import '../../widgets/reveal_after_scroll.dart';
import '../../widgets/write_comment.dart';
import 'comment_section.dart';
import 'full_post_store.dart';

/// Displays a post with its comment section
class FullPostPage extends HookWidget {
  const FullPostPage._();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final shareButtonKey = GlobalKey();
    var scrollOffset = 0.0;

    final loggedInAction =
        useLoggedInAction(context.read<FullPostStore>().instanceHost);

    return Nested(
      children: [
        AsyncStoreListener(
          asyncStore: context.read<FullPostStore>().fullPostState,
        ),
        AsyncStoreListener<BlockedCommunity>(
          asyncStore: context.read<FullPostStore>().communityBlockingState,
          successMessageBuilder: (context, data) {
            final name = data.communityView.community.originPreferredName;
            return '${data.blocked ? 'Blocked' : 'Unblocked'} $name';
          },
        ),
      ],
      child: ObserverBuilder<FullPostStore>(
        builder: (context, store) {
          final postStore = store.postStore;

          if (postStore == null) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: (store.fullPostState.errorTerm == null)
                    ? const CircularProgressIndicator.adaptive()
                    : FailedToLoad(
                        message: 'Post failed to load', refresh: store.refresh),
              ),
            );
          }

          final post = postStore.postView;

          // VARIABLES

          sharePost() {
            final renderbox =
                shareButtonKey.currentContext!.findRenderObject()! as RenderBox;
            final position = renderbox.localToGlobal(Offset.zero);

            return share(post.post.apId,
                context: context,
                sharePositionOrigin: Rect.fromPoints(
                    position,
                    position.translate(
                        renderbox.size.width, renderbox.size.height)));
          }

          comment() async {
            final newComment = await Navigator.of(context).push(
              WriteComment.toPostRoute(post.post),
            );

            if (newComment != null) {
              store.addComment(newComment);
            }
          }

          tapScrollAction() {
            var targetOffset = 0.0;
            if (scrollController.offset != 0) {
              scrollOffset = scrollController.offset;
            } else {
              targetOffset = scrollOffset;
            }
            scrollController.animateTo(targetOffset,
                duration: const Duration(milliseconds: 100),
                curve: Curves.bounceInOut);
          }

          return Scaffold(
            appBar: AppBar(
              flexibleSpace: GestureDetector(
                onTap: tapScrollAction,
              ),
              centerTitle: false,
              title: GestureDetector(
                onTap: tapScrollAction,
                child: RevealAfterScroll(
                  scrollController: scrollController,
                  after: 65,
                  child: Text(
                    '${post.community.originPreferredName} > '
                    '"${post.post.name}"',
                    overflow: TextOverflow.fade,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  key: shareButtonKey,
                  icon: Icon(shareIcon),
                  onPressed: sharePost,
                ),
                MobxProvider.value(
                  value: postStore,
                  child: const SavePostButton(),
                ),
                if (!Platform.isAndroid && !post.post.locked)
                  IconButton(
                    onPressed: loggedInAction((_) => comment()),
                    icon: const Icon(Icons.reply),
                  ),
                IconButton(
                  icon: Icon(moreIcon),
                  onPressed: () => PostMoreMenuButton.show(
                    context: context,
                    postStore: postStore,
                    fullPostStore: store,
                  ),
                ),
              ],
            ),
            floatingActionButton: !Platform.isAndroid || post.post.locked
                ? null
                : FloatingActionButton(
                    onPressed: loggedInAction((_) => comment()),
                    child: const Icon(Icons.comment),
                  ),
            body: PullToRefresh(
              onRefresh: store.refresh,
              child: ListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 15),
                  PostTile.fromPostStore(postStore),
                  ...CommentSection.buildComments(context, store),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  static UserData? _tryGetUserData(BuildContext context, String instanceHost) {
    return context.read<AccountsStore>().defaultUserDataFor(instanceHost);
  }

  static Route route(int id, String instanceHost, {int? commentId}) =>
      SwipeablePageRoute(
        builder: (context) => MobxProvider(
          create: (context) => FullPostStore(
              instanceHost: instanceHost, postId: id, commentId: commentId)
            ..refresh(_tryGetUserData(context, instanceHost)),
          child: const FullPostPage._(),
        ),
      );

  static Route fromPostViewRoute(PostView postView, {int? commentId}) =>
      SwipeablePageRoute(
        builder: (context) => MobxProvider(
          create: (context) =>
              FullPostStore.fromPostView(postView, commentId: commentId)
                ..refresh(_tryGetUserData(context, postView.instanceHost)),
          child: const FullPostPage._(),
        ),
      );
  static Route fromPostStoreRoute(PostStore postStore) => SwipeablePageRoute(
        builder: (context) => MobxProvider(
          create: (context) => FullPostStore.fromPostStore(postStore)
            ..refresh(
                _tryGetUserData(context, postStore.postView.instanceHost)),
          child: const FullPostPage._(),
        ),
      );
}

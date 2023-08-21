import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:nested/nested.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/icons.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/failed_to_load.dart';
import '../../widgets/post/post.dart';
import '../../widgets/post/post_more_menu.dart';
import '../../widgets/post/post_store.dart';
import '../../widgets/pull_to_refresh.dart';
import '../../widgets/write_comment.dart';
import '../federation_resolver.dart';
import '../view_on_menu.dart';
import 'comment_section.dart';
import 'full_post_store.dart';

/// Displays a post with its comment section
class FullPostPage extends HookWidget {
  const FullPostPage._();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final fullPostStore = context.read<FullPostStore>();
    var scrollOffset = 0.0;

    final replyLoggedInAction = useLoggedInAction(fullPostStore.instanceHost,
        fallback: () =>
            ViewOnMenu.openForPost(context, fullPostStore.postView!.post.apId));

    return Nested(
      children: [
        AsyncStoreListener(
          asyncStore: fullPostStore.fullPostState,
        ),
        AsyncStoreListener<BlockedCommunity>(
          asyncStore: fullPostStore.communityBlockingState,
          successMessageBuilder: (context, data) {
            final name = data.communityView.community.originPreferredName;
            return '${data.blocked ?
              L10n.of(context).blocked : L10n.of(context).unblocked} $name';
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
              leadingWidth: 25,
              title: GestureDetector(
                onTap: tapScrollAction,
                child: Text(
                  '${post.community.originPreferredName}: '
                  '"${post.post.name}"',
                  overflow: TextOverflow.fade,
                ),
              ),
              actions: [
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
                    onPressed: replyLoggedInAction((_) => comment()),
                    child: const Icon(Icons.comment),
                  ),
            body: PullToRefresh(
              onRefresh: store.refresh,
              child: ListView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 15),
                  PostTile.fromPostStore(postStore, fullPost: true),
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
  static Route fromApIdRoute(UserData userData, String apId,
          {bool isSingleComment = false}) =>
      SwipeablePageRoute(
        builder: (context) {
          return FederationResolver(
              userData: userData,
              query: apId,
              loadingMessage: L10n.of(context).federated_post_info,
              exists: (response) => isSingleComment
                  ? response.comment != null
                  : response.post != null,
              builder: (buildContext, object) => MobxProvider(
                  create: (context) => FullPostStore(
                      instanceHost: userData.instanceHost,
                      postId: isSingleComment
                          ? object.comment!.post.id
                          : object.post!.post.id,
                      commentId:
                          isSingleComment ? object.comment!.comment.id : null)
                    ..refresh(userData),
                  child: const FullPostPage._()));
        },
      );
}

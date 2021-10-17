import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../hooks/logged_in_action.dart';
import '../../stores/accounts_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/icons.dart';
import '../../util/observer_consumers.dart';
import '../../util/share.dart';
import '../../widgets/post/post.dart';
import '../../widgets/post/post_more_menu.dart';
import '../../widgets/post/post_store.dart';
import '../../widgets/post/save_post_button.dart';
import '../../widgets/reveal_after_scroll.dart';
import '../../widgets/write_comment.dart';
import 'comment_section.dart';
import 'full_post_store.dart';

class FullPostPage extends StatelessWidget {
  final String? instanceHost;
  final int? id;
  final PostView? postView;
  final PostStore? postStore;

  const FullPostPage({
    required int this.id,
    required String this.instanceHost,
  })  : postView = null,
        postStore = null;
  const FullPostPage.fromPostView(PostView this.postView)
      : id = null,
        instanceHost = null,
        postStore = null;
  const FullPostPage.fromPostStore(PostStore this.postStore)
      : id = null,
        instanceHost = null,
        postView = null;

  @override
  Widget build(BuildContext context) {
    return AsyncStoreListener(
      asyncStore: context.read<FullPostStore>().fullPostState,
      child: AsyncStoreListener<BlockedCommunity>(
        asyncStore: context.read<FullPostStore>().communityBlockingState,
        successMessageBuilder: (context, data) {
          final name = data.communityView.community.originPreferredName;
          return '${data.blocked ? 'Blocked' : 'Unblocked'} $name';
        },
        child: const _FullPostPage(),
      ),
    );
  }

  static Jwt? _tryGetJwt(BuildContext context) {
    final store = context.read<FullPostStore>();
    return context
        .read<AccountsStore>()
        .defaultUserDataFor(store.instanceHost)
        ?.jwt;
  }

  static Route route(int id, String instanceHost) => MaterialPageRoute(
        builder: (context) => Provider(
          create: (context) =>
              FullPostStore(instanceHost: instanceHost, postId: id)
                ..refresh(_tryGetJwt(context)),
          child: FullPostPage(
            id: id,
            instanceHost: instanceHost,
          ),
        ),
      );

  static Route fromPostViewRoute(PostView postView) => MaterialPageRoute(
        builder: (context) => Provider(
          create: (context) => FullPostStore.fromPostView(postView)
            ..refresh(_tryGetJwt(context)),
          child: FullPostPage.fromPostView(postView),
        ),
      );
  static Route fromPostStoreRoute(PostStore postStore) => MaterialPageRoute(
        builder: (context) => Provider(
            create: (context) => FullPostStore.fromPostStore(postStore)
              ..refresh(_tryGetJwt(context)),
            child: FullPostPage.fromPostStore(postStore)),
      );
}

/// Displays a post with its comment section
class _FullPostPage extends HookWidget {
  const _FullPostPage();

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    final loggedInAction =
        useLoggedInAction(context.read<FullPostStore>().instanceHost);

    return AsyncStoreListener(
      asyncStore: context.read<FullPostStore>().fullPostState,
      child: AsyncStoreListener<BlockedCommunity>(
        asyncStore: context.read<FullPostStore>().communityBlockingState,
        successMessageBuilder: (context, data) {
          final name = data.communityView.community.originPreferredName;
          return '${data.blocked ? 'Blocked' : 'Unblocked'} $name';
        },
        child: ObserverBuilder<FullPostStore>(
          builder: (context, store) {
            Future<void> refresh() async {
              unawaited(HapticFeedback.mediumImpact());
              await store.refresh(context
                  .read<AccountsStore>()
                  .defaultUserDataFor(store.instanceHost)
                  ?.jwt);
            }

            final post = store.postView;

            if (post == null) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: (store.fullPostState.isLoading)
                      ? const CircularProgressIndicator.adaptive()
                      : FailedToLoad(
                          message: 'Post failed to load', refresh: refresh),
                ),
              );
            }

            // VARIABLES

            sharePost() => share(post.post.apId, context: context);

            comment() async {
              final newComment = await Navigator.of(context).push(
                WriteComment.toPostRoute(post.post),
              );

              if (newComment != null) {
                store.addComment(newComment);
              }
            }

            return Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  title: RevealAfterScroll(
                    scrollController: scrollController,
                    after: 65,
                    child: Text(
                      post.community.originPreferredName,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  actions: [
                    IconButton(icon: Icon(shareIcon), onPressed: sharePost),
                    Provider.value(
                      value: store.postStore!,
                      child: const SavePostButton(),
                    ),
                    IconButton(
                      icon: Icon(moreIcon),
                      onPressed: () => PostMoreMenuButton.show(
                        context: context,
                        postStore: store.postStore!,
                        fullPostStore: store,
                      ),
                    ),
                  ],
                ),
                floatingActionButton: post.post.locked
                    ? null
                    : FloatingActionButton(
                        onPressed: loggedInAction((_) => comment()),
                        child: const Icon(Icons.comment),
                      ),
                body: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 15),
                      PostTile.fromPostStore(store.postStore!),
                      const CommentSection(),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}

class FailedToLoad extends StatelessWidget {
  final String message;
  final VoidCallback refresh;

  const FailedToLoad({required this.refresh, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(height: 5),
        ElevatedButton.icon(
          onPressed: refresh,
          icon: const Icon(Icons.refresh),
          label: const Text('try again'),
        )
      ],
    );
  }
}

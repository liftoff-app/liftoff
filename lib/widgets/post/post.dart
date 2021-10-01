import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../pages/full_post/full_post.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/goto.dart';
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

  const PostTile.fromPostStore(this.postStore, {this.fullPost = true});
  PostTile.fromPostView(PostView post, {this.fullPost = false})
      : postStore = PostStore(post);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PostStore>(create: (_) => postStore),
        Provider<IsFullPost>(create: (_) => fullPost),
      ],
      builder: (context, child) {
        return AsyncStoreListener(
          asyncStore: context.read<PostStore>().savingState,
          child: AsyncStoreListener(
            asyncStore: context.read<PostStore>().votingState,
            child: AsyncStoreListener<BlockedPerson>(
              asyncStore: context.read<PostStore>().userBlockingState,
              successMessageBuilder: (context, state) {
                final name = state.data.personView.person.preferredName;
                return state.data.blocked ? '$name blocked' : '$name unblocked';
              },
              child: const _Post(),
            ),
          ),
        );
      },
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

    return Container(
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black45)],
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: GestureDetector(
        onTap: isFullPost
            ? null
            : () {
                final postStore = context.read<PostStore>();
                goTo(
                  context,
                  (context) => FullPostPage.fromPostStore(postStore),
                );
              },
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            children: const [
              PostInfoSection(),
              PostTitle(),
              PostMedia(),
              PostLinkPreview(),
              PostBody(),
              PostActions(),
            ],
          ),
        ),
      ),
    );
  }
}

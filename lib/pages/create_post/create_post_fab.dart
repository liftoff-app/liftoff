import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/logged_in_action.dart';
import '../full_post/full_post.dart';
import 'create_post.dart';

/// Fab that triggers the [CreatePost] modal
/// After creation it will navigate to the newly created post
class CreatePostFab extends HookWidget {
  final CommunityView? community;

  const CreatePostFab({super.key, this.community});

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useAnyLoggedInAction();

    return FloatingActionButton(
      onPressed: loggedInAction((_) async {
        final postView = await Navigator.of(context).push(
          community == null
              ? CreatePostPage.route()
              : CreatePostPage.toCommunityRoute(community!),
        );

        if (postView != null && context.mounted) {
          await Navigator.of(context)
              .push(FullPostPage.fromPostViewRoute(postView));
        }
      }),
      child: const Icon(Icons.add),
    );
  }
}

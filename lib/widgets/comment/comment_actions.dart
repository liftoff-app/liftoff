import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../pages/view_on_menu.dart';
import '../../util/goto.dart';
import '../../util/observer_consumers.dart';
import '../tile_action.dart';
import '../tile_toggle.dart';
import '../write_comment.dart';
import 'comment_more_menu_button.dart';
import 'comment_store.dart';

class CommentActions extends HookWidget {
  const CommentActions({super.key});

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<CommentStore>(
      builder: (context, store) {
        if (store.collapsed) return const SizedBox();

        final comment = store.comment.comment;
        final post = store.comment.post;

        showOpenMenu() {
          ViewOnMenu.openForPost(context, store.comment.comment.apId,
              isSingleComment: true);
        }

        reply() async {
          final newComment = await Navigator.of(context).push(
            WriteComment.toCommentRoute(
              user: store.userData!,
              comment: comment,
              post: post,
            ),
          );

          if (newComment != null) {
            store.addReply(newComment);
          }
        }

        return Row(
          children: [
            if (store.selectable && !comment.deleted && !comment.removed)
              TileAction(
                icon: Icons.content_copy,
                tooltip: 'copy',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: comment.content));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('comment copied to clipboard'),
                      ),
                    );
                  }
                },
              ),
            const Spacer(),
            if (store.canBeMarkedAsRead && store.isAuthenticated)
              TileAction(
                icon: Icons.check,
                onPressed: store.markAsRead,
                iconColor: comment.distinguished
                    ? Theme.of(context).colorScheme.secondary
                    : null,
                tooltip: comment.distinguished
                    ? L10n.of(context).mark_as_unread
                    : L10n.of(context).mark_as_read,
              ),
            const CommentMoreMenuButton(),
            TileAction(
              icon: Icons.link,
              onPressed: () => goToPost(context, comment.instanceHost, post.id,
                  commentId: comment.id),
              tooltip: 'go to post',
            ),
            if (store.isAuthenticated) ...[
              TileAction(
                loading: store.savingState.isLoading,
                icon: store.comment.saved
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                onPressed: store.save,
                tooltip: '${store.comment.saved ? 'unsave' : 'save'} comment',
              ),
              if (!comment.deleted && !comment.removed && !post.locked)
                TileAction(
                  icon: Icons.reply,
                  onPressed: store.isAuthenticated ? reply : showOpenMenu,
                  tooltip: L10n.of(context).reply,
                ),
            ],
            TileToggle(
              icon: Icons.arrow_upward,
              activated: store.myVote == VoteType.up,
              activeColor: Colors.blue,
              onPressed: store.isAuthenticated ? store.upVote : showOpenMenu,
              tooltip: 'upvote',
            ),
            TileToggle(
              icon: Icons.arrow_downward,
              activated: store.myVote == VoteType.down,
              activeColor: Colors.orange,
              onPressed: store.isAuthenticated ? store.downVote : showOpenMenu,
              tooltip: 'downvote',
            ),
          ],
        );
      },
    );
  }
}

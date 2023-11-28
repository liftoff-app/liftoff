import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../util/icons.dart';
import '../../util/observer_consumers.dart';
import '../../util/share.dart';
import '../write_comment.dart';
import 'post_more_menu.dart';
import 'post_store.dart';
import 'post_voting.dart';
import 'save_post_button.dart';

class PostActions extends HookWidget {
  const PostActions({super.key});

  @override
  Widget build(BuildContext context) {
    final postStore = context.read<PostStore>();
    final replyLoggedInAction =
        useLoggedInAction(postStore.postView.instanceHost);

    final shareButtonKey = GlobalKey();
    // assemble actions section
    return ObserverBuilder<PostStore>(builder: (context, store) {
      comment() async {
        final newComment = await Navigator.of(context).push(
          WriteComment.toPostRoute(store.postView.post),
        );

        if (newComment != null) {
          postStore.addComment(newComment);
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            const Icon(Icons.comment_rounded),
            const SizedBox(width: 6),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraint) {
                  // If the space is too small for the word
                  // "comments" to display fully, don't show it.
                  final txt = (constraint.maxWidth < 100.0)
                      ? store.postView.counts.comments.toString()
                      : L10n.of(context).number_of_comments(
                          store.postView.counts.comments,
                          store.postView.counts.comments);

                  return Text(
                    txt,
                    softWrap: false,
                  );
                },
              ),
            ),
            const PostMoreMenuButton(),
            IconButton(
              key: shareButtonKey,
              icon: Icon(shareIcon),
              onPressed: () {
                final renderbox = shareButtonKey.currentContext!
                    .findRenderObject()! as RenderBox;
                final position = renderbox.localToGlobal(Offset.zero);
                share(store.postView.post.apId,
                    context: context,
                    sharePositionOrigin: Rect.fromPoints(
                        position,
                        position.translate(
                            renderbox.size.width, renderbox.size.height)));
              },
            ),
            const SavePostButton(),
            if (!store.postView.post.locked)
              IconButton(
                onPressed: replyLoggedInAction((_) => comment()),
                icon: const Icon(Icons.reply),
              ),
            const PostVoting(),
          ],
        ),
      );
    });
  }
}

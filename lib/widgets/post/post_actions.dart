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

class PostActions extends HookWidget {
  const PostActions();

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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Icon(Icons.comment_rounded),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                L10n.of(context).number_of_comments(
                    store.postView.counts.comments,
                    store.postView.counts.comments),
                overflow: TextOverflow.fade,
                softWrap: false,
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

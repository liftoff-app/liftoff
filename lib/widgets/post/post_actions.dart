import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../l10n/l10n.dart';
import '../../util/icons.dart';
import '../../util/observer_consumers.dart';
import '../../util/share.dart';
import 'post_status.dart';
import 'post_store.dart';
import 'post_voting.dart';
import 'save_post_button.dart';

class PostActions extends HookWidget {
  const PostActions();

  @override
  Widget build(BuildContext context) {
    final fullPost = context.read<IsFullPost>();
    final shareButtonKey = GlobalKey();
    // assemble actions section
    return ObserverBuilder<PostStore>(builder: (context, store) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            if (!fullPost)
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
            if (!fullPost) const SavePostButton(),
            const PostVoting(),
          ],
        ),
      );
    });
  }
}

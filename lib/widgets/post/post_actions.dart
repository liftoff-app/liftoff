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

    // assemble actions section
    return ObserverBuilder<PostStore>(builder: (context, store) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            const Icon(Icons.comment),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                L10n.of(context)
                    .number_of_comments(store.postView.counts.comments),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
            ),
            if (!fullPost)
              IconButton(
                icon: Icon(shareIcon),
                onPressed: () =>
                    share(store.postView.post.apId, context: context),
              ),
            if (!fullPost) const SavePostButton(),
            const PostVoting(),
          ],
        ),
      );
    });
  }
}

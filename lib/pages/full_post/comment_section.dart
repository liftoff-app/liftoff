import 'package:flutter/material.dart';
import '../../stores/accounts_store.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_safe.dart';
import '../../widgets/comment/comment.dart';
import '../../widgets/comment_list_options.dart';
import '../../widgets/failed_to_load.dart';
import 'full_post_store.dart';

/// Manages comments section, sorts them
class CommentSection {
  static List<Widget> buildComments(BuildContext context, FullPostStore store) {
    final sort = store.sorting;

    final fullPostView = store.fullPostView;
    final postComments = store.postComments;

    // error & spinner handling
    if (fullPostView == null) {
      if (store.fullPostState.errorTerm != null) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: FailedToLoad(
                message: 'ERROR: Comments failed to load. '
                    '${store.fullPostState.errorTerm}',
                refresh: () => store.refresh(context
                    .read<AccountsStore>()
                    .defaultUserDataFor(store.instanceHost)
                    ?.jwt)),
          )
        ];
      } else {
        return [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        ];
      }
    }

    return [
      CommentListOptions(onSortChanged: store.updateSorting, sortValue: sort),
      // sorting menu goes here
      if (postComments != null && postComments.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Text(
            'no comments yet',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        )
      else ...[
        for (final com in store.pinnedComments!)
          _centeredWithConstraints(
            child: CommentWidget.fromCommentView(
              com,
              key: ValueKey(com),
            ),
          ),
        for (final com in store.newComments)
          _centeredWithConstraints(
            child: CommentWidget.fromCommentView(
              com,
              detached: false,
              key: ValueKey(com),
            ),
          ),
        // if (store.sorting == CommentSortType.chat)
        //   for (final com in postComments!)
        //     CommentWidget.fromCommentView(
        //       com,
        //       detached: false,
        //       key: ValueKey(com),
        //     )
        // else
        for (final com in store.sortedCommentTree!)
          _centeredWithConstraints(
            child: CommentWidget(
              com,
              key: ValueKey(com),
            ),
          ),
        const BottomSafe.fab(),
      ]
    ];
  }

  static Widget _centeredWithConstraints({required Widget child}) => Center(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), child: child));
}

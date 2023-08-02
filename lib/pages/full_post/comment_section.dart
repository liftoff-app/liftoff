import 'package:flutter/material.dart';
import '../../l10n/l10n.dart';
import '../../widgets/bottom_safe.dart';
import '../../widgets/comment/comment.dart';
import '../../widgets/comment_list_options.dart';
import '../../widgets/failed_to_load.dart';
import 'full_post.dart';
import 'full_post_store.dart';

/// Manages comments section, sorts them
class CommentSection {
  static List<Widget> buildComments(BuildContext context, FullPostStore store) {
    final sort = store.sorting;

    final fullPostView = store.fullPostView;
    final postComments = store.postComments;
    final newComments = store.newComments;

    // error & spinner handling
    if (fullPostView == null) {
      if (store.fullPostState.errorTerm != null) {
        return [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
            child: FailedToLoad(
                message: 'ERROR: Comments failed to load. '
                    '${store.fullPostState.errorTerm}',
                refresh: store.refresh),
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
      if (store.commentId != null) ...[
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            children: [
              OutlinedButton(
                child: Text(L10n.of(context).view_all_comments),
                onPressed: () => Navigator.of(context).push(
                    FullPostPage.fromPostViewRoute(fullPostView.postView)),
              ),
              if (store.postComments![0].comment.path.split('.').length >
                  2) ...[
                Container(width: 8),
                OutlinedButton(
                  child: Text(L10n.of(context).show_context),
                  onPressed: () => Navigator.of(context).push(
                      FullPostPage.fromPostViewRoute(fullPostView.postView,
                          commentId: int.parse(store
                              .postComments![0].comment.path
                              .split('.')[1]))),
                )
              ],
            ],
          ),
        )
      ],
      // sorting menu goes here
      if (postComments != null && postComments.isEmpty && newComments.isEmpty)
        _centeredWithConstraints(
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: Text(
              'no comments yet',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
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
              userData: store.userData,
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

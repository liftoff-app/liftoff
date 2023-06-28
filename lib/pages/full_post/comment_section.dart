import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../hooks/stores.dart';
import '../../stores/accounts_store.dart';
import '../../stores/config_store.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_safe.dart';
import '../../widgets/comment/comment.dart';
import '../../widgets/comment_list_options.dart';
import '../../widgets/failed_to_load.dart';
import 'full_post_store.dart';

/// Manages comments section, sorts them
class CommentSection extends HookWidget {
  const CommentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultCommentSort =
        useStore((ConfigStore store) => store.defaultCommentSort);

    final sort = useState(defaultCommentSort);

    return ObserverBuilder<FullPostStore>(
      builder: (context, store) {
        final fullPostView = store.fullPostView;
        final postComments = store.postComments;

        // error & spinner handling
        if (fullPostView == null) {
          if (store.fullPostState.errorTerm != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: FailedToLoad(
                  message: 'ERROR: Comments failed to load. '
                      '${store.fullPostState.errorTerm}',
                  refresh: () => store.refresh(context
                      .read<AccountsStore>()
                      .defaultUserDataFor(store.instanceHost)
                      ?.jwt)),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                CommentListOptions(
                    onSortChanged: (newSort) {
                      sort.value = newSort;
                      store.updateSorting(newSort);
                    },
                    sortValue: sort.value),
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
                    CommentWidget.fromCommentView(
                      com,
                      key: ValueKey(com),
                    ),
                  for (final com in store.newComments)
                    CommentWidget.fromCommentView(
                      com,
                      detached: false,
                      key: ValueKey(com),
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
                    CommentWidget(
                      com,
                      key: ValueKey(com),
                    ),
                  const BottomSafe.fab(),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

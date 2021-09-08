import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../comment_tree.dart';
import '../l10n/l10n.dart';
import 'bottom_modal.dart';
import 'bottom_safe.dart';
import 'comment/comment.dart';

/// Manages comments section, sorts them
class CommentSection extends HookWidget {
  final List<CommentView> rawComments;
  final List<CommentTree> comments;
  final int postCreatorId;
  final CommentSortType sortType;

  static const sortPairs = {
    CommentSortType.hot: [Icons.whatshot, L10nStrings.hot],
    CommentSortType.new_: [Icons.new_releases, L10nStrings.new_],
    CommentSortType.old: [Icons.calendar_today, L10nStrings.old],
    CommentSortType.top: [Icons.trending_up, L10nStrings.top],
    CommentSortType.chat: [Icons.chat, L10nStrings.chat],
  };

  CommentSection(
    List<CommentView> rawComments, {
    required this.postCreatorId,
    this.sortType = CommentSortType.hot,
  })  : comments =
            CommentTree.sortList(sortType, CommentTree.fromList(rawComments)),
        rawComments = rawComments
          ..sort((b, a) => a.comment.published.compareTo(b.comment.published));

  @override
  Widget build(BuildContext context) {
    final sorting = useState(sortType);

    void sortComments(CommentSortType sort) {
      if (sort != sorting.value && sort != CommentSortType.chat) {
        CommentTree.sortList(sort, comments);
      }

      sorting.value = sort;
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () {
                showBottomModal(
                  title: 'sort by',
                  context: context,
                  builder: (context) => Column(
                    children: [
                      for (final e in sortPairs.entries)
                        ListTile(
                          leading: Icon(e.value[0] as IconData),
                          title: Text((e.value[1] as String).tr(context)),
                          trailing: sorting.value == e.key
                              ? const Icon(Icons.check)
                              : null,
                          onTap: () {
                            Navigator.of(context).pop();
                            sortComments(e.key);
                          },
                        )
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Text((sortPairs[sorting.value]![1] as String).tr(context)),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      // sorting menu goes here
      if (comments.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Text(
            'no comments yet',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        )
      else if (sorting.value == CommentSortType.chat)
        for (final com in rawComments)
          CommentWidget.fromCommentView(
            com,
            detached: false,
            key: ValueKey(com),
          )
      else
        for (final com in comments)
          CommentWidget(
            com,
            key: ValueKey(com),
          ),
      const BottomSafe(kMinInteractiveDimension + kFloatingActionButtonMargin),
    ]);
  }
}

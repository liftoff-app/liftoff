import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';

import '../comment_tree.dart';
import 'bottom_modal.dart';
import 'bottom_safe.dart';
import 'comment.dart';

/// Manages comments section, sorts them
class CommentSection extends HookWidget {
  final List<CommentView> rawComments;
  final List<CommentTree> comments;
  final int postCreatorId;
  final CommentSortType sortType;

  static const sortPairs = {
    CommentSortType.hot: [Icons.whatshot, 'Hot'],
    CommentSortType.new_: [Icons.new_releases, 'New'],
    CommentSortType.old: [Icons.calendar_today, 'Old'],
    CommentSortType.top: [Icons.trending_up, 'Top'],
    CommentSortType.chat: [Icons.chat, 'Chat'],
  };

  CommentSection(
    List<CommentView> rawComments, {
    @required this.postCreatorId,
    this.sortType = CommentSortType.hot,
  })  : comments =
            CommentTree.sortList(sortType, CommentTree.fromList(rawComments)),
        rawComments = rawComments
          ..sort((b, a) => a.comment.published.compareTo(b.comment.published)),
        assert(postCreatorId != null);

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
                          title: Text(e.value[1] as String),
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
                  Text(sortPairs[sorting.value][1] as String),
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
          CommentWidget(
            CommentTree(com),
            postCreatorId: postCreatorId,
          )
      else
        for (final com in comments)
          CommentWidget(com, postCreatorId: postCreatorId),
      const BottomSafe(kMinInteractiveDimension + kFloatingActionButtonMargin),
    ]);
  }
}

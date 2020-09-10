import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../comment_tree.dart';
import 'bottom_modal.dart';
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
          ..sort((b, a) => a.published.compareTo(b.published)),
        assert(postCreatorId != null);

  @override
  Widget build(BuildContext context) {
    var sorting = useState(sortType);
    var rawComms = useState(rawComments);
    var comms = useState(comments);

    void sortComments(CommentSortType sort) {
      if (sort != sorting.value && sort != CommentSortType.chat) {
        CommentTree.sortList(sort, comms.value);
      }

      sorting.value = sort;
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            OutlineButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => BottomModal(
                          title: 'sort by',
                          child: Column(
                            children: [
                              for (final e in sortPairs.entries)
                                ListTile(
                                  leading: Icon(e.value[0]),
                                  title: Text(e.value[1]),
                                  trailing: sorting.value == e.key
                                      ? Icon(Icons.check)
                                      : null,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    sortComments(e.key);
                                  },
                                )
                            ],
                          ),
                        ));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(sortPairs[sorting.value][1]),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            Spacer(),
          ],
        ),
      ),
      // sorting menu goes here
      if (comments.isEmpty)
        Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Text(
            'no comments yet',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        )
      else if (sorting.value == CommentSortType.chat)
        for (final com in rawComms.value)
          Comment(
            CommentTree(com),
            postCreatorId: postCreatorId,
          )
      else
        for (var com in comms.value) Comment(com, postCreatorId: postCreatorId),
    ]);
  }
}

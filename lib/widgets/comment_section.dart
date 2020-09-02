import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../comment_tree.dart';
import 'comment.dart';

/// Manages comments section, sorts them
class CommentSection extends HookWidget {
  final List<CommentView> rawComments;
  final List<CommentTree> comments;
  final int postCreatorId;

  CommentSection(this.rawComments, {@required this.postCreatorId})
      : comments = CommentTree.fromList(rawComments),
        assert(postCreatorId != null);

  @override
  Widget build(BuildContext context) {
    var rawComms = useState(rawComments);
    var comms = useState(comments);
    var sorting = useState(CommentSortType.hot);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: DropdownButton(
                // TODO: change it to universal BottomModal
                underline: Container(),
                isDense: true,
                // ignore: avoid_types_on_closure_parameters
                onChanged: (CommentSortType val) {
                  if (val != sorting.value && val != CommentSortType.chat) {
                    CommentTree.sortList(val, comms.value);
                  } else {
                    rawComms.value
                        .sort((a, b) => a.published.compareTo(b.published));
                  }
                  sorting.value = val;
                },
                value: sorting.value,
                items: [
                  DropdownMenuItem(
                      child: Text('Hot'), value: CommentSortType.hot),
                  DropdownMenuItem(
                      child: Text('Top'), value: CommentSortType.top),
                  DropdownMenuItem(
                      child: Text('New'), value: CommentSortType.new_),
                  DropdownMenuItem(
                      child: Text('Old'), value: CommentSortType.old),
                  DropdownMenuItem(
                      child: Text('Chat'), value: CommentSortType.chat),
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

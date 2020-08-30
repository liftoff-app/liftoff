import 'package:flutter/material.dart';

import 'comment_tree.dart';

class CommentWidget extends StatelessWidget {
  final int indent;
  final CommentTree commentTree;
  CommentWidget(
    this.commentTree, {
    this.indent = 0,
  });

  @override
  Widget build(BuildContext context) {
    var comment = commentTree.comment;
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Row(children: [
                Text(comment.creatorPreferredUsername ?? comment.creatorName),
                Spacer(),
                Text(comment.score.toString()),
              ]),
              Row(children: [
                Flexible(child: Text(commentTree.comment.content)),
              ]),
              Row(children: [
                Spacer(),
                // actions go here
              ])
            ],
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: indent > 1 ? (indent - 1) * 5.0 : 0),
          decoration: BoxDecoration(
              border: Border(
                  left: indent > 0
                      ? BorderSide(color: Colors.red, width: 5)
                      : BorderSide.none,
                  top: BorderSide(width: 0.2))),
        ),
        for (var c in commentTree.children)
          CommentWidget(c, indent: indent + 1),
      ],
    );
  }
}

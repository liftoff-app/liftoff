import 'package:flutter/material.dart';

import 'comment_tree.dart';
import 'markdown_text.dart';

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

    // decide which username to use
    var username;
    if (comment.creatorPreferredUsername != null &&
        comment.creatorPreferredUsername != '') {
      username = comment.creatorPreferredUsername;
    } else {
      username = '@${comment.creatorName}';
    }

    var body;
    if (comment.deleted) {
      body = Flexible(
          child: Text(
        'comment deleted by creator',
        style: TextStyle(fontStyle: FontStyle.italic),
      ));
    } else if (comment.removed) {
      body = Flexible(
          child: Text(
        'comment deleted by moderator',
        style: TextStyle(fontStyle: FontStyle.italic),
      ));
    } else {
      body =
          Flexible(child: MarkdownText(commentTree.comment.content, context));
    }
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
              Row(children: [body]),
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

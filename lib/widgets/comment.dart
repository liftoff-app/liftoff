import 'package:flutter/material.dart';

import 'comment_tree.dart';
import 'markdown_text.dart';

class CommentWidget extends StatelessWidget {
  final int indent;
  final int postCreatorId;
  final CommentTree commentTree;
  CommentWidget(
    this.commentTree, {
    this.indent = 0,
    @required this.postCreatorId,
  });

  void _goToUser() {
    print('GO TO USER');
  }

  bool get isOP => commentTree.comment.creatorId == postCreatorId;

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
                if (comment.creatorAvatar != null)
                  InkWell(
                    onTap: _goToUser,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: CachedNetworkImage(
                        imageUrl: comment.creatorAvatar,
                        height: 20,
                        width: 20,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: imageProvider,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  child: Text(username,
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                  onLongPress: _goToUser,
                ),
                if (isOP) CommentTag('OP', Theme.of(context).accentColor),
                if (comment.banned) CommentTag('BANNED', Colors.red),
                if (comment.bannedFromCommunity)
                  CommentTag('BANNED FROM COMMUNITY', Colors.red),
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
          CommentWidget(
            c,
            indent: indent + 1,
            postCreatorId: postCreatorId,
          ),
      ],
    );
  }
}

class CommentTag extends StatelessWidget {
  final String text;
  final Color bgColor;

  const CommentTag(this.text, this.bgColor);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: bgColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          child: Text(text,
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyText1.fontSize - 5,
                fontWeight: FontWeight.w800,
              )),
        ),
      );
}

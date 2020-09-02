import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../comment_tree.dart';
import '../util/text_color.dart';
import 'markdown_text.dart';

class Comment extends StatelessWidget {
  final int indent;
  final int postCreatorId;
  final CommentTree commentTree;
  Comment(
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
    final comment = commentTree.comment;

    // decide which username to use
    final username = () {
      if (comment.creatorPreferredUsername != null &&
          comment.creatorPreferredUsername != '') {
        return comment.creatorPreferredUsername;
      } else {
        return '@${comment.creatorName}';
      }
    }();

    final body = () {
      if (comment.deleted) {
        return Flexible(
            child: Text(
          'comment deleted by creator',
          style: TextStyle(fontStyle: FontStyle.italic),
        ));
      } else if (comment.removed) {
        return Flexible(
            child: Text(
          'comment deleted by moderator',
          style: TextStyle(fontStyle: FontStyle.italic),
        ));
      } else {
        return Flexible(child: MarkdownText(commentTree.comment.content));
      }
    }();

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
                Text(timeago.format(comment.published, locale: 'en_short')),
                Text(' · '),
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
          Comment(
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
                color: textColorBasedOnBackground(bgColor),
                fontSize: Theme.of(context).textTheme.bodyText1.fontSize - 5,
                fontWeight: FontWeight.w800,
              )),
        ),
      );
}

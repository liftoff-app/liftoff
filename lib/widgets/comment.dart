import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
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

  void _openMoreMenu() {
    print('OPEN MORE MENU');
  }

  void _goToUser() {
    print('GO TO USER');
  }

  void _save(bool save) {
    print('SAVE COMMENT, $save');
  }

  void _reply() {
    print('OPEN REPLY BOX');
  }

  void _vote(VoteType vote) {
    print('COMMENT VOTE: ${vote.toString()}');
  }

  bool get isOP => commentTree.comment.creatorId == postCreatorId;

  @override
  Widget build(BuildContext context) {
    final comment = commentTree.comment;

    final saved = comment.saved ?? false;

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
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: InkWell(
                      onTap: _goToUser,
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
                if (isOP) _CommentTag('OP', Theme.of(context).accentColor),
                if (comment.banned) _CommentTag('BANNED', Colors.red),
                if (comment.bannedFromCommunity)
                  _CommentTag('BANNED FROM COMMUNITY', Colors.red),
                Spacer(),
                Text(comment.score.toString()),
                Text(' · '),
                Text(timeago.format(comment.published, locale: 'en_short')),
              ]),
              Row(children: [body]),
              Row(children: [
                Spacer(),
                _CommentAction(
                  icon: Icons.more_horiz,
                  onPressed: _openMoreMenu,
                  tooltip: 'more',
                ),
                _CommentAction(
                  icon: saved ? Icons.bookmark : Icons.bookmark_border,
                  onPressed: () => _save(!saved),
                  tooltip: '${saved ? 'unsave' : 'save'} comment',
                ),
                _CommentAction(
                  icon: Icons.reply,
                  onPressed: _reply,
                  tooltip: 'reply',
                ),
                _CommentAction(
                  icon: Icons.arrow_upward,
                  onPressed: () => _vote(VoteType.up),
                  tooltip: 'upvote',
                ),
                _CommentAction(
                  icon: Icons.arrow_downward,
                  onPressed: () => _vote(VoteType.down),
                  tooltip: 'downvote',
                ),
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

class _CommentTag extends StatelessWidget {
  final String text;
  final Color bgColor;

  const _CommentTag(this.text, this.bgColor);

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

class _CommentAction extends StatelessWidget {
  final IconData icon;
  final void Function() onPressed;
  final String tooltip;

  const _CommentAction({
    Key key,
    @required this.icon,
    @required this.onPressed,
    @required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: BoxConstraints.tight(Size(32, 26)),
        icon: Icon(
          icon,
          color: Theme.of(context).iconTheme.color.withAlpha(190),
        ),
        splashRadius: 25,
        onPressed: onPressed,
        iconSize: 22,
        tooltip: tooltip,
        padding: EdgeInsets.all(0),
      );
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as ul;

import '../comment_tree.dart';
import '../util/api_extensions.dart';
import '../util/goto.dart';
import '../util/text_color.dart';
import 'bottom_modal.dart';
import 'markdown_text.dart';

const colors = [
  Colors.pink,
  Colors.green,
  Colors.amber,
  Colors.cyan,
  Colors.indigo,
];

class Comment extends StatelessWidget {
  final int indent;
  final int postCreatorId;
  final CommentTree commentTree;
  Comment(
    this.commentTree, {
    this.indent = 0,
    @required this.postCreatorId,
  });

  void _openMoreMenu(BuildContext context) {
    final com = commentTree.comment;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => BottomModal(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.open_in_browser),
              title: Text('Open in browser'),
              onTap: () async => await ul.canLaunch(com.apId)
                  ? ul.launch(com.apId)
                  : Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("can't open in browser"))),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share url'),
              onTap: () =>
                  Share.text('Share comment url', com.apId, 'text/plain'),
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share text'),
              onTap: () =>
                  Share.text('Share comment text', com.content, 'text/plain'),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Nerd stuff'),
              onTap: () => _showCommentInfo(context),
            ),
          ],
        ),
      ),
    );
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

  _showCommentInfo(BuildContext context) {
    final com = commentTree.comment;
    showDialog(
        context: context,
        child: SimpleDialog(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            children: [
              Table(
                children: [
                  TableRow(children: [
                    Text('upvotes:'),
                    Text(com.upvotes.toString()),
                  ]),
                  TableRow(children: [
                    Text('downvotes:'),
                    Text(com.downvotes.toString()),
                  ]),
                  TableRow(children: [
                    Text('score:'),
                    Text(com.score.toString()),
                  ]),
                  TableRow(children: [
                    Text('% of upvotes:'),
                    Text(
                        '''${(100 * (com.upvotes / (com.upvotes + com.downvotes))).toInt()}%'''),
                  ]),
                  TableRow(children: [
                    Text('hotrank:'),
                    Text(com.hotRank.toString()),
                  ]),
                  TableRow(children: [
                    Text('hotrank active:'),
                    Text(com.hotRankActive.toString()),
                  ]),
                  TableRow(children: [
                    Text('published:'),
                    Text('''${DateFormat.yMMMd().format(com.published)}'''
                        ''' ${DateFormat.Hms().format(com.published)}'''),
                  ]),
                  TableRow(children: [
                    Text('updated:'),
                    Text(com.updated != null
                        ? '''${DateFormat.yMMMd().format(com.updated)}'''
                            ''' ${DateFormat.Hms().format(com.updated)}'''
                        : 'never'),
                  ]),
                ],
              ),
            ]));
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
                      onTap: () => goToUser.byId(
                          context, comment.instanceUrl, comment.creatorId),
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
                  onTap: () => goToUser.byId(
                      context, comment.instanceUrl, comment.creatorId),
                ),
                if (isOP) _CommentTag('OP', Theme.of(context).accentColor),
                if (comment.banned) _CommentTag('BANNED', Colors.red),
                if (comment.bannedFromCommunity)
                  _CommentTag('BANNED FROM COMMUNITY', Colors.red),
                Spacer(),
                InkWell(
                  onTap: () => _showCommentInfo(context),
                  child: Row(
                    children: [
                      Text(comment.score.toString()),
                      Text(' · '),
                      Text(timeago.format(comment.published)),
                    ],
                  ),
                )
              ]),
              Row(children: [body]),
              Row(children: [
                Spacer(),
                _CommentAction(
                  icon: Icons.more_horiz,
                  onPressed: () => _openMoreMenu(context),
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
                      ? BorderSide(
                          color: colors[indent % colors.length], width: 5)
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

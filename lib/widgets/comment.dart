import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart' as ul;

import '../comment_tree.dart';
import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../util/intl.dart';
import '../util/text_color.dart';
import 'bottom_modal.dart';
import 'markdown_text.dart';
import 'write_comment.dart';

class Comment extends HookWidget {
  final int indent;
  final int postCreatorId;
  final CommentTree commentTree;

  final bool wasVoted;

  static const colors = [
    Colors.pink,
    Colors.green,
    Colors.amber,
    Colors.cyan,
    Colors.indigo,
  ];

  Comment(
    this.commentTree, {
    this.indent = 0,
    @required this.postCreatorId,
  }) : wasVoted =
            (commentTree.comment.myVote ?? VoteType.none) != VoteType.none;

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
    final theme = Theme.of(context);
    final selectable = useState(false);
    final showRaw = useState(false);
    final collapsed = useState(false);
    final myVote = useState(commentTree.comment.myVote ?? VoteType.none);
    final delayedVoting = useDelayedLoading();
    final loggedInAction = useLoggedInAction(commentTree.comment.instanceUrl);
    final newReplies = useState(const <CommentTree>[]);

    final comment = commentTree.comment;

    void _openMoreMenu(BuildContext context) {
      pop() => Navigator.of(context).pop();

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
                leading: Icon(
                    selectable.value ? Icons.assignment : Icons.content_cut),
                title:
                    Text('Make text ${selectable.value ? 'un' : ''}selectable'),
                onTap: () {
                  selectable.value = !selectable.value;
                  pop();
                },
              ),
              ListTile(
                leading: Icon(showRaw.value ? Icons.brush : Icons.build),
                title: Text('Show ${showRaw.value ? 'fancy' : 'raw'} text'),
                onTap: () {
                  showRaw.value = !showRaw.value;
                  pop();
                },
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

    reply() async {
      final newComment = await showCupertinoModalPopup<CommentView>(
        context: context,
        builder: (_) => WriteComment.toComment(comment),
      );
      if (newComment != null) {
        newReplies.value = [...newReplies.value, CommentTree(newComment)];
      }
    }

    vote(VoteType vote, Jwt token) async {
      final api = LemmyApi(token.payload.iss).v1;

      delayedVoting.start();
      try {
        final res = await api.createCommentLike(
            commentId: comment.id, score: vote, auth: token.raw);
        myVote.value = res.myVote;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('voting failed :(')));
        return;
      }
      delayedVoting.cancel();
    }

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
          ),
        );
      } else if (comment.removed) {
        return Flexible(
          child: Text(
            'comment deleted by moderator',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (collapsed.value) {
        return Flexible(
          child: Opacity(
            opacity: 0.3,
            child: Text(
              commentTree.comment.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      } else {
        // TODO: bug, the text is selectable even when disabled after following
        //       these steps:
        //       make selectable > show raw > show fancy > make unselectable
        return Flexible(
            child: showRaw.value
                ? selectable.value
                    ? SelectableText(commentTree.comment.content)
                    : Text(commentTree.comment.content)
                : MarkdownText(
                    commentTree.comment.content,
                    instanceUrl: commentTree.comment.instanceUrl,
                    selectable: selectable.value,
                  ));
      }
    }();

    final actions = collapsed.value
        ? Container()
        : Row(children: [
            if (selectable.value && !comment.deleted && !comment.removed)
              _CommentAction(
                  icon: Icons.content_copy,
                  tooltip: 'copy',
                  onPressed: () {
                    Clipboard.setData(
                            ClipboardData(text: commentTree.comment.content))
                        .then((_) => Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('comment copied to clipboard'))));
                  }),
            Spacer(),
            _CommentAction(
              icon: Icons.more_horiz,
              onPressed: () => _openMoreMenu(context),
              tooltip: 'more',
            ),
            _SaveComment(commentTree.comment),
            _CommentAction(
              icon: Icons.reply,
              onPressed: loggedInAction((_) => reply()),
              tooltip: 'reply',
            ),
            _CommentAction(
              icon: Icons.arrow_upward,
              iconColor: myVote.value == VoteType.up ? theme.accentColor : null,
              onPressed: loggedInAction((token) => vote(
                    myVote.value == VoteType.up ? VoteType.none : VoteType.up,
                    token,
                  )),
              tooltip: 'upvote',
            ),
            _CommentAction(
              icon: Icons.arrow_downward,
              iconColor: myVote.value == VoteType.down ? Colors.red : null,
              onPressed: loggedInAction(
                (token) => vote(
                  myVote.value == VoteType.down ? VoteType.none : VoteType.down,
                  token,
                ),
              ),
              tooltip: 'downvote',
            ),
          ]);

    return GestureDetector(
      onLongPress: () => collapsed.value = !collapsed.value,
      child: Column(
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
                          errorWidget: (_, __, ___) => Container(),
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
                  if (collapsed.value && commentTree.children.length > 0) ...[
                    _CommentTag('+${commentTree.children.length}',
                        Theme.of(context).accentColor),
                    SizedBox(width: 7),
                  ],
                  InkWell(
                    onTap: () => _showCommentInfo(context),
                    child: Row(
                      children: [
                        if (delayedVoting.loading)
                          SizedBox.fromSize(
                              size: Size.square(16),
                              child: CircularProgressIndicator())
                        else
                          Text(compactNumber(comment.score +
                              (wasVoted ? 0 : myVote.value.value))),
                        Text(' · '),
                        Text(timeago.format(comment.published)),
                      ],
                    ),
                  )
                ]),
                SizedBox(height: 10),
                Row(children: [body]),
                SizedBox(height: 5),
                actions,
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
          if (!collapsed.value)
            for (final c in newReplies.value.followedBy(commentTree.children))
              Comment(
                c,
                indent: indent + 1,
                postCreatorId: postCreatorId,
              ),
        ],
      ),
    );
  }
}

class _SaveComment extends HookWidget {
  final CommentView comment;

  _SaveComment(this.comment);

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(comment.instanceUrl);
    final isSaved = useState(comment.saved ?? false);
    final delayed = useDelayedLoading(const Duration(milliseconds: 500));

    handleSave(Jwt token) async {
      final api = LemmyApi(comment.instanceUrl).v1;

      delayed.start();
      try {
        final res = await api.saveComment(
            commentId: comment.id, save: !isSaved.value, auth: token.raw);
        isSaved.value = res.saved;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('saving failed :(')));
      }
      delayed.cancel();
    }

    return _CommentAction(
      loading: delayed.loading,
      icon: isSaved.value ? Icons.bookmark : Icons.bookmark_border,
      onPressed: loggedInAction(delayed.pending ? (_) {} : handleSave),
      tooltip: '${isSaved.value ? 'unsave' : 'save'} comment',
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
  final bool loading;
  final Color iconColor;

  const _CommentAction({
    Key key,
    this.loading = false,
    this.iconColor,
    @required this.icon,
    @required this.onPressed,
    @required this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: BoxConstraints.tight(Size(32, 26)),
        icon: loading
            ? SizedBox.fromSize(
                size: Size.square(22), child: CircularProgressIndicator())
            : Icon(
                icon,
                color: iconColor ??
                    Theme.of(context).iconTheme.color.withAlpha(190),
              ),
        splashRadius: 25,
        onPressed: onPressed,
        iconSize: 22,
        tooltip: tooltip,
        padding: EdgeInsets.all(0),
      );
}

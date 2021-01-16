import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'info_table_popup.dart';
import 'markdown_text.dart';
import 'write_comment.dart';

/// A single comment that renders its replies
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
    showInfoTablePopup(context, {
      'id': com.id,
      'creatorId': com.creatorId,
      'postId': com.postId,
      'postName': com.postName,
      'parentId': com.parentId,
      'removed': com.removed,
      'read': com.read,
      'published': com.published,
      'updated': com.updated,
      'deleted': com.deleted,
      'apId': com.apId,
      'local': com.local,
      'communityId': com.communityId,
      'communityActorId': com.communityActorId,
      'communityLocal': com.communityLocal,
      'communityName': com.communityName,
      'communityIcon': com.communityIcon,
      'banned': com.banned,
      'bannedFromCommunity': com.bannedFromCommunity,
      'creatorActirId': com.creatorActorId,
      'userId': com.userId,
      'upvotes': com.upvotes,
      'downvotes': com.downvotes,
      'score': com.score,
      '% of upvotes': '${100 * (com.upvotes / (com.upvotes + com.downvotes))}%',
      'hotRank': com.hotRank,
      'hotRankActive': com.hotRankActive,
    });
  }

  bool get isOP => commentTree.comment.creatorId == postCreatorId;
  bool get isMine =>
      commentTree.comment.creatorId == commentTree.comment.userId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectable = useState(false);
    final showRaw = useState(false);
    final collapsed = useState(false);
    final myVote = useState(commentTree.comment.myVote ?? VoteType.none);
    final isDeleted = useState(commentTree.comment.deleted);
    final delayedVoting = useDelayedLoading();
    final delayedDeletion = useDelayedLoading();
    final loggedInAction = useLoggedInAction(commentTree.comment.instanceHost);
    final newReplies = useState(const <CommentTree>[]);

    final comment = commentTree.comment;

    handleDelete(Jwt token) async {
      final api = LemmyApi(token.payload.iss).v1;

      delayedDeletion.start();
      Navigator.of(context).pop();
      try {
        final res = await api.deleteComment(
            editId: comment.id, deleted: !isDeleted.value, auth: token.raw);
        isDeleted.value = res.deleted;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete/restore comment')));
        return;
      }
      delayedDeletion.cancel();
    }

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
                leading: const Icon(Icons.open_in_browser),
                title: const Text('Open in browser'),
                onTap: () async => await ul.canLaunch(com.apId)
                    ? ul.launch(com.apId)
                    : Scaffold.of(context).showSnackBar(
                        const SnackBar(content: Text("can't open in browser"))),
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share url'),
                onTap: () =>
                    Share.text('Share comment url', com.apId, 'text/plain'),
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share text'),
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
              if (isMine)
                ListTile(
                  leading: Icon(isDeleted.value ? Icons.restore : Icons.delete),
                  title: Text(isDeleted.value ? 'Restore' : 'Delete'),
                  onTap: loggedInAction(handleDelete),
                ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Nerd stuff'),
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
            .showSnackBar(const SnackBar(content: Text('voting failed :(')));
        return;
      }
      delayedVoting.cancel();
    }

    // decide which username to use
    final username = () {
      final name = () {
        if (comment.creatorPreferredUsername != null &&
            comment.creatorPreferredUsername != '') {
          return comment.creatorPreferredUsername;
        } else {
          return '@${comment.creatorName}';
        }
      }();

      if (!comment.isLocal) return '$name@${comment.originInstanceHost}';

      return name;
    }();

    final body = () {
      if (isDeleted.value) {
        return const Flexible(
          child: Text(
            'comment deleted by creator',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (comment.removed) {
        return const Flexible(
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
                    instanceHost: commentTree.comment.instanceHost,
                    selectable: selectable.value,
                  ));
      }
    }();

    final actions = collapsed.value
        ? const SizedBox.shrink()
        : Row(children: [
            if (selectable.value && !isDeleted.value && !comment.removed)
              _CommentAction(
                  icon: Icons.content_copy,
                  tooltip: 'copy',
                  onPressed: () {
                    Clipboard.setData(
                            ClipboardData(text: commentTree.comment.content))
                        .then((_) => Scaffold.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('comment copied to clipboard'))));
                  }),
            const Spacer(),
            _CommentAction(
              icon: Icons.more_horiz,
              onPressed: () => _openMoreMenu(context),
              loading: delayedDeletion.loading,
              tooltip: 'more',
            ),
            _SaveComment(commentTree.comment),
            if (!isDeleted.value && !comment.removed)
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
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(left: indent > 1 ? (indent - 1) * 5.0 : 0),
            decoration: BoxDecoration(
                border: Border(
                    left: indent > 0
                        ? BorderSide(
                            color: colors[indent % colors.length], width: 5)
                        : BorderSide.none,
                    top: const BorderSide(width: 0.2))),
            child: Column(
              children: [
                Row(children: [
                  if (comment.creatorAvatar != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () => goToUser.byId(
                            context, comment.instanceHost, comment.creatorId),
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
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () => goToUser.byId(
                        context, comment.instanceHost, comment.creatorId),
                    child: Text(username,
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        )),
                  ),
                  if (isOP) _CommentTag('OP', Theme.of(context).accentColor),
                  if (comment.banned) const _CommentTag('BANNED', Colors.red),
                  if (comment.bannedFromCommunity)
                    const _CommentTag('BANNED FROM COMMUNITY', Colors.red),
                  const Spacer(),
                  if (collapsed.value && commentTree.children.length > 0) ...[
                    _CommentTag('+${commentTree.children.length}',
                        Theme.of(context).accentColor),
                    const SizedBox(width: 7),
                  ],
                  InkWell(
                    onTap: () => _showCommentInfo(context),
                    child: Row(
                      children: [
                        if (delayedVoting.loading)
                          SizedBox.fromSize(
                              size: const Size.square(16),
                              child: const CircularProgressIndicator())
                        else
                          Text(compactNumber(comment.score +
                              (wasVoted ? 0 : myVote.value.value))),
                        const Text(' · '),
                        Text(timeago.format(comment.published)),
                      ],
                    ),
                  )
                ]),
                const SizedBox(height: 10),
                Row(children: [body]),
                const SizedBox(height: 5),
                actions,
              ],
            ),
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

  const _SaveComment(this.comment);

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(comment.instanceHost);
    final isSaved = useState(comment.saved ?? false);
    final delayed = useDelayedLoading();

    handleSave(Jwt token) async {
      final api = LemmyApi(comment.instanceHost).v1;

      delayed.start();
      try {
        final res = await api.saveComment(
            commentId: comment.id, save: !isSaved.value, auth: token.raw);
        isSaved.value = res.saved;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(const SnackBar(content: Text('saving failed :(')));
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
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: bgColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
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
  final VoidCallback onPressed;
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
        constraints: BoxConstraints.tight(const Size(32, 26)),
        icon: loading
            ? SizedBox.fromSize(
                size: const Size.square(22),
                child: const CircularProgressIndicator())
            : Icon(
                icon,
                color: iconColor ??
                    Theme.of(context).iconTheme.color.withAlpha(190),
              ),
        splashRadius: 25,
        onPressed: onPressed,
        iconSize: 22,
        tooltip: tooltip,
        padding: const EdgeInsets.all(0),
      );
}

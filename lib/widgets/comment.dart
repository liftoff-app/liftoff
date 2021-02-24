import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../comment_tree.dart';
import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/stores.dart';
import '../util/delayed_action.dart';
import '../util/extensions/api.dart';
import '../util/extensions/datetime.dart';
import '../util/goto.dart';
import '../util/intl.dart';
import '../util/text_color.dart';
import 'avatar.dart';
import 'bottom_modal.dart';
import 'info_table_popup.dart';
import 'markdown_mode_icon.dart';
import 'markdown_text.dart';
import 'tile_action.dart';
import 'write_comment.dart';

/// A single comment that renders its replies
class CommentWidget extends HookWidget {
  final int depth;
  final CommentTree commentTree;
  final bool detached;
  final UserMentionView userMentionView;
  final bool wasVoted;
  final bool canBeMarkedAsRead;
  final bool hideOnRead;

  static const colors = [
    Colors.pink,
    Colors.green,
    Colors.amber,
    Colors.cyan,
    Colors.indigo,
  ];

  CommentWidget(
    this.commentTree, {
    this.depth = 0,
    this.detached = false,
    this.canBeMarkedAsRead = false,
    this.hideOnRead = false,
  })  : wasVoted =
            (commentTree.comment.myVote ?? VoteType.none) != VoteType.none,
        userMentionView = null;

  CommentWidget.fromCommentView(
    CommentView cv, {
    bool canBeMarkedAsRead = false,
    bool hideOnRead = false,
  }) : this(
          CommentTree(cv),
          detached: true,
          canBeMarkedAsRead: canBeMarkedAsRead,
          hideOnRead: hideOnRead,
        );

  CommentWidget.fromUserMentionView(
    this.userMentionView, {
    this.hideOnRead = false,
  })  : commentTree =
            CommentTree(CommentView.fromJson(userMentionView.toJson())),
        depth = 0,
        wasVoted = (userMentionView.myVote ?? VoteType.none) != VoteType.none,
        detached = true,
        canBeMarkedAsRead = true;

  _showCommentInfo(BuildContext context) {
    final com = commentTree.comment;
    showInfoTablePopup(context: context, table: {
      ...com.toJson(),
      '% of upvotes':
          '${100 * (com.counts.upvotes / (com.counts.upvotes + com.counts.downvotes))}%',
    });
  }

  bool get isOP =>
      commentTree.comment.comment.creatorId ==
      commentTree.comment.post.creatorId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final accStore = useAccountsStore();

    final isMine = commentTree.comment.comment.creatorId ==
        accStore.defaultTokenFor(commentTree.comment.instanceHost)?.payload?.id;
    final selectable = useState(false);
    final showRaw = useState(false);
    final collapsed = useState(false);
    final myVote = useState(commentTree.comment.myVote ?? VoteType.none);
    final isDeleted = useState(commentTree.comment.comment.deleted);
    final isRead = useState(commentTree.comment.comment.read);

    final delayedVoting = useDelayedLoading();
    final delayedDeletion = useDelayedLoading();
    final loggedInAction = useLoggedInAction(commentTree.comment.instanceHost);

    final newReplies = useState(const <CommentTree>[]);

    final comment = commentTree.comment;

    if (hideOnRead && isRead.value) {
      return const SizedBox.shrink();
    }

    handleDelete(Jwt token) {
      Navigator.of(context).pop();
      delayedAction<FullCommentView>(
        context: context,
        delayedLoading: delayedDeletion,
        instanceHost: token.payload.iss,
        query: DeleteComment(
          commentId: comment.comment.id,
          deleted: !isDeleted.value,
          auth: token.raw,
        ),
        onSuccess: (res) => isDeleted.value = res.commentView.comment.deleted,
      );
    }

    void _openMoreMenu(BuildContext context) {
      pop() => Navigator.of(context).pop();

      final com = commentTree.comment;
      showBottomModal(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open in browser'),
              onTap: () async => await ul.canLaunch(com.comment.link)
                  ? ul.launch(com.comment.link)
                  : Scaffold.of(context).showSnackBar(
                      const SnackBar(content: Text("can't open in browser"))),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share url'),
              onTap: () => Share.text(
                  'Share comment url', com.comment.link, 'text/plain'),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share text'),
              onTap: () => Share.text(
                  'Share comment text', com.comment.content, 'text/plain'),
            ),
            ListTile(
              leading:
                  Icon(selectable.value ? Icons.assignment : Icons.content_cut),
              title:
                  Text('Make text ${selectable.value ? 'un' : ''}selectable'),
              onTap: () {
                selectable.value = !selectable.value;
                pop();
              },
            ),
            ListTile(
              leading: markdownModeIcon(fancy: !showRaw.value),
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
      );
    }

    reply() async {
      final newComment = await showCupertinoModalPopup<CommentView>(
        context: context,
        builder: (_) => WriteComment.toComment(
            comment: comment.comment, post: comment.post),
      );
      if (newComment != null) {
        newReplies.value = [...newReplies.value, CommentTree(newComment)];
      }
    }

    vote(VoteType vote, Jwt token) => delayedAction<FullCommentView>(
          context: context,
          delayedLoading: delayedVoting,
          instanceHost: token.payload.iss,
          query: CreateCommentLike(
            commentId: comment.comment.id,
            score: vote,
            auth: token.raw,
          ),
          onSuccess: (res) =>
              myVote.value = res.commentView.myVote ?? VoteType.none,
        );

    final body = () {
      if (isDeleted.value) {
        return const Flexible(
          child: Text(
            'comment deleted by creator',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      } else if (comment.comment.removed) {
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
              commentTree.comment.comment.content,
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
                    ? SelectableText(commentTree.comment.comment.content)
                    : Text(commentTree.comment.comment.content)
                : MarkdownText(
                    commentTree.comment.comment.content,
                    instanceHost: commentTree.comment.instanceHost,
                    selectable: selectable.value,
                  ));
      }
    }();

    final actions = collapsed.value
        ? const SizedBox.shrink()
        : Row(children: [
            if (selectable.value &&
                !isDeleted.value &&
                !comment.comment.removed)
              TileAction(
                  icon: Icons.content_copy,
                  tooltip: 'copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                            text: commentTree.comment.comment.content))
                        .then((_) => Scaffold.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('comment copied to clipboard'))));
                  }),
            const Spacer(),
            if (canBeMarkedAsRead)
              _MarkAsRead(
                commentTree.comment,
                onChanged: (val) => isRead.value = val,
              ),
            if (detached)
              TileAction(
                icon: Icons.link,
                onPressed: () =>
                    goToPost(context, comment.instanceHost, comment.post.id),
                tooltip: 'go to post',
              ),
            TileAction(
              icon: Icons.more_horiz,
              onPressed: () => _openMoreMenu(context),
              delayedLoading: delayedDeletion,
              tooltip: 'more',
            ),
            _SaveComment(commentTree.comment),
            if (!isDeleted.value && !comment.comment.removed)
              TileAction(
                icon: Icons.reply,
                onPressed: loggedInAction((_) => reply()),
                tooltip: 'reply',
              ),
            TileAction(
              icon: Icons.arrow_upward,
              iconColor: myVote.value == VoteType.up ? theme.accentColor : null,
              onPressed: loggedInAction((token) => vote(
                    myVote.value == VoteType.up ? VoteType.none : VoteType.up,
                    token,
                  )),
              tooltip: 'upvote',
            ),
            TileAction(
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

    return InkWell(
      onLongPress:
          selectable.value ? null : () => collapsed.value = !collapsed.value,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(left: depth > 1 ? (depth - 1) * 5.0 : 0),
            decoration: BoxDecoration(
                border: Border(
                    left: depth > 0
                        ? BorderSide(
                            color: colors[depth % colors.length], width: 5)
                        : BorderSide.none,
                    top: const BorderSide(width: 0.2))),
            child: Column(
              children: [
                Row(children: [
                  if (comment.creator.avatar != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: InkWell(
                        onTap: () =>
                            goToUser.fromUserSafe(context, comment.creator),
                        child: Avatar(
                          url: comment.creator.avatar,
                          radius: 10,
                          noBlank: true,
                        ),
                      ),
                    ),
                  InkWell(
                    onTap: () =>
                        goToUser.fromUserSafe(context, comment.creator),
                    child: Text(comment.creator.originDisplayName,
                        style: TextStyle(
                          color: theme.accentColor,
                        )),
                  ),
                  if (isOP) _CommentTag('OP', theme.accentColor),
                  if (comment.creator.admin)
                    _CommentTag('ADMIN', theme.accentColor),
                  if (comment.creator.banned)
                    const _CommentTag('BANNED', Colors.red),
                  if (comment.creatorBannedFromCommunity)
                    const _CommentTag('BANNED FROM COMMUNITY', Colors.red),
                  const Spacer(),
                  if (collapsed.value && commentTree.children.isNotEmpty) ...[
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
                          Text(compactNumber(comment.counts.score +
                              (wasVoted ? 0 : myVote.value.value))),
                        const Text(' · '),
                        Text(comment.comment.published.fancy),
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
              CommentWidget(c, depth: depth + 1),
        ],
      ),
    );
  }
}

class _MarkAsRead extends HookWidget {
  final CommentView commentView;
  final ValueChanged<bool> onChanged;

  const _MarkAsRead(this.commentView, {this.onChanged});

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();

    final comment = commentView.comment;
    final recipient = commentView.recipient;
    final instanceHost = commentView.instanceHost;
    final post = commentView.post;

    final isRead = useState(comment.read);
    final delayedRead = useDelayedLoading();

    Future<void> handleMarkAsSeen() => delayedAction<FullCommentView>(
          context: context,
          delayedLoading: delayedRead,
          instanceHost: instanceHost,
          query: MarkCommentAsRead(
            commentId: comment.id,
            read: !isRead.value,
            auth: recipient != null
                ? accStore.tokenFor(instanceHost, recipient.name)?.raw
                : accStore.tokenForId(instanceHost, post.creatorId)?.raw,
          ),
          onSuccess: (val) {
            isRead.value = val.commentView.comment.read;
            onChanged?.call(isRead.value);
          },
        );

    return TileAction(
      icon: Icons.check,
      delayedLoading: delayedRead,
      onPressed: handleMarkAsSeen,
      iconColor: isRead.value ? Theme.of(context).accentColor : null,
      tooltip: 'mark as ${isRead.value ? 'un' : ''}read',
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

    handleSave(Jwt token) => delayedAction<FullCommentView>(
          context: context,
          delayedLoading: delayed,
          instanceHost: comment.instanceHost,
          query: SaveComment(
            commentId: comment.comment.id,
            save: !isSaved.value,
            auth: token.raw,
          ),
          onSuccess: (res) => isSaved.value = res.commentView.saved,
        );

    return TileAction(
      delayedLoading: delayed,
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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../comment_tree.dart';
import '../../l10n/l10n.dart';
import '../../stores/config_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/extensions/cake_day.dart';
import '../../util/extensions/datetime.dart';
import '../../util/goto.dart';
import '../../util/intl.dart';
import '../../util/observer_consumers.dart';
import '../../util/text_color.dart';
import '../avatar.dart';
import '../info_table_popup.dart';
import '../markdown_text.dart';
import 'comment_actions.dart';
import 'comment_store.dart';

/// A single comment that renders its replies
class CommentWidget extends StatelessWidget {
  final CommentTree commentTree;
  final int? userMentionId;
  final int depth;
  final bool canBeMarkedAsRead;
  final bool detached;
  final bool hideOnRead;

  const CommentWidget(
    this.commentTree, {
    this.depth = 0,
    this.detached = false,
    this.canBeMarkedAsRead = false,
    this.hideOnRead = false,
    this.userMentionId,
    Key? key,
  }) : super(key: key);

  CommentWidget.fromCommentView(
    CommentView cv, {
    bool canBeMarkedAsRead = false,
    bool hideOnRead = false,
    bool detached = true,
    Key? key,
  }) : this(
          CommentTree(cv),
          detached: detached,
          canBeMarkedAsRead: canBeMarkedAsRead,
          hideOnRead: hideOnRead,
          key: key,
        );

  CommentWidget.fromPersonMentionView(
    PersonMentionView userMentionView, {
    bool hideOnRead = false,
    Key? key,
  }) : this(
          CommentTree(CommentView.fromJson(userMentionView.toJson())),
          hideOnRead: hideOnRead,
          canBeMarkedAsRead: true,
          detached: true,
          userMentionId: userMentionView.personMention.id,
          key: key,
        );

  static void showCommentInfo(BuildContext context, CommentView commentView) {
    final percentOfUpvotes = 100 *
        (commentView.counts.upvotes /
            (commentView.counts.upvotes + commentView.counts.downvotes));

    showInfoTablePopup(context: context, table: {
      ...commentView.toJson(),
      '% of upvotes': '$percentOfUpvotes%',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CommentStore(
        context.read(),
        commentTree: commentTree,
        userMentionId: userMentionId,
        depth: depth,
        canBeMarkedAsRead: canBeMarkedAsRead,
        detached: detached,
        hideOnRead: hideOnRead,
      ),
      builder: (context, child) => AsyncStoreListener(
        asyncStore: context.read<CommentStore>().votingState,
        child: AsyncStoreListener(
          asyncStore: context.read<CommentStore>().deletingState,
          child: AsyncStoreListener(
            asyncStore: context.read<CommentStore>().savingState,
            child: const _CommentWidget(),
          ),
        ),
      ),
    );
  }
}

class _CommentWidget extends StatelessWidget {
  static const colors = [
    Colors.pink,
    Colors.green,
    Colors.amber,
    Colors.cyan,
    Colors.indigo,
  ];

  static const indentWidth = 5.0;

  const _CommentWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final body = ObserverBuilder<CommentStore>(
      builder: (context, store) {
        final comment = store.comment.comment;

        if (comment.deleted) {
          return Text(
            L10n.of(context)!.deleted_by_creator,
            style: const TextStyle(fontStyle: FontStyle.italic),
          );
        } else if (comment.removed) {
          return const Text(
            'comment deleted by moderator',
            style: TextStyle(fontStyle: FontStyle.italic),
          );
        } else if (store.collapsed) {
          return Opacity(
            opacity: 0.3,
            child: Text(
              comment.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }

        // TODO: bug, the text is selectable even when disabled after following
        //       these steps:
        //       make selectable > show raw > show fancy > make unselectable
        return store.showRaw
            ? store.selectable
                ? SelectableText(comment.content)
                : Text(comment.content)
            : MarkdownText(
                comment.content,
                instanceHost: comment.instanceHost,
                selectable: store.selectable,
              );
      },
    );

    return ObserverBuilder<CommentStore>(
      builder: (context, store) {
        if (store.hideOnRead && store.comment.comment.read) {
          return const SizedBox();
        }

        final comment = store.comment.comment;
        final creator = store.comment.creator;

        return InkWell(
          onLongPress: store.selectable ? null : store.toggleCollapsed,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.only(
                  left: max((store.depth - 1) * indentWidth, 0),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: store.depth > 0
                        ? BorderSide(
                            color: colors[store.depth % colors.length],
                            width: indentWidth,
                          )
                        : BorderSide.none,
                    top: const BorderSide(width: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      if (creator.avatar != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: InkWell(
                            onTap: () =>
                                goToUser.fromPersonSafe(context, creator),
                            child: Avatar(
                              url: creator.avatar,
                              radius: 10,
                              noBlank: true,
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () => goToUser.fromPersonSafe(context, creator),
                        child: Text(
                          creator.originPreferredName,
                          style: TextStyle(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ),
                      if (creator.isCakeDay) const Text(' 🍰'),
                      if (store.isOP)
                        _CommentTag('OP', theme.colorScheme.secondary),
                      if (creator.admin)
                        _CommentTag(
                          L10n.of(context)!.admin.toUpperCase(),
                          theme.colorScheme.secondary,
                        ),
                      if (creator.banned)
                        const _CommentTag('BANNED', Colors.red),
                      if (store.comment.creatorBannedFromCommunity)
                        const _CommentTag('BANNED FROM COMMUNITY', Colors.red),
                      const Spacer(),
                      if (store.collapsed && store.children.isNotEmpty) ...[
                        _CommentTag(
                          '+${store.children.length}',
                          Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 7),
                      ],
                      InkWell(
                        onTap: () => CommentWidget.showCommentInfo(
                          context,
                          store.comment,
                        ),
                        child: Consumer<ConfigStore>(
                          builder: (context, configStore, child) {
                            return ObserverBuilder<CommentStore>(
                              builder: (context, store) => Row(
                                children: [
                                  if (store.votingState.isLoading)
                                    SizedBox.fromSize(
                                      size: const Size.square(16),
                                      child: const CircularProgressIndicator(),
                                    )
                                  else if (configStore.showScores)
                                    Text(
                                      compactNumber(
                                        store.comment.counts.score,
                                      ),
                                    ),
                                  if (configStore.showScores)
                                    const Text(' · ')
                                  else
                                    const SizedBox(width: 4),
                                  Text(comment.published.fancy),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ]),
                    const SizedBox(height: 10),
                    body,
                    const SizedBox(height: 5),
                    const CommentActions(),
                  ],
                ),
              ),
              if (!store.collapsed)
                for (final c in store.children)
                  CommentWidget(c, depth: store.depth + 1),
            ],
          ),
        );
      },
    );
  }
}

class _CommentTag extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const _CommentTag(this.text, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        child: Text(
          text,
          style: TextStyle(
            color: textColorBasedOnBackground(backgroundColor),
            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize! - 5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

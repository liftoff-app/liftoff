import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:nested/nested.dart';

import '../../actions/post.dart';
import '../../comment_tree.dart';
import '../../hooks/logged_in_action.dart';
import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../stores/config_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/goto.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../util/text_color.dart';
import '../avatar.dart';
import '../info_table_popup.dart';
import '../markdown_text.dart';
import '../swipe_actions.dart';
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
    super.key,
  });

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
    return MobxProvider(
      create: (context) {
        return CommentStore(
          context.read(),
          commentTree: commentTree,
          userMentionId: userMentionId,
          depth: depth,
          canBeMarkedAsRead: canBeMarkedAsRead,
          detached: detached,
          hideOnRead: hideOnRead,
        );
      },
      builder: (context, child) => Nested(
        children: [
          AsyncStoreListener<BlockedPerson>(
            asyncStore: context.read<CommentStore>().blockingState,
            successMessageBuilder: (context, state) {
              final name = state.personView.person.preferredName;
              return state.blocked ? '$name blocked' : '$name unblocked';
            },
          ),
          AsyncStoreListener(
            asyncStore: context.read<CommentStore>().votingState,
          ),
          AsyncStoreListener(
            asyncStore: context.read<CommentStore>().deletingState,
          ),
          AsyncStoreListener(
            asyncStore: context.read<CommentStore>().savingState,
          ),
          AsyncStoreListener<CommentReportView>(
            asyncStore: context.read<CommentStore>().reportingState,
            successMessageBuilder: (context, data) => 'Comment reported',
          ),
        ],
        child: const _CommentWidget(),
      ),
    );
  }
}

class _CommentWidget extends HookWidget {
  static const colors = [
    Colors.pink,
    Colors.green,
    Colors.amber,
    Colors.cyan,
    Colors.indigo,
  ];

  static const indentWidth = 6.0;
  const _CommentWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyFontSize = useStore((ConfigStore store) => store.commentBodySize);
    final loggedInAction = useLoggedInAction(context
        .select<CommentStore, String>((store) => store.comment.instanceHost));

    final body = ObserverBuilder<CommentStore>(
      builder: (context, store) {
        final comment = store.comment.comment;

        if (comment.deleted) {
          return Text(
            L10n.of(context).deleted_by_creator,
            style:
                TextStyle(fontStyle: FontStyle.italic, fontSize: bodyFontSize),
          );
        } else if (comment.removed) {
          return Text(
            'comment deleted by moderator',
            style:
                TextStyle(fontStyle: FontStyle.italic, fontSize: bodyFontSize),
          );
        } else if (store.collapsed) {
          return Center(
            child: Opacity(
              opacity: 0.3,
              child: Text(
                '[Thread collapsed. Tap to expand]',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: bodyFontSize),
              ),
            ),
          );
        }

        return store.showRaw
            ? store.selectable
                ? SelectableText(
                    comment.content,
                    style: TextStyle(fontSize: bodyFontSize),
                  )
                : Text(
                    comment.content,
                    style: TextStyle(fontSize: bodyFontSize),
                  )
            : MarkdownText(
                comment.content,
                instanceHost: comment.instanceHost,
                selectable: store.selectable,
                fontSize: bodyFontSize,
              );
      },
    );

    return ObserverBuilder<CommentStore>(
      builder: (context, store) {
        if (store.hideOnRead) {
          if (store.comment.comment.distinguished) {
            return const SizedBox();
          }

          if (store.comment.commentReply != null &&
              store.comment.commentReply!.read) {
            return const SizedBox();
          }
        }

        final comment = store.comment.comment;
        final creator = store.comment.creator;

        return InkWell(
          onTap: store.selectable ? null : store.toggleCollapsed,
          child: Column(
            children: [
              WithSwipeActions(
                  actions: [
                    CommentUpvoteAction(comment: store, context: context)
                  ],
                  onTrigger: (action) => loggedInAction(action.invoke),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: EdgeInsets.only(
                      left: max(store.depth * indentWidth, 0),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: store.depth > 0
                            ? BorderSide(
                                color: colors[store.depth % colors.length],
                                width: context
                                    .read<ConfigStore>()
                                    .commentIndentWidth,
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
                          Expanded(
                            child: InkWell(
                              onTap: () =>
                                  goToUser.fromPersonSafe(context, creator),
                              child: Text(
                                creator.originPreferredName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: context
                                      .read<ConfigStore>()
                                      .commentTitleSize,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                          if (creator.isCakeDay) const Text(' 🍰'),
                          if (store.isOP)
                            _CommentTag('OP', theme.colorScheme.secondary),
                          if (creator.admin)
                            _CommentTag(
                              L10n.of(context).admin.toUpperCase(),
                              theme.colorScheme.secondary,
                            ),
                          if (comment.path == '0')
                            _CommentTag(
                              L10n.of(context).pinned.toUpperCase(),
                              Colors.orangeAccent,
                            ),
                          if (creator.banned)
                            const _CommentTag('BANNED', Colors.red),
                          if (store.comment.creatorBannedFromCommunity)
                            const _CommentTag(
                                'BANNED FROM COMMUNITY', Colors.red),
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
                                          child: const CircularProgressIndicator
                                              .adaptive(),
                                        )
                                      else if (configStore.showScores)
                                        Text(
                                          store.comment.counts.score
                                              .compact(context),
                                          style: TextStyle(
                                              fontSize: context
                                                  .read<ConfigStore>()
                                                  .commentTimestampSize),
                                        ),
                                      if (configStore.showScores)
                                        Text(
                                          ' · ',
                                          style: TextStyle(
                                              fontSize: context
                                                  .read<ConfigStore>()
                                                  .commentTimestampSize),
                                        )
                                      else
                                        const SizedBox(width: 4),
                                      Text(
                                        comment.published.timeago(context),
                                        style: TextStyle(
                                            fontSize: context
                                                .read<ConfigStore>()
                                                .commentTimestampSize),
                                      ),
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
                  )),
              if (!store.collapsed)
                for (final c in store.children)
                  CommentWidget(c,
                      depth: store.depth + 1,
                      key: Key(c.comment.comment.id.toString())),
            ],
          ),
        );
      },
    );
  }
}

class _CommentTag extends HookWidget {
  final String text;
  final Color backgroundColor;
  const _CommentTag(this.text, this.backgroundColor);

  @override
  Widget build(BuildContext context) {
    final pillSize = useStore((ConfigStore store) => store.commentPillSize);

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
            fontSize: pillSize,
            // fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! - 5,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

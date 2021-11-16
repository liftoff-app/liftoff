import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/infinite_scroll.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/delayed_action.dart';
import '../util/extensions/api.dart';
import '../util/extensions/datetime.dart';
import '../util/goto.dart';
import '../util/icons.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/cached_network_image.dart';
import '../widgets/comment/comment.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/info_table_popup.dart';
import '../widgets/markdown_mode_icon.dart';
import '../widgets/markdown_text.dart';
import '../widgets/radio_picker.dart';
import '../widgets/sortable_infinite_list.dart';
import '../widgets/tile_action.dart';
import 'write_message.dart';

class InboxPage extends HookWidget {
  const InboxPage();

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final selected = useState(accStore.defaultInstanceHost);
    final theme = Theme.of(context);
    final isc = useInfiniteScrollController();
    final unreadOnly = useState(true);

    if (accStore.hasNoAccount) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('no accounts added')),
      );
    }

    final selectedInstance = selected.value!;

    toggleUnreadOnly() {
      unreadOnly.value = !unreadOnly.value;
      isc.clear();
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: RadioPicker<String>(
            onChanged: (val) {
              selected.value = val;
              isc.clear();
            },
            title: 'select instance',
            groupValue: selectedInstance,
            buttonBuilder: (context, displayString, onPressed) => TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15),
              ),
              onPressed: onPressed,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      displayString,
                      style: theme.appBarTheme.titleTextStyle,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            values: accStore.loggedInInstances.toList(),
          ),
          actions: [
            IconButton(
              icon: Icon(unreadOnly.value ? Icons.mail : Icons.mail_outline),
              onPressed: toggleUnreadOnly,
              tooltip: unreadOnly.value ? 'show all' : 'show only unread',
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: L10n.of(context).replies),
              Tab(text: L10n.of(context).mentions),
              Tab(text: L10n.of(context).messages),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SortableInfiniteList<CommentView>(
              noItems: const Text('no replies'),
              controller: isc,
              defaultSort: SortType.new_,
              fetcher: (page, batchSize, sortType) =>
                  LemmyApiV3(selectedInstance).run(GetReplies(
                auth: accStore.defaultUserDataFor(selectedInstance)!.jwt.raw,
                sort: sortType,
                limit: batchSize,
                page: page,
                unreadOnly: unreadOnly.value,
              )),
              itemBuilder: (cv) => CommentWidget.fromCommentView(
                cv,
                canBeMarkedAsRead: true,
                hideOnRead: unreadOnly.value,
              ),
              uniqueProp: (item) => item.comment.apId,
            ),
            SortableInfiniteList<PersonMentionView>(
              noItems: const Text('no mentions'),
              controller: isc,
              defaultSort: SortType.new_,
              fetcher: (page, batchSize, sortType) =>
                  LemmyApiV3(selectedInstance).run(GetPersonMentions(
                auth: accStore.defaultUserDataFor(selectedInstance)!.jwt.raw,
                sort: sortType,
                limit: batchSize,
                page: page,
                unreadOnly: unreadOnly.value,
              )),
              itemBuilder: (umv) => CommentWidget.fromPersonMentionView(
                umv,
                hideOnRead: unreadOnly.value,
              ),
              uniqueProp: (item) => item.personMention.id,
            ),
            InfiniteScroll<PrivateMessageView>(
              noItems: const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text('no messages'),
              ),
              controller: isc,
              fetcher: (page, batchSize) => LemmyApiV3(selectedInstance).run(
                GetPrivateMessages(
                  auth: accStore.defaultUserDataFor(selectedInstance)!.jwt.raw,
                  limit: batchSize,
                  page: page,
                  unreadOnly: unreadOnly.value,
                ),
              ),
              itemBuilder: (mv) => PrivateMessageTile(
                privateMessageView: mv,
                hideOnRead: unreadOnly.value,
              ),
              uniqueProp: (item) => item.privateMessage.apId,
            ),
          ],
        ),
      ),
    );
  }
}

class PrivateMessageTile extends HookWidget {
  final PrivateMessageView privateMessageView;
  final bool hideOnRead;

  const PrivateMessageTile({
    required this.privateMessageView,
    this.hideOnRead = false,
  });
  static const double _iconSize = 16;

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final theme = Theme.of(context);

    final pmv = useState(privateMessageView);
    final raw = useState(false);
    final selectable = useState(false);
    final deleted = useState(pmv.value.privateMessage.deleted);
    final deleteDelayed = useDelayedLoading(const Duration(milliseconds: 250));
    final read = useState(pmv.value.privateMessage.read);
    final readDelayed = useDelayedLoading(const Duration(milliseconds: 200));

    final toMe = useMemoized(() =>
        pmv.value.recipient.originInstanceHost == pmv.value.instanceHost &&
        pmv.value.recipient.id ==
            accStore.defaultUserDataFor(pmv.value.instanceHost)?.userId);

    final otherSide =
        useMemoized(() => toMe ? pmv.value.creator : pmv.value.recipient);

    void showMoreMenu() {
      showBottomModal(
        context: context,
        builder: (context) {
          pop() => Navigator.of(context).pop();
          return Column(
            children: [
              ListTile(
                title: Text(raw.value ? 'Show fancy' : 'Show raw'),
                leading: markdownModeIcon(fancy: !raw.value),
                onTap: () {
                  raw.value = !raw.value;
                  pop();
                },
              ),
              ListTile(
                title: Text('Make ${selectable.value ? 'un' : ''}selectable'),
                leading: Icon(
                    selectable.value ? Icons.assignment : Icons.content_cut),
                onTap: () {
                  selectable.value = !selectable.value;
                  pop();
                },
              ),
              ListTile(
                title: const Text('Nerd stuff'),
                leading: const Icon(Icons.info_outline),
                onTap: () {
                  pop();
                  showInfoTablePopup(
                      context: context, table: pmv.value.toJson());
                },
              ),
            ],
          );
        },
      );
    }

    handleDelete() => delayedAction<PrivateMessageView>(
          context: context,
          delayedLoading: deleteDelayed,
          instanceHost: pmv.value.instanceHost,
          query: DeletePrivateMessage(
            privateMessageId: pmv.value.privateMessage.id,
            auth: accStore.defaultUserDataFor(pmv.value.instanceHost)!.jwt.raw,
            deleted: !deleted.value,
          ),
          onSuccess: (val) => deleted.value = val.privateMessage.deleted,
        );

    handleRead() => delayedAction<PrivateMessageView>(
          context: context,
          delayedLoading: readDelayed,
          instanceHost: pmv.value.instanceHost,
          query: MarkPrivateMessageAsRead(
            privateMessageId: pmv.value.privateMessage.id,
            auth: accStore.defaultUserDataFor(pmv.value.instanceHost)!.jwt.raw,
            read: !read.value,
          ),
          // TODO: add notification for notifying parent list
          onSuccess: (val) => read.value = val.privateMessage.read,
        );

    if (hideOnRead && read.value) {
      return const SizedBox.shrink();
    }

    final body = raw.value
        ? selectable.value
            ? SelectableText(pmv.value.privateMessage.content)
            : Text(pmv.value.privateMessage.content)
        : MarkdownText(
            pmv.value.privateMessage.content,
            instanceHost: pmv.value.instanceHost,
            selectable: selectable.value,
          );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${toMe ? L10n.of(context).from : L10n.of(context).to} ',
                style: TextStyle(color: theme.textTheme.caption?.color),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => goToUser.fromPersonSafe(context, otherSide),
                child: Row(
                  children: [
                    if (otherSide.avatar != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: CachedNetworkImage(
                          imageUrl: otherSide.avatar!,
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
                          errorBuilder: (_, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    Text(
                      otherSide.originPreferredName,
                      style: TextStyle(color: theme.colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (pmv.value.privateMessage.updated != null) const Text('🖊  '),
              Text(pmv.value.privateMessage.updated?.timeago(context) ??
                  pmv.value.privateMessage.published.timeago(context)),
              const SizedBox(width: 5),
              Transform(
                transform: Matrix4Transform()
                    .rotateByCenter((toMe ? -1 : 1) * pi / 2,
                        const Size(_iconSize, _iconSize))
                    .flipVertically(
                        origin: const Offset(_iconSize / 2, _iconSize / 2))
                    .matrix4,
                child: const Opacity(
                  opacity: 0.8,
                  child: Icon(Icons.reply, size: _iconSize),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          if (pmv.value.privateMessage.deleted)
            Text(
              L10n.of(context).deleted_by_creator,
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          else
            body,
          Row(children: [
            const Spacer(),
            TileAction(
              icon: moreIcon,
              onPressed: showMoreMenu,
              tooltip: L10n.of(context).more,
            ),
            if (toMe) ...[
              TileAction(
                iconColor: read.value ? theme.colorScheme.secondary : null,
                icon: Icons.check,
                tooltip: L10n.of(context).mark_as_read,
                onPressed: handleRead,
                delayedLoading: readDelayed,
              ),
              TileAction(
                icon: Icons.reply,
                tooltip: L10n.of(context).reply,
                onPressed: () {
                  Navigator.of(context).push(
                    WriteMessagePage.sendRoute(
                      instanceHost: pmv.value.instanceHost,
                      recipient: otherSide,
                    ),
                  );
                },
              )
            ] else ...[
              TileAction(
                icon: Icons.edit,
                tooltip: L10n.of(context).edit,
                onPressed: () async {
                  final val = await Navigator.of(context)
                      .push(WriteMessagePage.editRoute(pmv.value));
                  if (val != null) pmv.value = val;
                },
              ),
              TileAction(
                delayedLoading: deleteDelayed,
                icon: deleted.value ? Icons.restore : Icons.delete,
                tooltip: deleted.value
                    ? L10n.of(context).restore
                    : L10n.of(context).delete,
                onPressed: handleDelete,
              ),
            ]
          ]),
          const Divider(),
        ],
      ),
    );
  }
}

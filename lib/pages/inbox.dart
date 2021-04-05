import 'dart:math' show pi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import '../util/more_icon.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/comment.dart';
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
            groupValue: selected.value,
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
                      style: theme.appBarTheme.textTheme.headline6,
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
                  LemmyApiV3(selected.value).run(GetReplies(
                auth: accStore.defaultTokenFor(selected.value).raw,
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
            ),
            SortableInfiniteList<PersonMentionView>(
              noItems: const Text('no mentions'),
              controller: isc,
              defaultSort: SortType.new_,
              fetcher: (page, batchSize, sortType) =>
                  LemmyApiV3(selected.value).run(GetPersonMentions(
                auth: accStore.defaultTokenFor(selected.value).raw,
                sort: sortType,
                limit: batchSize,
                page: page,
                unreadOnly: unreadOnly.value,
              )),
              itemBuilder: (umv) => CommentWidget.fromPersonMentionView(
                umv,
                hideOnRead: unreadOnly.value,
              ),
            ),
            InfiniteScroll<PrivateMessageView>(
              noItems: const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text('no messages'),
              ),
              controller: isc,
              fetcher: (page, batchSize) => LemmyApiV3(selected.value).run(
                GetPrivateMessages(
                  auth: accStore.defaultTokenFor(selected.value).raw,
                  limit: batchSize,
                  page: page,
                  unreadOnly: unreadOnly.value,
                ),
              ),
              itemBuilder: (mv) => PrivateMessageTile(
                privateMessageView: mv,
                hideOnRead: unreadOnly.value,
              ),
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
    @required this.privateMessageView,
    this.hideOnRead = false,
  })  : assert(privateMessageView != null),
        assert(hideOnRead != null);
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
            accStore.defaultTokenFor(pmv.value.instanceHost)?.payload?.sub);

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
            auth: accStore.defaultTokenFor(pmv.value.instanceHost)?.raw,
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
            auth: accStore.defaultTokenFor(pmv.value.instanceHost)?.raw,
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
                style: TextStyle(color: theme.textTheme.caption.color),
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
                          imageUrl: otherSide.avatar,
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
                    Text(
                      otherSide.originDisplayName,
                      style: TextStyle(color: theme.accentColor),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (pmv.value.privateMessage.updated != null) const Text('🖊  '),
              Text(pmv.value.privateMessage.updated?.fancy ??
                  pmv.value.privateMessage.published.fancy),
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
                iconColor: read.value ? theme.accentColor : null,
                icon: Icons.check,
                tooltip: L10n.of(context).mark_as_read,
                onPressed: handleRead,
                delayedLoading: readDelayed,
              ),
              TileAction(
                icon: Icons.reply,
                tooltip: L10n.of(context).reply,
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (_) => WriteMessagePage.send(
                            instanceHost: pmv.value.instanceHost,
                            recipient: otherSide,
                          ));
                },
              )
            ] else ...[
              TileAction(
                icon: Icons.edit,
                tooltip: L10n.of(context).edit,
                onPressed: () async {
                  final val = await showCupertinoModalPopup<PrivateMessageView>(
                      context: context,
                      builder: (_) => WriteMessagePage.edit(pmv.value));
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

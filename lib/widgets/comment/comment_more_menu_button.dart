import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../l10n/l10n.dart';
import '../../pages/view_on_menu.dart';
import '../../url_launcher.dart';
import '../../util/extensions/api.dart';
import '../../util/icons.dart';
import '../../util/observer_consumers.dart';
import '../../util/share.dart';
import '../bottom_modal.dart';
import '../markdown_mode_icon.dart';
import '../report_dialog.dart';
import '../tile_action.dart';
import '../write_comment.dart';
import 'comment.dart';
import 'comment_store.dart';

class CommentMoreMenuButton extends HookWidget {
  const CommentMoreMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final moreButtonKey = GlobalKey();
    return ObserverBuilder<CommentStore>(
      builder: (context, store) {
        return TileAction(
          key: moreButtonKey,
          icon: Icons.more_horiz,
          onPressed: () {
            showBottomModal(
              context: context,
              builder: (context) => _CommentMoreMenuPopup(
                store: store,
                moreButtonKey: moreButtonKey,
              ),
            );
          },
          loading: store.deletingState.isLoading,
          tooltip: L10n.of(context).more,
        );
      },
    );
  }
}

class _CommentMoreMenuPopup extends HookWidget {
  final CommentStore store;
  final GlobalKey moreButtonKey;

  const _CommentMoreMenuPopup({
    required this.store,
    required this.moreButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<CommentStore>(
      store: store,
      builder: (context, store) {
        final comment = store.comment.comment;
        final post = store.comment.post;

        handleDelete() {
          store.delete();
          Navigator.of(context).pop();
        }

        handleEdit() async {
          final editedComment = await Navigator.of(context).push(
            WriteComment.editRoute(
              comment: comment,
              post: post,
            ),
          );

          if (editedComment != null) {
            store.comment = editedComment;
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          }
        }

        final renderbox =
            moreButtonKey.currentContext!.findRenderObject()! as RenderBox;
        final position = renderbox.localToGlobal(Offset.zero);
        final targetRect = Rect.fromPoints(position,
            position.translate(renderbox.size.width, renderbox.size.height));

        final targetLanguage = Localizations.localeOf(context).languageCode;
        final sourceText = Uri.encodeComponent(comment.content);

        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: Text(L10n.of(context).open_in_browser),
              onTap: () async {
                await launchLink(link: comment.link, context: context);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.travel_explore),
              title: Text(L10n.of(context).view_on),
              onTap: () => ViewOnMenu.openForPost(context, comment.apId,
                  isSingleComment: true),
            ),
            ListTile(
              leading: Icon(shareIcon),
              title: Text(L10n.of(context).share_url),
              onTap: () {
                share(
                  comment.link,
                  sharePositionOrigin: targetRect,
                  context: context,
                );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(shareIcon),
              title: Text(L10n.of(context).share_text),
              onTap: () {
                share(
                  comment.content,
                  sharePositionOrigin: targetRect,
                  context: context,
                );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text(L10n.of(context).translate),
              onTap: () async {
                await launchLink(
                    link:
                        'https://translate.google.com/?tl=$targetLanguage&text=$sourceText',
                    context: context);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
            ListTile(
              leading: Icon(
                store.selectable ? Icons.assignment : Icons.content_cut,
              ),
              title: Text(
                store.selectable
                    ? L10n.of(context).make_text_unselectable
                    : L10n.of(context).make_text_selectable,
              ),
              onTap: () {
                store.toggleSelectable();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: markdownModeIcon(fancy: !store.showRaw),
              title: Text(store.showRaw
                  ? L10n.of(context).show_fancy_text
                  : L10n.of(context).show_raw_text),
              onTap: () {
                store.toggleShowRaw();
                Navigator.of(context).pop();
              },
            ),
            if (store.isMine) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(L10n.of(context).edit),
                onTap: handleEdit,
              ),
              ListTile(
                leading: Icon(comment.deleted ? Icons.restore : Icons.delete),
                title: Text(comment.deleted
                    ? L10n.of(context).restore_comment
                    : L10n.of(context).delete_comment),
                onTap: handleDelete,
              ),
            ] else if (store.isAuthenticated)
              ListTile(
                leading: store.blockingState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : const Icon(Icons.block),
                title: Text(
                    '${store.comment.creatorBlocked ? L10n.of(context).unblock : L10n.of(context).block} ${store.comment.creator.preferredName}'),
                onTap: () {
                  Navigator.of(context).pop();
                  store.block();
                },
              ),
            ListTile(
              leading: store.reportingState.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Icons.flag),
              title: Text(L10n.of(context).report_comment),
              onTap: store.reportingState.isLoading
                  ? null
                  : () async {
                      Navigator.of(context).pop();
                      final reason = await ReportDialog.show(context);
                      if (reason != null) {
                        await store.report(reason);
                      }
                    },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(L10n.of(context).nerd_stuff),
              onTap: () {
                Navigator.of(context).pop();
                CommentWidget.showCommentInfo(
                  context,
                  store.comment,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

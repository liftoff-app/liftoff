import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
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
  const CommentMoreMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObserverBuilder<CommentStore>(
      builder: (context, store) {
        return TileAction(
          icon: Icons.more_horiz,
          onPressed: () {
            showBottomModal(
              context: context,
              builder: (context) => _CommentMoreMenuPopup(store: store),
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

  const _CommentMoreMenuPopup({
    Key? key,
    required this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(store.comment.instanceHost);

    return ObserverBuilder<CommentStore>(
      store: store,
      builder: (context, store) {
        final comment = store.comment.comment;
        final post = store.comment.post;

        handleDelete(Jwt token) {
          store.delete(token);
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
            Navigator.of(context).pop();
          }
        }

        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open in browser'),
              onTap: () async {
                if (await ul.canLaunch(comment.link)) {
                  await ul.launch(comment.link);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("can't open in browser")),
                  );
                }

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(shareIcon),
              title: const Text('Share url'),
              onTap: () {
                share(comment.link, context: context);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(shareIcon),
              title: const Text('Share text'),
              onTap: () {
                share(comment.content, context: context);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                store.selectable ? Icons.assignment : Icons.content_cut,
              ),
              title: Text(
                'Make text ${store.selectable ? 'un' : ''}selectable',
              ),
              onTap: () {
                store.toggleSelectable();
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: markdownModeIcon(fancy: !store.showRaw),
              title: Text('Show ${store.showRaw ? 'fancy' : 'raw'} text'),
              onTap: () {
                store.toggleShowRaw();
                Navigator.of(context).pop();
              },
            ),
            if (store.isMine) ...[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: handleEdit,
              ),
              ListTile(
                leading: Icon(comment.deleted ? Icons.restore : Icons.delete),
                title: Text(comment.deleted ? 'Restore' : 'Delete'),
                onTap: loggedInAction(handleDelete),
              ),
            ] else
              ListTile(
                leading: store.blockingState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : const Icon(Icons.block),
                title: Text(
                    '${store.comment.creatorBlocked ? 'Unblock' : 'Block'} ${store.comment.creator.preferredName}'),
                onTap: loggedInAction((token) {
                  Navigator.of(context).pop();
                  store.block(token);
                }),
              ),
            ListTile(
              leading: store.reportingState.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Icons.flag),
              title: const Text('Report'),
              onTap: store.reportingState.isLoading
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      loggedInAction((token) async {
                        final reason = await ReportDialog.show(context);
                        if (reason != null) {
                          await store.report(token, reason);
                        }
                      })();
                    },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Nerd stuff'),
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

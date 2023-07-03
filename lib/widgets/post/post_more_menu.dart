import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../pages/create_post/create_post.dart';
import '../../pages/full_post/full_post_store.dart';
import '../../pages/settings/settings.dart';
import '../../stores/accounts_store.dart';
import '../../url_launcher.dart';
import '../../util/goto.dart';
import '../../util/icons.dart';
import '../../util/observer_consumers.dart';
import '../bottom_modal.dart';
import '../info_table_popup.dart';
import '../report_dialog.dart';
import 'post_store.dart';

class PostMoreMenuButton extends StatelessWidget {
  const PostMoreMenuButton();

  static void show({
    required BuildContext context,
    required PostStore postStore,
    required FullPostStore? fullPostStore,
  }) {
    // TODO: add blocking!
    showBottomModal(
      context: context,
      builder: (context) =>
          PostMoreMenu(postStore: postStore, fullPostStore: fullPostStore),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => show(
        context: context,
        postStore: context.read<PostStore>(),
        fullPostStore: null,
      ),
      icon: Icon(moreIcon),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}

class PostMoreMenu extends HookWidget {
  final PostStore postStore;
  final FullPostStore? fullPostStore;
  const PostMoreMenu({
    required this.postStore,
    required this.fullPostStore,
  });

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(postStore.postView.instanceHost);

    final isMine = context
            .read<AccountsStore>()
            .defaultUserDataFor(postStore.postView.instanceHost)
            ?.userId ==
        postStore.postView.creator.id;

    return ObserverBuilder<PostStore>(
        store: postStore,
        builder: (context, store) {
          final post = store.postView;

          final targetLanguage = Localizations.localeOf(context).languageCode;
          final sourceText = Uri.encodeComponent(
              '${post.post.name}\n---\n${post.post.body ?? ""}');

          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.open_in_browser),
                title: Text(L10n.of(context).open_in_browser),
                onTap: () {
                  launchLink(link: post.post.apId, context: context);
                  Navigator.of(context).pop();
                },
              ),
              if (isMine) ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: Text(L10n.of(context).edit),
                  onTap: () async {
                    final postView = await Navigator.of(context).push(
                      CreatePostPage.editRoute(post.post),
                    );

                    if (postView != null) {
                      store.updatePostView(postView);
                    }
                  },
                ),
                ListTile(
                  leading:
                      Icon(post.post.deleted ? Icons.restore : Icons.delete),
                  title: Text(post.post.deleted
                      ? L10n.of(context).restore_post
                      : L10n.of(context).delete_post),
                  onTap: store.deletingState.isLoading
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          loggedInAction((token) async {
                            await store.delete(token);
                          })();
                        },
                ),
              ] else
                ListTile(
                  leading: store.userBlockingState.isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : const Icon(Icons.block),
                  title: Text(post.creatorBlocked
                      ? L10n.of(context).unblock_user
                      : L10n.of(context).block_user),
                  onTap: () {
                    Navigator.of(context).pop();
                    loggedInAction(store.blockUser)();
                  },
                ),
              if (fullPostStore?.fullPostView != null)
                ObserverBuilder<FullPostStore>(
                  store: fullPostStore,
                  builder: (context, store) {
                    return ListTile(
                      leading: store.communityBlockingState.isLoading
                          ? const CircularProgressIndicator.adaptive()
                          : const Icon(Icons.block),
                      title: Text(store.fullPostView!.communityView.blocked
                          ? L10n.of(context).unblock_community
                          : L10n.of(context).block_community),
                      onTap: () {
                        Navigator.of(context).pop();
                        loggedInAction(store.blockCommunity)();
                      },
                    );
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

                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: store.reportingState.isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Icon(Icons.flag),
                title: Text(L10n.of(context).report_post),
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
                title: Text(L10n.of(context).nerd_stuff),
                onTap: () {
                  showInfoTablePopup(context: context, table: {
                    '% of upvotes':
                        '${(100 * (post.counts.upvotes / (post.counts.upvotes + post.counts.downvotes))).toInt()}%',
                    ...post.toJson(),
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(L10n.of(context).settings),
                onTap: () {
                  goTo(context, (_) => const SettingsPage());
                },
              ),
            ],
          );
        });
  }
}

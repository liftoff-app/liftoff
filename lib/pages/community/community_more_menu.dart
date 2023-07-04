import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../url_launcher.dart';
import '../../util/extensions/api.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_modal.dart';
import '../../widgets/info_table_popup.dart';
import '../view_on_menu.dart';
import 'community_store.dart';

class CommunityMoreMenu extends HookWidget {
  final FullCommunityView fullCommunityView;

  const CommunityMoreMenu({super.key, required this.fullCommunityView});

  @override
  Widget build(BuildContext context) {
    final communityView = fullCommunityView.communityView;

    final loggedInAction = useLoggedInAction(communityView.instanceHost);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(L10n.of(context).open_in_browser),
          onTap: () => launchLink(
            link: communityView.community.actorId,
            context: context,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.travel_explore),
          title: Text(L10n.of(context).view_on),
          onTap: () => ViewOnMenu.openForCommunity(context, communityView),
        ),
        ObserverBuilder<CommunityStore>(builder: (context, store) {
          return ListTile(
            leading: store.blockingState.isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.block),
            title: Text(
                '${fullCommunityView.communityView.blocked ? L10n.of(context).unblock : L10n.of(context).block} ${communityView.community.preferredName}'),
            onTap: store.blockingState.isLoading
                ? null
                : loggedInAction((userData) {
                    store.block(userData);
                    Navigator.of(context).pop();
                  }),
          );
        }),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(L10n.of(context).nerd_stuff),
          onTap: () {
            showInfoTablePopup(context: context, table: communityView.toJson());
          },
        ),
      ],
    );
  }

  static void open(BuildContext context, FullCommunityView fullCommunityView) {
    final store = context.read<CommunityStore>();

    showBottomModal(
      context: context,
      builder: (context) => MobxProvider.value(
        value: store,
        child: CommunityMoreMenu(
          fullCommunityView: fullCommunityView,
        ),
      ),
    );
  }
}

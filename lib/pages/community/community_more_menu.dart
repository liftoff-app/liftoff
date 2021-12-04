import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../../hooks/logged_in_action.dart';
import '../../util/extensions/api.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_modal.dart';
import '../../widgets/info_table_popup.dart';
import 'community_store.dart';

class CommunityMoreMenu extends HookWidget {
  final FullCommunityView fullCommunityView;

  const CommunityMoreMenu({Key? key, required this.fullCommunityView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final communityView = fullCommunityView.communityView;

    final loggedInAction = useLoggedInAction(communityView.instanceHost);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: const Text('Open in browser'),
          onTap: () async => await ul.canLaunch(communityView.community.actorId)
              ? ul.launch(communityView.community.actorId)
              : ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("can't open in browser"))),
        ),
        ObserverBuilder<CommunityStore>(builder: (context, store) {
          return ListTile(
            leading: store.blockingState.isLoading
                ? const CircularProgressIndicator.adaptive()
                : const Icon(Icons.block),
            title: Text(
                '${fullCommunityView.communityView.blocked ? 'Unblock' : 'Block'} ${communityView.community.preferredName}'),
            onTap: store.blockingState.isLoading
                ? null
                : loggedInAction((token) {
                    store.block(token);
                    Navigator.of(context).pop();
                  }),
          );
        }),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Nerd stuff'),
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

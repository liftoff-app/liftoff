import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_modal.dart';
import '../../widgets/info_table_popup.dart';

class InstanceMoreMenu extends StatelessWidget {
  final FullSiteView site;

  const InstanceMoreMenu({Key? key, required this.site}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instanceUrl = 'https://${site.instanceHost}';
    final accountsStore = context.watch<AccountsStore>();

    return Column(
      children: [
        if (!accountsStore.instances.contains(site.instanceHost))
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(L10n.of(context).add_instance),
            onTap: () {
              accountsStore.addInstance(site.instanceHost, assumeValid: true);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text(L10n.of(context).instance_added)),
                );
            },
          ),
        ListTile(
          leading: const Icon(Icons.open_in_browser),
          title: Text(L10n.of(context).open_in_browser),
          onTap: () async {
            if (await ul.canLaunch(instanceUrl)) {
              await ul.launch(instanceUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L10n.of(context).cannot_open_in_browser),
                ),
              );
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(L10n.of(context).nerd_stuff),
          onTap: () {
            showInfoTablePopup(context: context, table: site.toJson());
          },
        ),
      ],
    );
  }

  static void open(BuildContext context, FullSiteView site) {
    showBottomModal(
      context: context,
      builder: (context) => InstanceMoreMenu(site: site),
    );
  }
}

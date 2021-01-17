import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/user_profile.dart';
import 'settings.dart';

/// Profile page for a logged in user. The difference between this and
/// UserPage is that here you have access to settings
class UserProfileTab extends HookWidget {
  const UserProfileTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    final actions = [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          goTo(context, (_) => const SettingsPage());
        },
      )
    ];

    if (accountsStore.hasNoAccount) {
      return Scaffold(
        appBar: AppBar(
          actions: actions,
          backgroundColor: Colors.transparent,
          iconTheme: theme.iconTheme,
          shadowColor: Colors.transparent,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No account was added.'),
              FlatButton.icon(
                onPressed: () {
                  goTo(context, (_) => AccountsConfigPage());
                },
                icon: const Icon(Icons.add),
                label: const Text('Add account'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      // TODO: this is not visible in light mode when the sliver app bar
      // in UserProfile is folded
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
        title: FlatButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (ctx) {
                final userTags = <String>[
                  for (final instanceHost in accountsStore.loggedInInstances)
                    for (final username
                        in accountsStore.usernamesFor(instanceHost))
                      '$username@$instanceHost'
                ];

                return BottomModal(
                  title: 'account',
                  child: Column(
                    children: [
                      for (final tag in userTags)
                        RadioListTile<String>(
                          value: tag,
                          title: Text(tag),
                          groupValue: '${accountsStore.defaultUsername}'
                              '@${accountsStore.defaultInstanceHost}',
                          onChanged: (selected) {
                            final userTag = selected.split('@');
                            accountsStore.setDefaultAccount(
                                userTag[1], userTag[0]);
                            Navigator.of(ctx).pop();
                          },
                        )
                    ],
                  ),
                );
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                // TODO: fix overflow issues
                '@${accountsStore.defaultUsername}',
                style: theme.primaryTextTheme.headline6,
                overflow: TextOverflow.fade,
              ),
              Icon(
                Icons.expand_more,
                color: theme.primaryIconTheme.color,
              ),
            ],
          ),
        ),
        actions: actions,
      ),
      body: UserProfile(
        userId: accountsStore.defaultToken.payload.id,
        instanceHost: accountsStore.defaultInstanceHost,
      ),
    );
  }
}

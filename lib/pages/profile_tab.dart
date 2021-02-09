import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/radio_picker.dart';
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
        appBar: AppBar(actions: actions),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No account was added.'),
              TextButton.icon(
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
      appBar: AppBar(
        title: RadioPicker<String>(
          title: 'account',
          values: accountsStore.loggedInInstances
              .expand(
                (instanceHost) => accountsStore
                    .usernamesFor(instanceHost)
                    .map((username) => '$username@$instanceHost'),
              )
              .toList(),
          groupValue:
              '${accountsStore.defaultUsername}@${accountsStore.defaultInstanceHost}',
          onChanged: (value) {
            final userTag = value.split('@');
            accountsStore.setDefaultAccount(userTag[1], userTag[0]);
          },
          buttonBuilder: (context, displayValue, onPressed) => TextButton(
            onPressed: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  // TODO: fix overflow issues
                  displayValue,
                  style: theme.appBarTheme.textTheme.headline6,
                  overflow: TextOverflow.fade,
                ),
                const Icon(Icons.expand_more),
              ],
            ),
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

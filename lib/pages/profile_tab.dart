import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/user_profile.dart';
import 'settings.dart';

/// Profile page for a logged in user. The difference between this and
/// UserPage is that here you have access to settings
class UserProfileTab extends HookWidget {
  UserProfileTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    return Observer(
      builder: (ctx) {
        if (accountsStore.hasNoAccount) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No account was added.'),
                  FlatButton.icon(
                    onPressed: () {
                      goTo(context, (_) => AccountsConfigPage());
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add account'),
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) {
                    final userTags = <String>[];

                    accountsStore.tokens.forEach((instanceUrl, value) {
                      value.forEach((username, _) {
                        userTags.add('$username@$instanceUrl');
                      });
                    });

                    return Observer(
                      builder: (ctx) => BottomModal(
                        title: 'account',
                        child: Column(
                          children: [
                            for (final tag in userTags)
                              RadioListTile<String>(
                                value: tag,
                                title: Text(tag),
                                groupValue: '${accountsStore.defaultUsername}'
                                    '@${accountsStore.defaultInstanceUrl}',
                                onChanged: (selected) {
                                  final userTag = selected.split('@');
                                  accountsStore.setDefaultAccount(
                                      userTag[1], userTag[0]);
                                  Navigator.of(ctx).pop();
                                },
                              )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  goTo(context, (_) => SettingsPage());
                },
              )
            ],
          ),
          body: UserProfile(
            userId: accountsStore.defaultToken.payload.id,
            instanceUrl: accountsStore.defaultInstanceUrl,
          ),
        );
      },
    );
  }
}

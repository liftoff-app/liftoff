import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../hooks/stores.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/user_profile.dart';
import 'settings.dart';

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

        final user = accountsStore.defaultUser;

        return Scaffold(
          extendBodyBehindAppBar: true,
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
                    '@${user.name}', // TODO: fix overflow issues
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

                    accountsStore.users.forEach((instanceUrl, value) {
                      value.forEach((username, _) {
                        userTags.add('$username@$instanceUrl');
                      });
                    });

                    return Observer(
                      builder: (ctx) {
                        final user = accountsStore.defaultUser;
                        final instanceUrl = user.instanceUrl;

                        return BottomModal(
                          title: 'account',
                          child: Column(
                            children: [
                              for (final tag in userTags)
                                RadioListTile<String>(
                                  value: tag,
                                  title: Text(tag),
                                  groupValue: '${user.name}@$instanceUrl',
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
            userId: user.id,
            instanceUrl: user.instanceUrl,
          ),
        );
      },
    );
  }
}

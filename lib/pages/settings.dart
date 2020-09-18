import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import 'add_account.dart';
import 'add_instance.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Settings', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Accounts'),
              onTap: () {
                goTo(context, (_) => AccountsConfigPage());
              },
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Appearance'),
              onTap: () {
                goTo(context, (_) => AppearanceConfigPage());
              },
            )
          ],
        ),
      ),
    );
  }
}

class AppearanceConfigPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configStore = useConfigStore();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Appearance', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: Observer(
        builder: (ctx) => ListView(
          children: [
            _SectionHeading('Theme'),
            for (final theme in ThemeMode.values)
              RadioListTile<ThemeMode>(
                value: theme,
                title: Text(theme.toString().split('.')[1]),
                groupValue: configStore.theme,
                onChanged: (selected) {
                  configStore.theme = selected;
                },
              ),
            SwitchListTile(
                title: Text('AMOLED dark mode'),
                value: configStore.amoledDarkMode,
                onChanged: (checked) {
                  configStore.amoledDarkMode = checked;
                })
          ],
        ),
      ),
    );
  }
}

class AccountsConfigPage extends HookWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Accounts', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCupertinoModalPopup(
              context: context, builder: (_) => AddInstancePage());
        },
        child: Icon(Icons.add),
      ),
      body: Observer(
        builder: (ctx) {
          final theme = Theme.of(context);

          return ListView(
            children: [
              for (final entry in accountsStore.users.entries) ...[
                _SectionHeading(entry.key),
                for (final username in entry.value.keys) ...[
                  ListTile(
                    trailing:
                        username == accountsStore.defaultUserFor(entry.key).name
                            ? Icon(
                                Icons.check_circle_outline,
                                color: theme.accentColor,
                              )
                            : null,
                    title: Text(username),
                    onLongPress: () {
                      accountsStore.setDefaultAccountFor(entry.key, username);
                    },

                    onTap: () {}, // TODO: go to managing account
                  ),
                ],
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add account'),
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (_) => AddAccountPage(instanceUrl: entry.key));
                  },
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;

  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      child: Text(text.toUpperCase(),
          style: theme.textTheme.subtitle2.copyWith(color: theme.accentColor)),
      padding: EdgeInsets.only(left: 20, top: 40),
    );
  }
}

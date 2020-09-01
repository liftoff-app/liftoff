import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';
import '../stores/config_store.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => _AccountsConfig()));
              },
            ),
            ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Appearance'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => _AppearanceConfig()));
              },
            )
          ],
        ),
      ),
    );
  }
}

class _AppearanceConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Appearance', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: Observer(
        builder: (ctx) => Column(
          children: [
            Text(
              'Theme',
              style: theme.textTheme.headline6,
            ),
            for (final theme in ThemeMode.values)
              RadioListTile<ThemeMode>(
                value: theme,
                title: Text(theme.toString().split('.')[1]),
                groupValue: ctx.watch<ConfigStore>().theme,
                onChanged: (selected) {
                  ctx.read<ConfigStore>().theme = selected;
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _AccountsConfig extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Accounts', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: Observer(
        builder: (ctx) {
          var accountsStore = ctx.watch<AccountsStore>();
          var theme = Theme.of(context);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var entry in accountsStore.users.entries) ...[
                Text(
                  entry.key,
                  style: theme.textTheme.subtitle2,
                ),
                for (var username in entry.value.keys) ...[
                  ListTile(
                    trailing:
                        username == accountsStore.defaultUserFor(entry.key).name
                            ? Icon(Icons.check_circle_outline)
                            : null,
                    selected: username ==
                        accountsStore.defaultUserFor(entry.key).name,
                    title: Text(username),
                    onLongPress: () {
                      accountsStore.setDefaultAccountFor(entry.key, username);
                    },
                    onTap: () {}, // TODO: go to managing account
                  ),
                ],
                Divider(),
              ]
            ]..removeLast(), // removes trailing Divider
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';
import '../stores/config_store.dart';

class SettingsPage extends StatelessWidget {
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
        builder: (ctx) => ListView(
          children: [
            _SectionHeading('Theme'),
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

class _AccountsConfig extends HookWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textFieldController = useTextEditingController();

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
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Add instance'),
              content: TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Instance url',
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Add'),
                  onPressed: () async {
                    try {
                      await context
                          .read<AccountsStore>()
                          .addInstance(textFieldController.text);
                    } on Exception catch (err) {
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(err.toString()),
                      ));
                    }
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
          textFieldController.clear();
        },
        child: Icon(Icons.add),
      ),
      body: Observer(
        builder: (ctx) {
          var accountsStore = ctx.watch<AccountsStore>();
          var theme = Theme.of(context);

          return ListView(
            children: [
              for (var entry in accountsStore.users.entries) ...[
                _SectionHeading(entry.key),
                for (var username in entry.value.keys) ...[
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
                Divider(),
              ]
            ]..removeLast(), // removes trailing Divider
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

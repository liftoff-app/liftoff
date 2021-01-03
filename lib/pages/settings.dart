import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/about_tile.dart';
import 'add_account.dart';
import 'add_instance.dart';

/// Page with a list of different settings sections
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        brightness: theme.brightness,
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Settings', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: ListView(
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
          ),
          AboutTile()
        ],
      ),
    );
  }
}

/// Settings for theme color, AMOLED switch
class AppearanceConfigPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configStore = useConfigStore();

    return Scaffold(
      appBar: AppBar(
        brightness: theme.brightness,
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Appearance', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _SectionHeading('Theme'),
          for (final theme in ThemeMode.values)
            RadioListTile<ThemeMode>(
              value: theme,
              title: Text(describeEnum(theme)),
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
    );
  }
}

/// Settings for managing accounts
class AccountsConfigPage extends HookWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    removeInstanceDialog(String instanceHost) async {
      if (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Remove instance?'),
              content: Text('Are you sure you want to remove $instanceHost?'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('no'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('yes'),
                ),
              ],
            ),
          ) ??
          false) {
        accountsStore.removeInstance(instanceHost);
      }
    }

    Future<void> removeUserDialog(String instanceHost, String username) async {
      if (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Remove user?'),
              content: Text(
                  'Are you sure you want to remove $username@$instanceHost?'),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('no'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('yes'),
                ),
              ],
            ),
          ) ??
          false) {
        accountsStore.removeAccount(instanceHost, username);
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        brightness: theme.brightness,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title: Text('Accounts', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close, // TODO: change to + => x
        curve: Curves.bounceIn,
        tooltip: 'Add account or instance',
        overlayColor: theme.canvasColor,
        children: [
          SpeedDialChild(
            child: Icon(Icons.person_add),
            label: 'Add account',
            labelBackgroundColor: theme.canvasColor,
            onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (_) =>
                    AddAccountPage(instanceHost: accountsStore.instances.last)),
          ),
          SpeedDialChild(
            child: Icon(Icons.dns),
            labelBackgroundColor: theme.canvasColor,
            label: 'Add instance',
            onTap: () => showCupertinoModalPopup(
                context: context, builder: (_) => AddInstancePage()),
          ),
        ],
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          if (accountsStore.tokens.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: FlatButton.icon(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () => showCupertinoModalPopup(
                            context: context,
                            builder: (_) => AddInstancePage(),
                          ),
                      icon: Icon(Icons.add),
                      label: Text('Add instance')),
                ),
              ],
            ),
          for (final entry in accountsStore.tokens.entries) ...[
            SizedBox(height: 40),
            Slidable(
              actionPane: SlidableBehindActionPane(),
              secondaryActions: [
                IconSlideAction(
                  onTap: () => removeInstanceDialog(entry.key),
                  icon: Icons.delete_sweep,
                  color: Colors.red,
                ),
              ],
              key: Key(entry.key),
              child: Container(
                color: theme.canvasColor,
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: _SectionHeading(entry.key),
                ),
              ),
            ),
            for (final username in entry.value.keys) ...[
              Slidable(
                actionPane: SlidableBehindActionPane(),
                key: Key('$username@${entry.key}'),
                secondaryActions: [
                  IconSlideAction(
                    onTap: () => removeUserDialog(entry.key, username),
                    icon: Icons.delete_sweep,
                    color: Colors.red,
                  ),
                ],
                child: Container(
                  decoration: BoxDecoration(color: theme.canvasColor),
                  child: ListTile(
                    trailing:
                        username == accountsStore.defaultUsernameFor(entry.key)
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
                ),
              ),
            ],
            if (entry.value.keys.isEmpty)
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add account'),
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (_) => AddAccountPage(instanceHost: entry.key));
                },
              ),
          ]
        ],
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
      padding: EdgeInsets.only(left: 20),
      child: Text(text.toUpperCase(),
          style: theme.textTheme.subtitle2.copyWith(color: theme.accentColor)),
    );
  }
}

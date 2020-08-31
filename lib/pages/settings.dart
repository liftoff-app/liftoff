import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

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
              onTap: () {},
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
            Text(
              'Accent color',
              style: theme.textTheme.headline6,
            ),
            // TODO: add accent color picking
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../widgets/user_profile.dart';
import 'settings.dart';

class UserProfileTab extends HookWidget {
  final User user;

  UserProfileTab(this.user);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

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
                '@${user.name}',
                style: TextStyle(color: theme.accentTextTheme.bodyText1.color),
              ),
              Icon(
                Icons.expand_more,
                color: theme.primaryIconTheme.color,
              ),
            ],
          ),
          onPressed: () {}, // TODO: should open bottomsheet
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => Settings()));
            }, // TODO: go to settings
          )
        ],
      ),
      body: UserProfile(user),
    );
  }
}

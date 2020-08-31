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
                style: TextStyle(color: Colors.white),
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
            icon: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black54,
                )
              ]),
              child: Icon(
                Icons.settings,
                color: user.banner == null ? theme.iconTheme.color : null,
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => Settings()));
            },
          )
        ],
      ),
      body: UserProfile(user),
    );
  }
}

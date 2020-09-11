import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../widgets/user_profile.dart';

class UserPage extends HookWidget {
  final int userId;
  final String instanceUrl;
  final Future<UserView> _userView;

  UserPage({@required this.userId, @required this.instanceUrl})
      : assert(userId != null),
        assert(instanceUrl != null),
        _userView = LemmyApi(instanceUrl)
            .v1
            .getUserDetails(
                userId: userId, savedOnly: true, sort: SortType.active)
            .then((res) => res.user);
  UserPage.fromName({@required this.instanceUrl, @required username})
      : assert(instanceUrl != null),
        assert(username != null),
        userId = null,
        _userView = LemmyApi(instanceUrl)
            .v1
            .getUserDetails(
                username: username, savedOnly: true, sort: SortType.active)
            .then((res) => res.user);

  @override
  Widget build(BuildContext context) {
    var userViewSnap = useFuture(_userView);

    var body = () {
      if (userViewSnap.hasData) {
        return UserProfile.fromUserView(userViewSnap.data);
      } else if (userViewSnap.hasError) {
        return Center(child: Text('Could not find that user.'));
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          if (userViewSnap.hasData) ...[
            IconButton(
              icon: Icon(Icons.email),
              onPressed: () {}, // TODO: go to messaging page
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.text(
                  'Share user', userViewSnap.data.actorId, 'text/plain'),
            )
          ]
        ],
      ),
      body: body,
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/logged_in_action.dart';
import '../util/share.dart';
import '../widgets/user_profile.dart';
import 'write_message.dart';

/// Page showing posts, comments, and general info about a user.
class UserPage extends HookWidget {
  final int userId;
  final String instanceHost;
  final Future<FullPersonView> _userDetails;

  UserPage({@required this.userId, @required this.instanceHost})
      : assert(userId != null),
        assert(instanceHost != null),
        _userDetails = LemmyApiV3(instanceHost).run(GetPersonDetails(
            personId: userId, savedOnly: true, sort: SortType.active));

  UserPage.fromName({@required this.instanceHost, @required String username})
      : assert(instanceHost != null),
        assert(username != null),
        userId = null,
        _userDetails = LemmyApiV3(instanceHost).run(GetPersonDetails(
            username: username, savedOnly: true, sort: SortType.active));

  @override
  Widget build(BuildContext context) {
    final userDetailsSnap = useFuture(_userDetails, initialData: null);

    final body = () {
      if (userDetailsSnap.hasData) {
        return UserProfile.fromFullPersonView(userDetailsSnap.data);
      } else if (userDetailsSnap.hasError) {
        return const Center(child: Text('Could not find that user.'));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          if (userDetailsSnap.hasData) ...[
            SendMessageButton(userDetailsSnap.data.personView.person),
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => share(
                userDetailsSnap.data.personView.person.actorId,
                context: context,
              ),
            ),
          ]
        ],
      ),
      body: body,
    );
  }
}

class SendMessageButton extends HookWidget {
  final PersonSafe user;

  const SendMessageButton(this.user);

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(user.instanceHost);

    return IconButton(
      icon: const Icon(Icons.email),
      onPressed: loggedInAction((token) => showCupertinoModalPopup(
          context: context,
          builder: (_) => WriteMessagePage.send(
                instanceHost: user.instanceHost,
                recipient: user,
              ))),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/logged_in_action.dart';
import '../util/icons.dart';
import '../util/share.dart';
import '../widgets/user_profile.dart';
import 'write_message.dart';

/// Page showing posts, comments, and general info about a user.
class UserPage extends HookWidget {
  final int? userId;
  final String instanceHost;
  final Future<FullPersonView> _userDetails;

  UserPage({required this.userId, required this.instanceHost})
      : _userDetails = LemmyApiV3(instanceHost).run(GetPersonDetails(
            personId: userId, savedOnly: true, sort: SortType.active));

  UserPage.fromName({required this.instanceHost, required String username})
      : userId = null,
        _userDetails = LemmyApiV3(instanceHost).run(GetPersonDetails(
            username: username, savedOnly: true, sort: SortType.active));

  @override
  Widget build(BuildContext context) {
    final userDetailsSnap = useFuture(_userDetails);
    final shareButtonKey = GlobalKey();

    final body = () {
      if (userDetailsSnap.hasData) {
        return UserProfile.fromFullPersonView(userDetailsSnap.data!);
      } else if (userDetailsSnap.hasError) {
        return const Center(child: Text('Could not find that user.'));
      } else {
        return const Center(child: CircularProgressIndicator.adaptive());
      }
    }();
    shareUserSnap() {
      final renderbox =
          shareButtonKey.currentContext!.findRenderObject()! as RenderBox;
      final position = renderbox.localToGlobal(Offset.zero);

      return share(userDetailsSnap.data!.personView.person.actorId,
          context: context,
          sharePositionOrigin: Rect.fromPoints(position,
              position.translate(renderbox.size.width, renderbox.size.height)));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          if (userDetailsSnap.hasData) ...[
            SendMessageButton(userDetailsSnap.data!.personView.person),
            IconButton(
              key: shareButtonKey,
              icon: Icon(shareIcon),
              onPressed: shareUserSnap,
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
      onPressed: loggedInAction(
        (token) => Navigator.of(context).push(
          WriteMessagePage.sendRoute(
            instanceHost: user.instanceHost,
            recipient: user,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/logged_in_action.dart';
import '../stores/accounts_store.dart';
import '../util/icons.dart';
import '../util/share.dart';
import '../widgets/user_profile.dart';
import 'write_message.dart';

/// Page showing posts, comments, and general info about a user.
class UserPage extends HookWidget {
  final int? userId;
  final String instanceHost;
  final Future<FullPersonView> _userDetails;
  final UserData? userData;

  UserPage(
      {super.key,
      required this.userId,
      required this.instanceHost,
      required this.userData})
      : _userDetails = LemmyApiV3(instanceHost).run(GetPersonDetails(
            personId: userId,
            savedOnly: true,
            sort: SortType.active,
            auth: userData?.jwt.raw));

  UserPage.fromName(
      {super.key,
      required this.instanceHost,
      required String username,
      required this.userData})
      : userId = null,
        _userDetails = LemmyApiV3(instanceHost).run(GetPersonDetails(
            username: username,
            savedOnly: true,
            sort: SortType.active,
            auth: userData?.jwt.raw));

  @override
  Widget build(BuildContext context) {
    final userDetailsSnap = useFuture(_userDetails);
    final shareButtonKey = GlobalKey();

    final body = () {
      if (userDetailsSnap.hasData) {
        return UserProfile.fromFullPersonView(userDetailsSnap.data!, userData);
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

      return share(
          buildLemmyGuideUrl(
              '@${userDetailsSnap.data!.personView.person.name}@$instanceHost'),
          context: context,
          sharePositionOrigin: Rect.fromPoints(position,
              position.translate(renderbox.size.width, renderbox.size.height)));
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          if (userDetailsSnap.hasData) ...[
            if (userData != null)
              SendMessageButton(
                  userDetailsSnap.data!.personView.person, userData!),
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
  final UserData userData;

  const SendMessageButton(this.user, this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(user.instanceHost);

    return IconButton(
      icon: const Icon(Icons.email),
      onPressed: loggedInAction(
        (token) => Navigator.of(context).push(
          WriteMessagePage.sendRoute(
            recipient: user,
            userData: userData,
          ),
        ),
      ),
    );
  }
}

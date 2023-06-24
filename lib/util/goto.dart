import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../pages/community/community.dart';
import '../pages/full_post/full_post.dart';
import '../pages/media_view.dart';
import '../pages/user.dart';

import '../stores/config_store.dart';
import '../util/observer_consumers.dart';

/// Pushes onto the navigator stack the given widget
Future<dynamic> goTo(
  BuildContext context,
  Widget Function(BuildContext context) builder,
) =>
    Navigator.of(context).push(MaterialPageRoute(
      builder: builder,
    ));

/// Replaces the top of the navigator stack with the given widget
Future<dynamic> goToReplace(
  BuildContext context,
  Widget Function(BuildContext context) builder,
) =>
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: builder,
    ));

// ignore: camel_case_types
abstract class goToCommunity {
  /// Navigates to `CommunityPage`
  static void byId(
          BuildContext context, String instanceHost, int communityId) =>
      Navigator.of(context)
          .push(CommunityPage.fromIdRoute(instanceHost, communityId));

  static void byName(
          BuildContext context, String instanceHost, String communityName) =>
      Navigator.of(context)
          .push(CommunityPage.fromNameRoute(instanceHost, communityName));
}

// ignore: camel_case_types
abstract class goToUser {
  static void byId(BuildContext context, String instanceHost, int userId) =>
      goTo(context,
          (context) => UserPage(instanceHost: instanceHost, userId: userId));

  static void byName(
          BuildContext context, String instanceHost, String userName) =>
      throw UnimplementedError('need to create UserProfile constructor first');

  static void fromPersonSafe(BuildContext context, PersonSafe personSafe) =>
      goToUser.byId(context, personSafe.instanceHost, personSafe.id);
}

void goToPost(BuildContext context, String instanceHost, int postId) =>
    Navigator.of(context).push(FullPostPage.route(postId, instanceHost));

void goToMedia(BuildContext context, String url) {
  final store = Provider.of<ConfigStore>(context, listen: false);

  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => MediaViewPage(url),
      opaque: false,
      transitionsBuilder: (_, animation, __, child) =>
          TweenAnimationBuilder<double>(
        duration: Duration(
          milliseconds: store.disableAnimations ? 1 : 2000,
        ),
        tween: Tween<double>(begin: 0, end: 1),
        builder: (_, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: child,
      ),
    ),
  );
}

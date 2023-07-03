import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

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

// Pushes onto the navigator stack the given widget with a swipeable back navigation
Future<dynamic> goToSwipeable(
  BuildContext context,
  Widget Function(BuildContext context) builder,
) =>
    Navigator.of(context).push(SwipeablePageRoute(
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
      goToSwipeable(context,
          (context) => UserPage(instanceHost: instanceHost, userId: userId));

  static void byName(
          BuildContext context, String instanceHost, String userName) =>
      throw UnimplementedError('need to create UserProfile constructor first');

  static void fromPersonSafe(BuildContext context, PersonSafe personSafe) =>
      goToUser.byId(context, personSafe.instanceHost, personSafe.id);
}

void goToPost(BuildContext context, String instanceHost, int postId) =>
    Navigator.of(context).push(FullPostPage.route(postId, instanceHost));

void goToMedia(BuildContext context, String url, String heroTag) {
  final store = Provider.of<ConfigStore>(context, listen: false);

  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => MediaViewPage(url, heroTag: heroTag),
      opaque: false,
      transitionDuration: Duration(
        milliseconds: store.disableAnimations ? 1 : 200,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curve = CurveTween(curve: Curves.easeOut);
        return FadeTransition(
          opacity: animation.drive(curve),
          child: child,
        );
      },
    ),
  );
}

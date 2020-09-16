import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/community.dart';
import '../pages/full_post.dart';
import '../pages/instance.dart';
import '../pages/user.dart';

Future<dynamic> goTo(
  BuildContext context,
  Widget Function(BuildContext context) builder,
) =>
    Navigator.of(context).push(CupertinoPageRoute(
      builder: builder,
    ));

void goToInstance(BuildContext context, String instanceUrl) =>
    goTo(context, (context) => InstancePage(instanceUrl: instanceUrl));

// ignore: camel_case_types
abstract class goToCommunity {
  /// Navigates to `CommunityPage`
  static void byId(BuildContext context, String instanceUrl, int communityId) =>
      goTo(
        context,
        (context) => CommunityPage.fromId(
            instanceUrl: instanceUrl, communityId: communityId),
      );

  static void byName(
          BuildContext context, String instanceUrl, String communityName) =>
      goTo(
        context,
        (context) => CommunityPage.fromName(
            instanceUrl: instanceUrl, communityName: communityName),
      );
}

// ignore: camel_case_types
abstract class goToUser {
  static void byId(BuildContext context, String instanceUrl, int userId) =>
      goTo(context,
          (context) => UserPage(instanceUrl: instanceUrl, userId: userId));

  static void byName(
          BuildContext context, String instanceUrl, String userName) =>
      throw UnimplementedError('need to create UserProfile constructor first');
}

void goToPost(BuildContext context, String instanceUrl, int postId) => goTo(
    context, (context) => FullPostPage(instanceUrl: instanceUrl, id: postId));

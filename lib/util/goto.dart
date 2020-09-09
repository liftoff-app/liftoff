import 'package:flutter/material.dart';

import '../pages/community.dart';
import '../pages/instance.dart';
import '../widgets/user_profile.dart';

void goToInstance(BuildContext context, String instanceUrl) =>
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => InstancePage(instanceUrl: instanceUrl),
    ));

// ignore: camel_case_types
abstract class goToCommunity {
  /// Navigates to `CommunityPage`
  static void byId(BuildContext context, String instanceUrl, int communityId) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CommunityPage.fromId(
            instanceUrl: instanceUrl, communityId: communityId),
      ));

  static void byName(
          BuildContext context, String instanceUrl, String communityName) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CommunityPage.fromName(
            instanceUrl: instanceUrl, communityName: communityName),
      ));
}

// ignore: camel_case_types
abstract class goToUser {
  static void byId(BuildContext context, String instanceUrl, int userId) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              UserProfile(instanceUrl: instanceUrl, userId: userId)));

  static void byName(
          BuildContext context, String instanceUrl, String userName) =>
      throw UnimplementedError('need to create UserProfile constructor first');
}

void goToPost(BuildContext context, String instanceUrl, int postId) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            UserProfile(instanceUrl: instanceUrl, userId: postId)));

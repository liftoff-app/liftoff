import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../cleanup_url.dart';

// Extensions to lemmy api objects which give a [.instanceUrl] getter
// allowing for a convenient way of knowing from which instance did this
// object come from

// TODO: change it to something more robust? regex?

extension GetInstanceCommunityView on CommunityView {
  String get instanceUrl => extract(actorId);
}

extension GetInstanceUserView on UserView {
  String get instanceUrl => extract(actorId);
}

extension GetInstanceCommunityModeratorView on CommunityModeratorView {
  String get instanceUrl => extract(userActorId);
}

extension GetInstancePostView on PostView {
  String get instanceUrl => extract(apId);
}

extension GetInstanceUser on User {
  String get instanceUrl => extract(actorId);
}

extension GetInstanceCommentView on CommentView {
  String get instanceUrl => extract(apId);
}

String extract(String s) => cleanUpUrl(s.split('/')[2]);

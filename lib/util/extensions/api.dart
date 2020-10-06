import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../cleanup_url.dart';

// Extensions to lemmy api objects which give a [.instanceUrl] getter
// allowing for a convenient way of knowing from which instance did this
// object come from

// TODO: change it to something more robust? regex?

extension GetInstanceCommunityView on CommunityView {
  String get instanceUrl => _extract(actorId);
}

extension GetInstanceUserView on UserView {
  String get instanceUrl => _extract(actorId);
}

extension GetInstanceCommunityModeratorView on CommunityModeratorView {
  String get instanceUrl => _extract(userActorId);
}

extension GetInstancePostView on PostView {
  String get instanceUrl => _extract(apId);
}

extension GetInstanceUser on User {
  String get instanceUrl => _extract(actorId);
}

extension GetInstanceCommentView on CommentView {
  String get instanceUrl => _extract(apId);
}

String _extract(String s) => cleanUpUrl(s.split('/')[2]);

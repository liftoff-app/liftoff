import 'package:lemmy_api_client/lemmy_api_client.dart';

// Extensions to lemmy api objects which give a [.instanceUrl] getter
// allowing for a convenient way of knowing from which instance did this
// object come from

// TODO: change it to something more robust? regex?

extension GetInstanceCommunityView on CommunityView {
  String get instanceUrl => actorId.split('/')[2];
}

extension GetInstanceUserView on UserView {
  String get instanceUrl => actorId.split('/')[2];
}

extension GetInstanceCommunityModeratorView on CommunityModeratorView {
  String get instanceUrl => userActorId.split('/')[2];
}

extension GetInstancePostView on PostView {
  String get instanceUrl => apId.split('/')[2];
}

extension GetInstanceUser on User {
  String get instanceUrl => actorId.split('/')[2];
}

extension GetInstanceCommentView on CommentView {
  String get instanceUrl => apId.split('/')[2];
}

import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../cleanup_url.dart';

// Extensions to lemmy api objects which give a [.originInstanceHost] getter
// allowing for a convenient way of knowing what is the origin of the object
// For example if a post on lemmy.ml is federated from lemmygrad.ml then
// `post.instanceHost == 'lemmy.ml'
// && post.originInstanceHost == 'lemmygrad.ml``

extension GetInstanceCommunityView on CommunityView {
  String get originInstanceHost => _extract(actorId);
}

extension GetInstanceUserView on UserView {
  String get originInstanceHost => _extract(actorId);
}

extension GetInstanceCommunityModeratorView on CommunityModeratorView {
  String get originInstanceHost => _extract(userActorId);
}

extension GetInstancePostView on PostView {
  String get originInstanceHost => _extract(apId);
}

extension GetInstanceUser on User {
  String get originInstanceHost => _extract(actorId);
}

extension GetInstanceCommentView on CommentView {
  String get originInstanceHost => _extract(apId);
}

// TODO: change it to something more robust? regex?
String _extract(String s) => cleanUpUrl(s.split('/')[2]);

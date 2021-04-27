import 'package:lemmy_api_client/v3.dart';

import '../cleanup_url.dart';

// Extensions to lemmy api objects which give a [.originInstanceHost] getter
// allowing for a convenient way of knowing what is the origin of the object
// For example if a post on lemmy.ml is federated from lemmygrad.ml then
// `post.instanceHost == 'lemmy.ml'
// && post.originInstanceHost == 'lemmygrad.ml``

extension GetOriginInstanceCommunitySafe on CommunitySafe {
  String get originInstanceHost => _extract(actorId);
}

extension GetOriginInstancePersonSafe on PersonSafe {
  String get originInstanceHost => _extract(actorId);
}

extension GetOriginInstancePostView on Post {
  String get originInstanceHost => _extract(apId);
}

extension GetOriginInstanceCommentView on Comment {
  String get originInstanceHost => _extract(apId);
}

String _extract(String url) => urlHost(url);

extension CommunityPresentNames on CommunitySafe {
  String get presentName => '!$name';
  String get originPresentName =>
      local ? presentName : '!$name@$originInstanceHost';
}

extension UserPresentNames on PersonSafe {
  String get presentName {
    final dispName = displayName;
    if (dispName != null && dispName.isNotEmpty) {
      return dispName;
    }

    return '@$name';
  }

  String get originPresentName {
    if (!local) return '$presentName@$originInstanceHost';

    return presentName;
  }
}

extension CommentLink on Comment {
  String get link => 'https://$instanceHost/post/$postId/comment/$id';
}

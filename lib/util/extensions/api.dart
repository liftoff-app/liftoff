import 'package:lemmy_api_client/v2.dart';

import '../cleanup_url.dart';

// Extensions to lemmy api objects which give a [.originInstanceHost] getter
// allowing for a convenient way of knowing what is the origin of the object
// For example if a post on lemmy.ml is federated from lemmygrad.ml then
// `post.instanceHost == 'lemmy.ml'
// && post.originInstanceHost == 'lemmygrad.ml``

extension GetOriginInstanceCommunitySafe on CommunitySafe {
  String get originInstanceHost => _extract(actorId);
}

extension GetOriginInstanceUserSafe on UserSafe {
  String get originInstanceHost => _extract(actorId);
}

extension GetOriginInstancePostView on Post {
  String get originInstanceHost => _extract(apId);
}

extension GetOriginInstanceCommentView on Comment {
  String get originInstanceHost => _extract(apId);
}

String _extract(String url) => urlHost(url);

extension CommunityDisplayNames on CommunitySafe {
  String get displayName => '!$name';
  String get originDisplayName =>
      local ? displayName : '!$name@$originInstanceHost';
}

extension UserDisplayNames on UserSafe {
  String get displayName {
    if (preferredUsername != null && preferredUsername.isNotEmpty) {
      return preferredUsername;
    }

    return '@$name';
  }

  String get originDisplayName {
    if (!local) return '$displayName@$originInstanceHost';

    return displayName;
  }
}

extension CommentLink on Comment {
  String get link => 'https://$instanceHost/post/$postId/comment/$id';
}

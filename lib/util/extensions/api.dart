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

extension DisplayName on UserSafe {
  String get displayName {
    final name = () {
      if (preferredUsername != null && preferredUsername != '') {
        return preferredUsername;
      } else {
        return '@${this.name}';
      }
    }();

    if (!local) return '$name@$originInstanceHost';

    return name;
  }
}

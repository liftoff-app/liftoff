import 'package:lemmy_api_client/v2.dart';

import '../cleanup_url.dart';

// Extensions to lemmy api objects which give a [.originInstanceHost] getter
// allowing for a convenient way of knowing what is the origin of the object
// For example if a post on lemmy.ml is federated from lemmygrad.ml then
// `post.instanceHost == 'lemmy.ml'
// && post.originInstanceHost == 'lemmygrad.ml``

// [.isLocal] is true iff `.originInstanceHost == .instanceHost`

extension GetInstanceCommunitySafe on CommunitySafe {
  String get originInstanceHost => _extract(actorId);
  // bool get isLocal => originInstanceHost == instanceHost;
}

extension GetInstanceUserSafe on UserSafe {
  String get originInstanceHost => _extract(actorId);
  // bool get isLocal => originInstanceHost == instanceHost;
}

extension GetInstancePostView on Post {
  String get originInstanceHost => _extract(apId);
  // bool get isLocal => originInstanceHost == instanceHost;
}

extension GetInstanceCommentView on Comment {
  String get originInstanceHost => _extract(apId);
  // bool get isLocal => originInstanceHost == instanceHost;
}

// TODO: change it to something more robust? regex?
String _extract(String s) => cleanUpUrl(s.split('/')[2]);

extension ProperName on UserSafe {
  String get properName {
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

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

extension CommunityPreferredNames on CommunitySafe {
  String get preferredName => '!$name';
  String get originPreferredName =>
      local ? preferredName : '!$name@$originInstanceHost';
}

extension UserPreferredNames on PersonSafe {
  String get preferredName {
    final dispName = displayName;
    if (dispName != null && dispName.isNotEmpty) {
      return dispName;
    }

    return '@$name';
  }

  String get originPreferredName {
    if (!local) return '$preferredName@$originInstanceHost';

    return preferredName;
  }
}

extension CommentLink on Comment {
  String get link => 'https://$instanceHost/post/$postId/comment/$id';
}

// inspired by https://github.com/LemmyNet/lemmy-ui/blob/66c846ededef8c0afd5aaadca4aaedcbaeab3ee6/src/shared/utils.ts#L533
extension PersonSafeCakeDay on PersonSafe {
  bool get isCakeDay {
    final now = DateTime.now().toUtc();

    return now.day == published.day &&
        now.month == published.month &&
        now.year != published.year;
  }
}

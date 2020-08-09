import 'package:flutter/foundation.dart';

export 'comment_endpoint.dart';
export 'post_endpoint.dart';
export 'user_endpoint.dart';

class V1 {
  String instanceUrl;

  V1(this.instanceUrl);

  /// GET /categories
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#list-categories
  String listCategories() {
    throw UnimplementedError();
  }

  /// POST /search
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#search
  String search({
    @required String q,
    @required String type,
    String communityId,
    @required String sort,
    int page,
    int limit,
    String auth,
  }) {
    throw UnimplementedError();
  }
}

enum Vote {
  up,
  none,
  down,
}

extension VoteValue on Vote {
  int get value {
    switch (this) {
      case Vote.up:
        return 1;
      case Vote.none:
        return 0;
      case Vote.down:
        return -1;
    }
    throw Exception("unreachable");
  }
}

class Captcha {
  final String png;

  /// can be null
  final String wav;
  final String uuid;
  Captcha({this.png, this.wav, this.uuid});
}

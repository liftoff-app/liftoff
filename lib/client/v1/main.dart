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

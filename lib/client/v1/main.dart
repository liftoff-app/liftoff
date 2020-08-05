import 'package:flutter/foundation.dart';
import 'post_endpoint.dart';
import 'user_endpoint.dart';

class V1 {
  String instanceUrl;

  UserEndpoint user;
  PostEndpoint post;

  V1(this.instanceUrl)
      : user = UserEndpoint(instanceUrl),
        post = PostEndpoint(instanceUrl);

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

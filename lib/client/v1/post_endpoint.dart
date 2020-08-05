import 'package:flutter/foundation.dart';

class PostEndpoint {
  String instanceUrl;
  PostEndpoint(this.instanceUrl);

  /// POST /post
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#post
  String create({
    @required String name,
    String url,
    String body,
    @required bool nsfw,
    @required int communityId,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /post
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-post
  String get({
    @required int id,
    String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /post/list
  ///
  String getList({
    @required String type,
    @required String sort,
    int page,
    int limit,
    int communityId,
    String communityName,
  }) {
    throw UnimplementedError();
  }

  /// POST /post/like
  ///
  String vote({
    @required int postId,
    @required int score,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// PUT /post
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#edit-post
  String update({
    @required int editId,
    @required String name,
    String url,
    String body,
    @required bool nsfw,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /post/delete
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#delete-post
  /// delete a post in a user deleting their own kind of way
  String delete({
    @required int editId,
    @required bool deleted,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /post/remove
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#remove-post
  /// remove post in an admin kind of way
  String remove({
    @required int editId,
    @required bool removed,
    String reason,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /post/save
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#save-post
  String save({
    @required int postId,
    @required bool save,
    @required String auth,
  }) {
    throw UnimplementedError();
  }
}

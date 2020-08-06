import 'package:flutter/foundation.dart';

import 'main.dart';

extension PostEndpoint on V1 {
  /// POST /post
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#post
  String createPost({
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
  String getPost({
    @required int id,
    String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /post/list
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-posts
  String getPosts({
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
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#create-post-like
  String createPostLike({
    @required int postId,
    @required int score,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// PUT /post
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#edit-post
  String editPost({
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
  String deletePost({
    @required int editId,
    @required bool deleted,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /post/remove
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#remove-post
  /// remove post in an admin kind of way
  String removePost({
    @required int editId,
    @required bool removed,
    String reason,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /post/save
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#save-post
  String savePost({
    @required int postId,
    @required bool save,
    @required String auth,
  }) {
    throw UnimplementedError();
  }
}

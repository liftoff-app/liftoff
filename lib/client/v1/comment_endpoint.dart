import 'package:flutter/foundation.dart';

class CommentEndpoint {
  String instanceUrl;
  CommentEndpoint(this.instanceUrl);

  /// POST /comment
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#create-comment
  String create({
    @required String content,
    int parentId,
    @required int postId,
    int formId,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// PUT /comment
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#edit-comment
  String edit({
    @required String content,
    @required int editId,
    String formId,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /comment/delete
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#delete-comment
  /// Only the creator can delete the comment
  String delete({
    @required int editId,
    @required bool deleted,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /comment/remove
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#remove-comment
  /// Only a mod or admin can remove the comment
  String remove({
    @required int editId,
    @required bool removed,
    String reason,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /comment/mark_as_read
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#mark-comment-as-read
  String markAsRead({
    @required int editId,
    @required bool read,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /comment/save
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#save-comment
  String save({
    @required int commentId,
    @required bool save,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /comment/like
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#create-comment-like
  String vote({
    @required int commentId,
    @required int score,
    @required String auth,
  }) {
    throw UnimplementedError();
  }
}

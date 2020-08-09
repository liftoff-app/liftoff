import 'package:flutter/foundation.dart';
import 'package:lemmur/client/models/captcha.dart';
import '../models/private_message.dart';

import 'main.dart';

extension UserEndpoint on V1 {
  /// POST /user/login
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#login
  String login({
    String usernameOrEmail,
    String password,
  }) {
    assert(usernameOrEmail != null, password != null);
    throw UnimplementedError();
  }

  /// POST /user/register
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#register
  String register({
    @required String username,
    String email,
    String password,
  }) {
    throw UnimplementedError();
  }

  /// GET /user/get_captcha
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-captcha
  Future<Captcha> getCaptcha() {
    throw UnimplementedError();
  }

  /// GET /user
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-user-details
  String getUserDetails({
    int userId,
    String username,
    @required String sort,
    int page,
    int limit,
    int communityId,
    bool savedOnly,
    String auth,
  }) {
    throw UnimplementedError();
  }

  /// PUT /save_user_settings
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#save-user-settings
  String saveUserSettings({
    @required bool showNsfw,
    @required String theme,
    @required int defaultSortType,
    @required int defaultListingType,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /user/replies
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-replies--inbox
  String getReplies({
    @required String sort,
    int page,
    int limit,
    @required bool unreadOnly,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /user/mentions
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-user-mentions
  String getUserMentions({
    String sort,
    @required int page,
    @required int limit,
    bool unreadOnly,
    String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /user/mention/mark_as_read
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#mark-user-mention-as-read
  String markUserMentionAsRead({
    @required int userMentionId,
    @required bool read,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /private_message/list
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-private-messages
  Future<List<PrivateMessageView>> getPrivateMessages({
    @required bool unreadOnly,
    int page,
    int limit,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /private_message
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#create-private-message
  Future<PrivateMessageView> createPrivateMessage({
    @required String content,
    @required int recipientId,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// PUT /private_message
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#edit-private-message
  Future<PrivateMessageView> editPrivateMessage({
    @required int editId,
    @required String content,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /private_message/delete
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#delete-private-message
  Future<PrivateMessageView> deletePrivateMessage({
    @required int editId,
    @required bool deleted,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /private_message/mark_as_read
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#mark-private-message-as-read
  Future<PrivateMessageView> markPrivateMessageAsRead({
    @required int editId,
    @required bool read,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /user/mark_all_as_read
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#mark-all-as-read
  String markAllAsRead({
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /user/delete_account
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#delete-account
  String deleteAccount({
    @required String password,
    @required String auth,
  }) {
    throw UnimplementedError();
  }
}

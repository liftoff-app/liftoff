import 'package:flutter/material.dart';

class LemmyAPI {
  /// url of this lemmy instance
  String instanceUrl;

  V1 v1;

  /// initialize lemmy api instance
  LemmyAPI({@required this.instanceUrl})
      : assert(instanceUrl != null),
        v1 = V1(instanceUrl);
}

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

class UserEndpoint {
  String instanceUrl;
  UserEndpoint(this.instanceUrl);

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
  String getCaptcha() {
    throw UnimplementedError();
  }

  /// GET /user
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-user-details
  String getDetails({
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
  String updateSettings({
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
  String getMentions({
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
  String markMentionsAsRead({
    @required int userMentionId,
    @required bool read,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// GET /private_message/list
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-private-messages
  String getPrivateMessages({
    @required bool unreadOnly,
    int page,
    int limit,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /private_message
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#create-private-message
  String createPrivateMessage({
    @required String content,
    @required int recipientId,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// PUT /private_message
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#edit-private-message
  String updatePrivateMessage({
    @required int editId,
    @required String content,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /private_message/delete
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#delete-private-message
  String deletePrivateMessage({
    @required int editId,
    @required bool deleted,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /private_message/mark_as_read
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#mark-private-message-as-read
  String markPrivateMessageAsRead({
    @required int editId,
    @required bool read,
    @required String auth,
  }) {
    throw UnimplementedError();
  }

  /// POST /user/mark_all_as_read
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#mark-all-as-read
  String markAllPrivateMessagesAsRead({
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

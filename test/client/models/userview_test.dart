import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lemmur/client/models/user.dart';

void main() {
  test('UserView test', () {
    Map<String, dynamic> userJson = jsonDecode('''
      {
        "id": 13709,
        "actor_id": "https://dev.lemmy.ml/u/krawieck",
        "name": "krawieck",
        "preferred_username": null,
        "avatar": null,
        "banner": null,
        "email": null,
        "matrix_user_id": null,
        "bio": null,
        "local": true,
        "admin": false,
        "banned": false,
        "show_avatars": true,
        "send_notifications_to_email": false,
        "published": "2020-08-03T12:22:12.389085",
        "number_of_posts": 0,
        "post_score": 0,
        "number_of_comments": 0,
        "comment_score": 0
      }''');

    var user = UserView.fromJson(userJson);

    expect(user.id, 13709);
    expect(user.actorId, 'https://dev.lemmy.ml/u/krawieck');
    expect(user.name, 'krawieck');
    expect(user.preferredUsername, null);
    expect(user.avatar, null);
    expect(user.banner, null);
    expect(user.email, null);
    expect(user.matrixUserId, null);
    expect(user.bio, null);
    expect(user.local, true);
    expect(user.admin, false);
    expect(user.banned, false);
    expect(user.showAvatars, true);
    expect(user.sendNotificationsToEmail, false);
    expect(user.published, DateTime.parse('2020-08-03T12:22:12.389085'));
    expect(user.numberOfPosts, 0);
    expect(user.postScore, 0);
    expect(user.numberOfComments, 0);
    expect(user.commentScore, 0);
  });
}

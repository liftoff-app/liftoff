// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserView _$UserViewFromJson(Map<String, dynamic> json) {
  return UserView(
    id: json['id'] as int,
    actorId: json['actor_id'] as String,
    name: json['name'] as String,
    preferredUsername: json['preferred_username'] as String,
    avatar: json['avatar'] as String,
    banner: json['banner'] as String,
    email: json['email'] as String,
    matrixUserId: json['matrix_user_id'] as String,
    bio: json['bio'] as String,
    local: json['local'] as bool,
    admin: json['admin'] as bool,
    banned: json['banned'] as bool,
    showAvatars: json['show_avatars'] as bool,
    sendNotificationsToEmail: json['send_notifications_to_email'] as bool,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    numberOfPosts: json['number_of_posts'] as int,
    postScore: json['post_score'] as int,
    numberOfComments: json['number_of_comments'] as int,
    commentScore: json['comment_score'] as int,
  );
}

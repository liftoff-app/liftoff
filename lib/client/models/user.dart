import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/user_view.rs#L58
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UserView {
  final int id;
  final String actorId;
  final String name;
  /// can be null
  final String preferredUsername;
  /// can be null
  final String avatar;
  /// can be null
  final String banner;
  /// can be null
  final String email;
  /// can be null
  final String matrixUserId;
  /// can be null
  final String bio;
  final bool local;
  final bool admin;
  final bool banned;
  final bool showAvatars;
  final bool sendNotificationsToEmail;
  final DateTime published;
  final int numberOfPosts;
  final int postScore;
  final int numberOfComments;
  final int commentScore;

  factory UserView.fromJson(Map<String, dynamic> json) =>
      _$UserViewFromJson(json);
}

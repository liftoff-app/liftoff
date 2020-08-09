import 'package:json_annotation/json_annotation.dart';

part 'private_message.g.dart';

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/private_message_view.rs#L35
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PrivateMessageView {
  final int id;
  final int creatorId;
  final int recipientId;
  final String content;
  final bool deleted;
  final bool read;
  final DateTime published;
  /// can be null
  final DateTime updated;
  final String apId;
  final bool local;
  final String creatorName;
  /// can be null
  final String creatorPreferredUsername;
  /// can be null
  final String creatorAvatar;
  final String creatorActorId;
  final bool creatorLocal;
  final String recipientName;
  /// can be null
  final String recipientPreferredUsername;
  /// can be null
  final String recipientAvatar;
  final String recipientActorId;
  final bool recipientLocal;

  const PrivateMessageView({
    this.id,
    this.creatorId,
    this.recipientId,
    this.content,
    this.deleted,
    this.read,
    this.published,
    this.updated,
    this.apId,
    this.local,
    this.creatorName,
    this.creatorPreferredUsername,
    this.creatorAvatar,
    this.creatorActorId,
    this.creatorLocal,
    this.recipientName,
    this.recipientPreferredUsername,
    this.recipientAvatar,
    this.recipientActorId,
    this.recipientLocal,
  });

  factory PrivateMessageView.fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageViewFromJson(json);
}

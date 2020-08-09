// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'private_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivateMessageView _$PrivateMessageViewFromJson(Map<String, dynamic> json) {
  return PrivateMessageView(
    id: json['id'] as int,
    creatorId: json['creator_id'] as int,
    recipientId: json['recipient_id'] as int,
    content: json['content'] as String,
    deleted: json['deleted'] as bool,
    read: json['read'] as bool,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    apId: json['ap_id'] as String,
    local: json['local'] as bool,
    creatorName: json['creator_name'] as String,
    creatorPreferredUsername: json['creator_preferred_username'] as String,
    creatorAvatar: json['creator_avatar'] as String,
    creatorActorId: json['creator_actor_id'] as String,
    creatorLocal: json['creator_local'] as bool,
    recipientName: json['recipient_name'] as String,
    recipientPreferredUsername: json['recipient_preferred_username'] as String,
    recipientAvatar: json['recipient_avatar'] as String,
    recipientActorId: json['recipient_actor_id'] as String,
    recipientLocal: json['recipient_local'] as bool,
  );
}

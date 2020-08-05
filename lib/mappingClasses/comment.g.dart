// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentView _$CommentViewFromJson(Map<String, dynamic> json) {
  return CommentView(
    json['id'] as int,
    json['creator_id'] as int,
    json['post_id'] as int,
    json['post_name'] as String,
    json['parent_id'] as int,
    json['content'] as String,
    json['removed'] as bool,
    json['read'] as bool,
    UtilityClass.ParseDateFromJson(json['published']),
    UtilityClass.ParseDateFromJson(json['updated']),
    json['deleted'] as bool,
    json['ap_id'] as String,
    json['local'] as bool,
    json['community_id'] as int,
    json['community_actor_id'] as String,
    json['community_local'] as bool,
    json['community_name'] as String,
    json['banned'] as bool,
    json['banned_from_community'] as bool,
    json['creator_actor_id'] as String,
    json['creator_local'] as bool,
    json['creator_name'] as String,
    UtilityClass.ParseDateFromJson(json['creator_published']),
    json['creator_avatar'] as String,
    json['score'] as int,
    json['upvotes'] as int,
    json['downvotes'] as int,
    json['hot_rank'] as int,
    json['userId'] as int,
    json['myVote'] as int,
    json['subscribed'] as bool,
    json['saved'] as bool,
  );
}

Map<String, dynamic> _$CommentViewToJson(CommentView instance) =>
    <String, dynamic>{
      'id': instance.id,
      'creator_id': instance.creatorId,
      'post_id': instance.postId,
      'post_name': instance.postName,
      'parent_id': instance.parentId,
      'content': instance.content,
      'removed': instance.removed,
      'read': instance.read,
      'published': instance.published?.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
      'deleted': instance.deleted,
      'ap_id': instance.apId,
      'local': instance.local,
      'community_id': instance.communityId,
      'community_actor_id': instance.communityActorId,
      'community_local': instance.communityLocal,
      'community_name': instance.communityName,
      'banned': instance.banned,
      'banned_from_community': instance.bannedFromCommunity,
      'creator_actor_id': instance.creatorActorId,
      'creator_local': instance.creatorLocal,
      'creator_name': instance.creatorName,
      'creator_published': instance.creatorPublished?.toIso8601String(),
      'creator_avatar': instance.creatorAvatar,
      'score': instance.score,
      'upvotes': instance.upvotes,
      'downvotes': instance.downvotes,
      'hot_rank': instance.hotRank,
      'userId': instance.userId,
      'myVote': instance.myVote,
      'subscribed': instance.subscribed,
      'saved': instance.saved,
    };

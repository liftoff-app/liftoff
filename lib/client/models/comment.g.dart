// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentView _$CommentViewFromJson(Map<String, dynamic> json) {
  return CommentView(
    id: json['id'] as int,
    creatorId: json['creator_id'] as int,
    postId: json['post_id'] as int,
    postName: json['post_name'] as String,
    parentId: json['parent_id'] as int,
    content: json['content'] as String,
    removed: json['removed'] as bool,
    read: json['read'] as bool,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    deleted: json['deleted'] as bool,
    apId: json['ap_id'] as String,
    local: json['local'] as bool,
    communityId: json['community_id'] as int,
    communityActorId: json['community_actor_id'] as String,
    communityLocal: json['community_local'] as bool,
    communityName: json['community_name'] as String,
    communityIcon: json['community_icon'] as String,
    banned: json['banned'] as bool,
    bannedFromCommunity: json['banned_from_community'] as bool,
    creatorActorId: json['creator_actor_id'] as String,
    creatorLocal: json['creator_local'] as bool,
    creatorName: json['creator_name'] as String,
    creatorPreferredUsername: json['creator_preferred_username'] as String,
    creatorPublished: json['creator_published'] == null
        ? null
        : DateTime.parse(json['creator_published'] as String),
    creatorAvatar: json['creator_avatar'] as String,
    score: json['score'] as int,
    upvotes: json['upvotes'] as int,
    downvotes: json['downvotes'] as int,
    hotRank: json['hot_rank'] as int,
    hotRankActive: json['hot_rank_active'] as int,
    userId: json['user_id'] as int,
    myVote: json['my_vote'] as int,
    subscribed: json['subscribed'] as bool,
    saved: json['saved'] as bool,
  );
}

ReplyView _$ReplyViewFromJson(Map<String, dynamic> json) {
  return ReplyView(
    id: json['id'] as int,
    creatorId: json['creator_id'] as int,
    postId: json['post_id'] as int,
    postName: json['post_name'] as String,
    parentId: json['parent_id'] as int,
    content: json['content'] as String,
    removed: json['removed'] as bool,
    read: json['read'] as bool,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    deleted: json['deleted'] as bool,
    apId: json['ap_id'] as String,
    local: json['local'] as bool,
    communityId: json['community_id'] as int,
    communityActorId: json['community_actor_id'] as String,
    communityLocal: json['community_local'] as bool,
    communityName: json['community_name'] as String,
    communityIcon: json['community_icon'] as String,
    banned: json['banned'] as bool,
    bannedFromCommunity: json['banned_from_community'] as bool,
    creatorActorId: json['creator_actor_id'] as String,
    creatorLocal: json['creator_local'] as bool,
    creatorName: json['creator_name'] as String,
    creatorPreferredUsername: json['creator_preferred_username'] as String,
    creatorAvatar: json['creator_avatar'] as String,
    creatorPublished: json['creator_published'] == null
        ? null
        : DateTime.parse(json['creator_published'] as String),
    score: json['score'] as int,
    upvotes: json['upvotes'] as int,
    downvotes: json['downvotes'] as int,
    hotRank: json['hot_rank'] as int,
    hotRankActive: json['hot_rank_active'] as int,
    userId: json['user_id'] as int,
    myVote: json['my_vote'] as int,
    subscribed: json['subscribed'] as bool,
    saved: json['saved'] as bool,
    recipientId: json['recipient_id'] as int,
  );
}

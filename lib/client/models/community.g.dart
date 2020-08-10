// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityView _$CommunityViewFromJson(Map<String, dynamic> json) {
  return CommunityView(
    id: json['id'] as int,
    name: json['name'] as String,
    title: json['title'] as String,
    icon: json['icon'] as String,
    banner: json['banner'] as String,
    description: json['description'] as String,
    categoryId: json['category_id'] as int,
    creatorId: json['creator_id'] as int,
    removed: json['removed'] as bool,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    updated: json['updated'] == null
        ? null
        : DateTime.parse(json['updated'] as String),
    deleted: json['deleted'] as bool,
    nsfw: json['nsfw'] as bool,
    actorId: json['actor_id'] as String,
    local: json['local'] as bool,
    lastRefreshedAt: json['last_refreshed_at'] == null
        ? null
        : DateTime.parse(json['last_refreshed_at'] as String),
    creatorActorId: json['creator_actor_id'] as String,
    creatorLocal: json['creator_local'] as bool,
    creatorName: json['creator_name'] as String,
    creatorPreferredUsername: json['creator_preferred_username'] as String,
    creatorAvatar: json['creator_avatar'] as String,
    categoryName: json['category_name'] as String,
    numberOfSubscribers: json['number_of_subscribers'] as int,
    numberOfPosts: json['number_of_posts'] as int,
    numberOfComments: json['number_of_comments'] as int,
    hotRank: json['hot_rank'] as int,
    userId: json['user_id'] as int,
    subscribed: json['subscribed'] as bool,
  );
}

CommunityFollowerView _$CommunityFollowerViewFromJson(
    Map<String, dynamic> json) {
  return CommunityFollowerView(
    id: json['id'] as int,
    communityId: json['community_id'] as int,
    userId: json['user_id'] as int,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    userActorId: json['user_actor_id'] as String,
    userLocal: json['user_local'] as bool,
    userName: json['user_name'] as String,
    userPreferredUsername: json['user_preferred_username'] as String,
    avatar: json['avatar'] as String,
    communityActorId: json['community_actor_id'] as String,
    communityLocal: json['community_local'] as bool,
    communityName: json['community_name'] as String,
    communityIcon: json['community_icon'] as String,
  );
}

CommunityModeratorView _$CommunityModeratorViewFromJson(
    Map<String, dynamic> json) {
  return CommunityModeratorView(
    id: json['id'] as int,
    communityId: json['community_id'] as int,
    userId: json['user_id'] as int,
    published: json['published'] == null
        ? null
        : DateTime.parse(json['published'] as String),
    userActorId: json['user_actor_id'] as String,
    userLocal: json['user_local'] as bool,
    userName: json['user_name'] as String,
    userPreferredUsername: json['user_preferred_username'] as String,
    avatar: json['avatar'] as String,
    communityActorId: json['community_actor_id'] as String,
    communityLocal: json['community_local'] as bool,
    communityName: json['community_name'] as String,
    communityIcon: json['community_icon'] as String,
  );
}

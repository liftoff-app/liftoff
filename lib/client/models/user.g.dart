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

UserMentionView _$UserMentionViewFromJson(Map<String, dynamic> json) {
  return UserMentionView(
    id: json['id'] as int,
    userMentionId: json['user_mention_id'] as int,
    creatorId: json['creator_id'] as int,
    creatorActorId: json['creator_actor_id'] as String,
    creatorLocal: json['creator_local'] as bool,
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
    communityId: json['community_id'] as int,
    communityActorId: json['community_actor_id'] as String,
    communityLocal: json['community_local'] as bool,
    communityName: json['community_name'] as String,
    communityIcon: json['community_icon'] as String,
    banned: json['banned'] as bool,
    bannedFromCommunity: json['banned_from_community'] as bool,
    creatorName: json['creator_name'] as String,
    creatorPreferredUsername: json['creator_preferred_username'] as String,
    creatorAvatar: json['creator_avatar'] as String,
    score: json['score'] as int,
    upvotes: json['upvotes'] as int,
    downvotes: json['downvotes'] as int,
    hotRank: json['hot_rank'] as int,
    hotRankActive: json['hot_rank_active'] as int,
    userId: json['user_id'] as int,
    myVote: json['my_vote'] as int,
    saved: json['saved'] as bool,
    recipientId: json['recipient_id'] as int,
    recipientActorId: json['recipient_actor_id'] as String,
    recipientLocal: json['recipient_local'] as bool,
  );
}

UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) {
  return UserDetails(
    user: json['user'] == null
        ? null
        : UserView.fromJson(json['user'] as Map<String, dynamic>),
    follows: (json['follows'] as List)
        ?.map((e) => e == null
            ? null
            : CommunityFollowerView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    moderates: (json['moderates'] as List)
        ?.map((e) => e == null
            ? null
            : CommunityModeratorView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    comments: (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : CommentView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    posts: (json['posts'] as List)
        ?.map((e) =>
            e == null ? null : PostView.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

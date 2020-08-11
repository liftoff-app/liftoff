import 'package:json_annotation/json_annotation.dart';

import './comment.dart';
import './community.dart';
import './post.dart';

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

  const UserView({
    this.id,
    this.actorId,
    this.name,
    this.preferredUsername,
    this.avatar,
    this.banner,
    this.email,
    this.matrixUserId,
    this.bio,
    this.local,
    this.admin,
    this.banned,
    this.showAvatars,
    this.sendNotificationsToEmail,
    this.published,
    this.numberOfPosts,
    this.postScore,
    this.numberOfComments,
    this.commentScore,
  });

  factory UserView.fromJson(Map<String, dynamic> json) =>
      _$UserViewFromJson(json);
}

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/user_mention_view.rs#L90
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class UserMentionView {
  final int id;
  final int userMentionId;
  final int creatorId;
  final String creatorActorId;
  final bool creatorLocal;
  final int postId;
  final String postName;

  /// can be null
  final int parentId;
  final String content;
  final bool removed;
  final bool read;
  final DateTime published;

  /// can be null
  final DateTime updated;
  final bool deleted;
  final int communityId;
  final String communityActorId;
  final bool communityLocal;
  final String communityName;

  /// can be null
  final String communityIcon;
  final bool banned;
  final bool bannedFromCommunity;
  final String creatorName;

  /// can be null
  final String creatorPreferredUsername;

  /// can be null
  final String creatorAvatar;
  final int score;
  final int upvotes;
  final int downvotes;
  final int hotRank;
  final int hotRankActive;

  /// can be null
  final int userId;

  /// can be null
  final int myVote;

  /// can be null
  final bool saved;
  final int recipientId;
  final String recipientActorId;
  final bool recipientLocal;

  const UserMentionView({
    this.id,
    this.userMentionId,
    this.creatorId,
    this.creatorActorId,
    this.creatorLocal,
    this.postId,
    this.postName,
    this.parentId,
    this.content,
    this.removed,
    this.read,
    this.published,
    this.updated,
    this.deleted,
    this.communityId,
    this.communityActorId,
    this.communityLocal,
    this.communityName,
    this.communityIcon,
    this.banned,
    this.bannedFromCommunity,
    this.creatorName,
    this.creatorPreferredUsername,
    this.creatorAvatar,
    this.score,
    this.upvotes,
    this.downvotes,
    this.hotRank,
    this.hotRankActive,
    this.userId,
    this.myVote,
    this.saved,
    this.recipientId,
    this.recipientActorId,
    this.recipientLocal,
  });

  factory UserMentionView.fromJson(Map<String, dynamic> json) =>
      _$UserMentionViewFromJson(json);
}

/// based on https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-user-details
@JsonSerializable(createToJson: false)
class UserDetails {
  final UserView user;
  final List<CommunityFollowerView> follows;
  final List<CommunityModeratorView> moderates;
  final List<CommentView> comments;
  final List<PostView> posts;

  const UserDetails({
    this.user,
    this.follows,
    this.moderates,
    this.comments,
    this.posts,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) =>
      _$UserDetailsFromJson(json);
}

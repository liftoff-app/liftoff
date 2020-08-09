import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/comment_view.rs#L91
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CommentView {
  final int id;
  final int creatorId;
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
  final String apId;
  final bool local;
  final int communityId;
  final String communityActorId;
  final bool communityLocal;
  final String communityName;

  /// can be null
  final String communityIcon;
  final bool banned;
  final bool bannedFromCommunity;
  final String creatorActorId;
  final bool creatorLocal;
  final String creatorName;

  /// can be null
  final String creatorPreferredUsername;
  final DateTime creatorPublished;

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
  final bool subscribed;

  /// can be null
  final bool saved;

  const CommentView({
    this.id,
    this.creatorId,
    this.postId,
    this.postName,
    this.parentId,
    this.content,
    this.removed,
    this.read,
    this.published,
    this.updated,
    this.deleted,
    this.apId,
    this.local,
    this.communityId,
    this.communityActorId,
    this.communityLocal,
    this.communityName,
    this.communityIcon,
    this.banned,
    this.bannedFromCommunity,
    this.creatorActorId,
    this.creatorLocal,
    this.creatorName,
    this.creatorPreferredUsername,
    this.creatorPublished,
    this.creatorAvatar,
    this.score,
    this.upvotes,
    this.downvotes,
    this.hotRank,
    this.hotRankActive,
    this.userId,
    this.myVote,
    this.subscribed,
    this.saved,
  });

  factory CommentView.fromJson(Map<String, dynamic> json) =>
      _$CommentViewFromJson(json);
}

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/comment_view.rs#L356
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ReplyView {
  final int id;
  final int creatorId;
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
  final String apId;
  final bool local;
  final int communityId;
  final String communityActorId;
  final bool communityLocal;
  final String communityName;
  /// can be null
  final String communityIcon;
  final bool banned;
  final bool bannedFromCommunity;
  final String creatorActorId;
  final bool creatorLocal;
  final String creatorName;
  /// can be null
  final String creatorPreferredUsername;
  /// can be null
  final String creatorAvatar;
  final DateTime creatorPublished;
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
  final bool subscribed;
  /// can be null
  final bool saved;
  final int recipientId;

  const ReplyView({
    this.id,
    this.creatorId,
    this.postId,
    this.postName,
    this.parentId,
    this.content,
    this.removed,
    this.read,
    this.published,
    this.updated,
    this.deleted,
    this.apId,
    this.local,
    this.communityId,
    this.communityActorId,
    this.communityLocal,
    this.communityName,
    this.communityIcon,
    this.banned,
    this.bannedFromCommunity,
    this.creatorActorId,
    this.creatorLocal,
    this.creatorName,
    this.creatorPreferredUsername,
    this.creatorAvatar,
    this.creatorPublished,
    this.score,
    this.upvotes,
    this.downvotes,
    this.hotRank,
    this.hotRankActive,
    this.userId,
    this.myVote,
    this.subscribed,
    this.saved,
    this.recipientId,
  });

  factory ReplyView.fromJson(Map<String, dynamic> json) =>
      _$ReplyViewFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/post_view.rs#L113
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PostView {
  final int id;
  final String name;
  /// can be null
  final String url;
  /// can be null
  final String body;
  final int creatorId;
  final int communityId;
  final bool removed;
  final bool locked;
  final DateTime published;
  /// can be null
  @JsonKey(fromJson: DateTime.tryParse)
  final DateTime updated;
  final bool deleted;
  final bool nsfw;
  final bool stickied;
  /// can be null
  final String embedTitle;
  /// can be null
  final String embedDescription;
  /// can be null
  final String embedHtml;
  /// can be null
  final String thumbnailUrl;
  final String apId;
  final bool local;
  final String creatorActorId;
  final bool creatorLocal;
  final String creatorName;
  /// can be null
  final String creatorPreferredUsername;
  final DateTime creatorPublished;
  /// can be null
  final String creatorAvatar;
  final bool banned;
  final bool bannedFromCommunity;
  final String communityActorId;
  final bool communityLocal;
  final String communityName;
  /// can be null
  final String communityIcon;
  final bool communityRemoved;
  final bool communityDeleted;
  final bool communityNsfw;
  final int numberOfComments;
  final int score;
  final int upvotes;
  final int downvotes;
  final int hotRank;
  final int hotRankActive;
  final DateTime newestActivityTime;
  /// can be null
  final int userId;
  /// can be null
  final int myVote;
  /// can be null
  final bool subscribed;
  /// can be null
  final bool read;
  /// can be null
  final bool saved;

  const PostView({
    this.id,
    this.name,
    this.url,
    this.body,
    this.creatorId,
    this.communityId,
    this.removed,
    this.locked,
    this.published,
    this.updated,
    this.deleted,
    this.nsfw,
    this.stickied,
    this.embedTitle,
    this.embedDescription,
    this.embedHtml,
    this.thumbnailUrl,
    this.apId,
    this.local,
    this.creatorActorId,
    this.creatorLocal,
    this.creatorName,
    this.creatorPreferredUsername,
    this.creatorPublished,
    this.creatorAvatar,
    this.banned,
    this.bannedFromCommunity,
    this.communityActorId,
    this.communityLocal,
    this.communityName,
    this.communityIcon,
    this.communityRemoved,
    this.communityDeleted,
    this.communityNsfw,
    this.numberOfComments,
    this.score,
    this.upvotes,
    this.downvotes,
    this.hotRank,
    this.hotRankActive,
    this.newestActivityTime,
    this.userId,
    this.myVote,
    this.subscribed,
    this.read,
    this.saved,
  });

  factory PostView.fromJson(Map<String, dynamic> json) =>
      _$PostViewFromJson(json);
}

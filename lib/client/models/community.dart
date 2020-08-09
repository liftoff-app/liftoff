import 'package:json_annotation/json_annotation.dart';

part 'community.g.dart';

/// based on https://github.com/LemmyNet/lemmy/blob/464ea862b10fa7b226b2550268e40d8e685a939c/server/lemmy_db/src/community_view.rs#L130
@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class CommunityView {
  final int id;
  final String name;
  final String title;
  /// can be null
  final String icon;
  /// can be null
  final String banner;
  /// can be null
  final String description;
  final int categoryId;
  final int creatorId;
  final bool removed;
  final DateTime published;
  /// can be null
  final DateTime updated;
  final bool deleted;
  final bool nsfw;
  final String actorId;
  final bool local;
  final DateTime lastRefreshedAt;
  final String creatorActorId;
  final bool creatorLocal;
  final String creatorName;
  /// can be null
  final String creatorPreferredUsername;
  /// can be null
  final String creatorAvatar;
  final String categoryName;
  final int numberOfSubscribers;
  final int numberOfPosts;
  final int numberOfComments;
  final int hotRank;
  /// can be null
  final int userId;
  /// can be null
  final bool subscribed;

  const CommunityView({
    this.id,
    this.name,
    this.title,
    this.icon,
    this.banner,
    this.description,
    this.categoryId,
    this.creatorId,
    this.removed,
    this.published,
    this.updated,
    this.deleted,
    this.nsfw,
    this.actorId,
    this.local,
    this.lastRefreshedAt,
    this.creatorActorId,
    this.creatorLocal,
    this.creatorName,
    this.creatorPreferredUsername,
    this.creatorAvatar,
    this.categoryName,
    this.numberOfSubscribers,
    this.numberOfPosts,
    this.numberOfComments,
    this.hotRank,
    this.userId,
    this.subscribed,
  });

  factory CommunityView.fromJson(Map<String, dynamic> json) =>
      _$CommunityViewFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';
import 'package:lemmur/mappingClasses/utility.dart';

part 'comment.g.dart';

@JsonSerializable()
class CommentView {
  CommentView(
    this.id,
    this.creatorId,
    this.postId,
    this.postName,
    this.parentId,
    this.content,
    this.removed,
    bool read,
    this.published,
    this.updated,
    this.deleted,
    this.apId,
    this.local,
    this.communityId,
    this.communityActorId,
    this.communityLocal,
    this.communityName,
    this.banned,
    this.bannedFromCommunity,
    this.creatorActorId,
    this.creatorLocal,
    this.creatorName,
    this.creatorPublished,
    this.creatorAvatar,
    this.score,
    this.upvotes,
    this.downvotes,
    this.hotRank,
    int userId,
    int myVote,
    bool subscribed,
    bool saved,
  ) {
    userId = userId;
    _myVote = myVote;
    _subscribed = subscribed;
    _read = read;
    _saved = saved;
  }

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "creator_id")
  final int creatorId;

  @JsonKey(name: "post_id")
  final int postId;

  @JsonKey(name: "post_name")
  final String postName;

  @JsonKey(name: "parent_id")
  final int parentId;

  @JsonKey(name: "content")
  final String content;

  @JsonKey(name: "removed")
  final bool removed;

  bool get read => _read;

  void set read(bool read) => _read = read;
  @JsonKey(name: "read")
  bool _read;

  @JsonKey(name: "published", fromJson: UtilityClass.ParseDateFromJson)
  final DateTime published;

  @JsonKey(name: "updated", fromJson: UtilityClass.ParseDateFromJson)
  final DateTime updated;

  @JsonKey(name: "deleted")
  final bool deleted;

  @JsonKey(name: "ap_id")
  final String apId;

  @JsonKey(name: "local")
  final bool local;

  @JsonKey(name: "community_id")
  final int communityId;

  @JsonKey(name: "community_actor_id")
  final String communityActorId;

  @JsonKey(name: "community_local")
  final bool communityLocal;

  @JsonKey(name: "community_name")
  final String communityName;

  @JsonKey(name: "banned")
  final bool banned;

  @JsonKey(name: "banned_from_community")
  final bool bannedFromCommunity;

  @JsonKey(name: "creator_actor_id")
  final String creatorActorId;

  @JsonKey(name: "creator_local")
  final bool creatorLocal;

  @JsonKey(name: "creator_name")
  final String creatorName;

  @JsonKey(name: "creator_published", fromJson: UtilityClass.ParseDateFromJson)
  final DateTime creatorPublished;

  @JsonKey(name: "creator_avatar")
  final String creatorAvatar;

  @JsonKey(name: "score")
  int score;

  @JsonKey(name: "upvotes")
  int upvotes;

  @JsonKey(name: "downvotes")
  int downvotes;

  @JsonKey(name: "hot_rank")
  final int hotRank;

  int get userId => _userId;

  void set userId(int userId) => _userId = userId;
  @JsonKey(name: "user_id")
  int _userId;

  int get myVote => _myVote;

  void set myVote(int myVote) => _myVote = myVote > 0 ? 1 : myVote < 0 ? -1 : 0;
  @JsonKey(name: "my_vote")
  int _myVote;

  bool get subscribed => _subscribed;

  void set subscribed(bool subscribed) => _subscribed = subscribed;
  @JsonKey(name: "subscribed")
  bool _subscribed;

  bool get saved => _saved;

  void set saved(bool saved) => _saved = saved;
  @JsonKey(name: "saved")
  bool _saved;

  factory CommentView.fromJson(Map<String, dynamic> json) =>
      _$CommentViewFromJson(json);

  Map<String, dynamic> commentViewToJson() => _$CommentViewToJson(this);
}

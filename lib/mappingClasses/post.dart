import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostView {
  PostView(
      this.id,
      this.postName,
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
      this.creatorPublished,
      this.creatorAvatar,
      this.banned,
      this.bannedFromCommunity,
      this.communityActorId,
      this.communityLocal,
      this.communityName,
      this.communityRemoved,
      this.communityDeleted,
      this.communityNsfw,
      this.numberOfComments,
      this.score,
      this.upvotes,
      this.downvotes,
      this.hotRank,
      this.newestActivityTime,
      int userId,
      int myVote,
      bool subscribed,
      bool read,
      bool saved) {
    _userId = userId;
    _myVote = myVote;
    _subscribed = subscribed;
    _read = read;
    _saved = saved;
  }

  //TODO: Parse date from Json.
  static DateTime ParseDateFromJson(t) {
    throw Exception("Not implemented exception");
  }

  @JsonKey(name: "id")
  final int id;

  @JsonKey(name: "name")
  final String postName;

  @JsonKey(name: "url")
  final String url;

  @JsonKey(name: "body")
  final String body;

  @JsonKey(name: "creator_id")
  final int creatorId;

  @JsonKey(name: "community_id")
  final int communityId;

  @JsonKey(name: "removed")
  final bool removed;

  @JsonKey(name: "locked")
  final bool locked;

  @JsonKey(name: "published", fromJson: ParseDateFromJson)
  final DateTime published;

  @JsonKey(name: "updated", fromJson: ParseDateFromJson)
  final DateTime updated;

  @JsonKey(name: "deleted")
  final bool deleted;

  @JsonKey(name: "nsfw")
  final bool nsfw;

  @JsonKey(name: "stickied")
  final bool stickied;

  @JsonKey(name: "embed_title")
  final String embedTitle;

  @JsonKey(name: "embed_description")
  final String embedDescription;

  @JsonKey(name: "embed_html")
  final String embedHtml;

  @JsonKey(name: "thumbnail_url")
  final String thumbnailUrl;

  @JsonKey(name: "ap_id")
  final String apId;

  @JsonKey(name: "local")
  final bool local;

  @JsonKey(name: "creator_actor_id")
  final String creatorActorId;

  @JsonKey(name: "creator_local")
  final bool creatorLocal;

  @JsonKey(name: "creator_name")
  final String creatorName;

  @JsonKey(name: "creator_published", fromJson: ParseDateFromJson)
  final DateTime creatorPublished;

  @JsonKey(name: "creator_avatar")
  final String creatorAvatar;

  @JsonKey(name: "banned")
  final bool banned;

  @JsonKey(name: "banned_from_community")
  final bool bannedFromCommunity;

  @JsonKey(name: "community_actor_id")
  final String communityActorId;

  @JsonKey(name: "community_local")
  final bool communityLocal;

  @JsonKey(name: "community_name")
  final String communityName;

  @JsonKey(name: "community_removed")
  final bool communityRemoved;

  @JsonKey(name: "community_deleted")
  final bool communityDeleted;

  @JsonKey(name: "community_nsfw")
  final bool communityNsfw;

  @JsonKey(name: "number_of_comments")
  final int numberOfComments;

  @JsonKey(name: "score")
  int score;

  @JsonKey(name: "upvotes")
  int upvotes;

  @JsonKey(name: "downvotes")
  int downvotes;

  @JsonKey(name: "hot_rank")
  final int hotRank;

  @JsonKey(name: "newest_activity_time", fromJson: ParseDateFromJson)
  final DateTime newestActivityTime;

  int get userId {
    return _userId;
  }

  void set userId(int userId) => _userId = userId;
  @JsonKey(name: "user_id")
  int _userId;

  int get myVote {
    return _myVote;
  }

  void set myVote(int myVote) => _myVote = myVote>0?1:myVote<0?-1:0;
  @JsonKey(name: "my_vote")
  int _myVote;

  bool get subscribed {
    return _subscribed;
  }

  void set subscribed(bool subscribed) => _subscribed = subscribed;
  @JsonKey(name: "subscribed")
  bool _subscribed;

  bool get read {
    return _read;
  }

  void set read(bool read) => _read = read;
  @JsonKey(name: "read")
  bool _read;

  bool get saved {
    return _saved;
  }

  void set saved(bool saved) => _saved = saved;
  @JsonKey(name: "saved")
  bool _saved;

  factory PostView.fromJson(Map<String, dynamic> json) =>
      _$PostViewFromJson(json);

  Map<String, dynamic> postViewToJson() => _$PostViewToJson(this);
}

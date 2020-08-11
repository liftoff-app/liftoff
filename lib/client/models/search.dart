import 'package:json_annotation/json_annotation.dart';

import './comment.dart';
import './community.dart';
import './post.dart';
import './user.dart';

part 'search.g.dart';

/// based on https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#search
@JsonSerializable(createToJson: false)
class Search {
  @JsonKey(name: "type_")
  final String type;
  final List<CommentView> comments;
  final List<PostView> posts;
  final List<CommunityView> communities;
  final List<UserView> users;

  const Search({
    this.type,
    this.comments,
    this.posts,
    this.communities,
    this.users,
  });

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);
}

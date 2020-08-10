import 'package:json_annotation/json_annotation.dart';

import './comment.dart';
import './post.dart';
import './community.dart';
import './user.dart';

part 'search.g.dart';


/// based on https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#search
@JsonSerializable(createToJson: false)
class Search {
  final String type_;
  final List<CommentView> comments;
  final List<PostView> posts;
  final List<CommunityView> communities;
  final List<UserView> users;

  const Search({
    this.type_,
    this.comments,
    this.posts,
    this.communities,
    this.users,
  });

  factory Search.fromJson(Map<String, dynamic> json) =>
        _$SearchFromJson(json);
}

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemmur/client/models/comment.dart';

void main() {
  test("CommentView test", () {
    Map<String, dynamic> commentFromApi = jsonDecode(""" 
      {
        "id": 14296,
        "creator_id": 8218,
        "post_id": 38501,
        "post_name": "Niklaus Wirth was right and that is a problem",
        "parent_id": 14286,
        "content": "I think that the same functionality current crop of apps has could be implemented much more cleanly and efficiently if there wasn't a rush to get products to market. If developers could spend the time to think things through and try different approaches to see what works best we'd have much higher quality software today. Instead, everything is rushed to market as fast as possible, and developers are constantly overwhelmed with unreasonable amounts of work with no time to do things properly or clean things up along the way.",
        "removed": false,
        "read": true,
        "published": "2020-08-02T20:31:19.303284",
        "updated": null,
        "deleted": false,
        "ap_id": "https://dev.lemmy.ml/comment/14296",
        "local": true,
        "community_id": 14680,
        "community_actor_id": "https://dev.lemmy.ml/c/programming",
        "community_local": true,
        "community_name": "programming",
        "community_icon": null,
        "banned": false,
        "banned_from_community": false,
        "creator_actor_id": "https://dev.lemmy.ml/u/yogthos",
        "creator_local": true,
        "creator_name": "yogthos",
        "creator_preferred_username": null,
        "creator_published": "2020-01-18T04:02:39.254957",
        "creator_avatar": "https://dev.lemmy.ml/pictrs/image/bwk1q2.png",
        "score": 1,
        "upvotes": 1,
        "downvotes": 0,
        "hot_rank": 0,
        "hot_rank_active": 0,
        "user_id": 13709,
        "my_vote": 0,
        "subscribed": false,
        "saved": false
      }""");

    var comment = CommentView.fromJson(commentFromApi);

    print(comment);
    expect(14296, comment.id);
    expect(8218, comment.creatorId);
  });
}

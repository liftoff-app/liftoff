import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lemmur/client/models/community.dart';

void main() {
  test("PostView test", () {
    Map<String, dynamic> communityJson = jsonDecode("""
      {
        "id": 3,
        "name": "haskell",
        "title": "The Haskell Lemmy Forum",
        "icon": null,
        "banner": null,
        "description": null,
        "category_id": 21,
        "creator_id": 77,
        "removed": false,
        "published": "2019-04-22T17:52:37.759443",
        "updated": null,
        "deleted": false,
        "nsfw": false,
        "actor_id": "https://dev.lemmy.ml/c/haskell",
        "local": true,
        "last_refreshed_at": "2020-06-30T00:49:22.589810",
        "creator_actor_id": "https://dev.lemmy.ml/u/topos",
        "creator_local": true,
        "creator_name": "topos",
        "creator_preferred_username": null,
        "creator_avatar": null,
        "category_name": "Programming/Software",
        "number_of_subscribers": 85,
        "number_of_posts": 0,
        "number_of_comments": 0,
        "hot_rank": 0,
        "user_id": null,
        "subscribed": null
    }""");

    var community = CommunityView.fromJson(communityJson);

    expect(community.id, 3);
    expect(community.name, "haskell");
    expect(community.title, "The Haskell Lemmy Forum");
    expect(community.icon, null);
    expect(community.banner, null);
    expect(community.description, null);
    expect(community.categoryId, 21);
    expect(community.creatorId, 77);
    expect(community.removed, false);
    expect(community.published, DateTime.parse("2019-04-22T17:52:37.759443"));
    expect(community.updated, null);
    expect(community.deleted, false);
    expect(community.nsfw, false);
    expect(community.actorId, "https://dev.lemmy.ml/c/haskell");
    expect(community.local, true);
    expect(community.lastRefreshedAt,
        DateTime.parse("2020-06-30T00:49:22.589810"));
    expect(community.creatorActorId, "https://dev.lemmy.ml/u/topos");
    expect(community.creatorLocal, true);
    expect(community.creatorName, "topos");
    expect(community.creatorPreferredUsername, null);
    expect(community.creatorAvatar, null);
    expect(community.categoryName, "Programming/Software");
    expect(community.numberOfSubscribers, 85);
    expect(community.numberOfPosts, 0);
    expect(community.numberOfComments, 0);
    expect(community.hotRank, 0);
    expect(community.userId, null);
    expect(community.subscribed, null);
  });
}

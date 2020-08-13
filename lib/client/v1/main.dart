import 'package:flutter/foundation.dart' show required;

import '../http_helper.dart';
import '../models/category.dart';
import '../models/search.dart';

export 'comment_endpoint.dart';
export 'post_endpoint.dart';
export 'user_endpoint.dart';

class V1 with HttpHelper {
  @override
  final String host;
  @override
  final String extraPath = "/api/v1";

  V1(this.host);

  /// GET /categories
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#list-categories
  Future<List<Category>> listCategories() {
    throw UnimplementedError();
  }

  /// POST /search
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#search
  Future<Search> search({
    @required String q,
    @required SearchType type,
    String communityId,
    @required SortType sort,
    int page,
    int limit,
    String auth,
  }) {
    assert(q != null);
    assert(type != null);
    assert(sort != null);

    throw UnimplementedError();
  }
}

enum Vote {
  up,
  none,
  down,
}

extension VoteValue on Vote {
  int get value {
    switch (this) {
      case Vote.up:
        return 1;
      case Vote.none:
        return 0;
      case Vote.down:
        return -1;
    }
    throw Exception("unreachable");
  }
}

enum PostListingType {
  all,
  subscribed,
  community,
}

extension PostTypeValue on PostListingType {
  String get value {
    switch (this) {
      case PostListingType.all:
        return "All";
      case PostListingType.subscribed:
        return "Subscribed";
      case PostListingType.community:
        return "Community";
    }
    throw Exception("unreachable");
  }
}

enum SortType {
  active,
  hot,
  // ignore: constant_identifier_names
  new_,
  topDay,
  topWeek,
  topMonth,
  topYear,
  topAll,
}

extension SortTypeValue on SortType {
  String get value {
    switch (this) {
      case SortType.active:
        return "Active";
      case SortType.hot:
        return "Hot";
      case SortType.new_:
        return "New";
      case SortType.topDay:
        return "TopDay";
      case SortType.topWeek:
        return "TopWeek";
      case SortType.topMonth:
        return "TopMonth";
      case SortType.topYear:
        return "TopYear";
      case SortType.topAll:
        return "TopAll";
    }
    throw Exception("unreachable");
  }
}

enum SearchType {
  all,
  comments,
  posts,
  communities,
  users,
  url,
}

extension SearchTypeValue on SearchType {
  String get value {
    switch (this) {
      case SearchType.all:
        return "All";
      case SearchType.comments:
        return "Comments";
      case SearchType.posts:
        return "Posts";
      case SearchType.communities:
        return "Communities";
      case SearchType.users:
        return "Users";
      case SearchType.url:
        return "Url";
    }
    throw Exception("unreachable");
  }
}

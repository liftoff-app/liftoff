import 'package:flutter/foundation.dart' show required;
import 'package:lemmur/client/models/community.dart';

import 'main.dart';

extension CommunityEndpoint on V1 {
  /// GET /community
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#get-community
  Future<FullCommunityView> getCommunity({
    int id,
    String name,
    String auth,
  }) async {
    assert(id != null || name != null);

    var res = await get('/community', {
      if (id != null) 'id': id.toString(),
      if (name != null) 'name': name,
      if (auth != null) 'auth': auth,
    });

    return FullCommunityView.fromJson(res);
  }

  /// GET /community/list
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#list-communities
  Future<List<CommunityView>> listCommunities({
    @required SortType sort,
    int page,
    int limit,
    String auth,
  }) async {
    assert(sort != null);

    var res = await get('/community/list', {
      'sort': sort.value,
      if (page != null) 'page': page.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (auth != null) 'auth': auth,
    });
    List<dynamic> communities = res['communities'];
    return communities.map((e) => CommunityView.fromJson(e)).toList();
  }

  /// POST /community/follow
  /// https://dev.lemmy.ml/docs/contributing_websocket_http_api.html#follow-community
  Future<CommunityView> followCommunity({
    @required int communityId,
    @required bool follow,
    @required String auth,
  }) async {
    var res = await post('/community/follow', {
      if (communityId != null) 'community_id': communityId,
      if (follow != null) 'follow': follow,
      if (auth != null) 'auth': auth,
    });

    return CommunityView.fromJson(res['community']);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/stores.dart';
import '../widgets/comment.dart';
import '../widgets/post.dart';
import '../widgets/sortable_infinite_list.dart';
import 'communities_list.dart';
import 'users_list.dart';

class SearchResultsPage extends HookWidget {
  final String instanceHost;
  final String query;

  SearchResultsPage({
    @required this.instanceHost,
    @required this.query,
  })  : assert(instanceHost != null),
        assert(query != null),
        assert(instanceHost.isNotEmpty),
        assert(query.isNotEmpty);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Looking for "$query"'),
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Posts'),
                Tab(text: 'Comments'),
                Tab(text: 'Users'),
                Tab(text: 'Communities'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _SearchResultsList(
                  instanceHost: instanceHost,
                  query: query,
                  type: SearchType.posts),
              _SearchResultsList(
                  instanceHost: instanceHost,
                  query: query,
                  type: SearchType.comments),
              _SearchResultsList(
                  instanceHost: instanceHost,
                  query: query,
                  type: SearchType.users),
              _SearchResultsList(
                  instanceHost: instanceHost,
                  query: query,
                  type: SearchType.communities),
            ],
          ),
        ),
      );
}

class _SearchResultsList extends HookWidget {
  final SearchType type;
  final String query;
  final String instanceHost;

  const _SearchResultsList({
    @required this.type,
    @required this.query,
    @required this.instanceHost,
  })  : assert(type != null),
        assert(query != null),
        assert(instanceHost != null);

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();

    return SortableInfiniteList(
      fetcher: (page, batchSize, sort) async {
        final s = await LemmyApiV2(instanceHost).run(Search(
          q: query,
          sort: sort,
          type: type,
          auth: accStore.defaultTokenFor(instanceHost)?.raw,
          page: page,
          limit: batchSize,
        ));

        switch (s.type) {
          case SearchType.comments:
            return s.comments;
          case SearchType.communities:
            return s.communities;
          case SearchType.posts:
            return s.posts;
          case SearchType.users:
            return s.users;
          default:
            throw UnimplementedError();
        }
      },
      itemBuilder: (data) {
        switch (type) {
          case SearchType.comments:
            return CommentWidget.fromCommentView(data as CommentView);
          case SearchType.communities:
            return CommunitiesListItem(community: data as CommunityView);
          case SearchType.posts:
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: PostWidget(data as PostView),
            );
          case SearchType.users:
            return UsersListItem(user: data as UserViewSafe);
          default:
            throw UnimplementedError();
        }
      },
    );
  }
}

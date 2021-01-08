import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../comment_tree.dart';
import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/comment.dart';
import '../widgets/post.dart';
import '../widgets/sortable_infinite_list.dart';

class SearchResultsPage extends HookWidget {
  final String instance;
  final String query;

  SearchResultsPage({
    @required this.instance,
    @required this.query,
  })  : assert(instance != null),
        assert(query != null),
        assert(instance.isNotEmpty),
        assert(query.isNotEmpty);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
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
                  instance: instance, query: query, type: SearchType.posts),
              _SearchResultsList(
                  instance: instance, query: query, type: SearchType.comments),
              _SearchResultsList(
                  instance: instance, query: query, type: SearchType.users),
              _SearchResultsList(
                  instance: instance,
                  query: query,
                  type: SearchType.communities),
            ],
          ),
        ),
      );
  //
}

class _SearchResultsList extends HookWidget {
  final SearchType type;
  final String query;
  final String instance;

  const _SearchResultsList({
    @required this.type,
    @required this.query,
    @required this.instance,
  })  : assert(type != null),
        assert(query != null),
        assert(instance != null);

  @override
  Widget build(BuildContext context) {
    final acs = useAccountsStore();

    return SortableInfiniteList(
      fetcher: (page, batchSize, sort) async {
        final s = await LemmyApi(instance).v1.search(
              q: query,
              sort: sort,
              type: type,
              auth: acs.defaultTokenFor(instance)?.raw,
              page: page,
            );

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
            throw Error();
        }
      },
      builder: (data) {
        switch (type) {
          case SearchType.comments:
            return Comment(
              CommentTree(data as CommentView),
              postCreatorId: null,
            );
          case SearchType.communities:
            // TODO: extract to universal widget
            return ListTile(
                title: Text((data as CommunityView).name),
                onTap: () => goToCommunity.byId(
                      context,
                      instance,
                      (data as CommunityView).id,
                    ));
          case SearchType.posts:
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Post(data as PostView),
            );
          case SearchType.users:
            // TODO: extract to universal widget
            return ListTile(
                title: Text((data as UserView).name),
                onTap: () =>
                    goToUser.byId(context, instance, (data as UserView).id));
          default:
            throw Error();
        }
      },
    );
  }
}

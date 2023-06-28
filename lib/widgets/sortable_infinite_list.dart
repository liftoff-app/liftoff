import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../comment_tree.dart';
import '../hooks/infinite_scroll.dart';
import '../hooks/stores.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
import 'comment/comment.dart';
import 'comment_list_options.dart';
import 'infinite_scroll.dart';
import 'post/post.dart';
import 'post_list_options.dart';

typedef FetcherWithSorting<T> = Future<List<T>> Function(
    int page, int batchSize, SortType sortType);

/// Infinite list of posts
class SortableInfiniteList<T> extends HookWidget {
  final FetcherWithSorting<T> fetcher;
  final Widget Function(T) itemBuilder;
  final InfiniteScrollController? controller;
  final Function? onStyleChange;
  final Widget noItems;

  /// if no defaultSort is provided, the defaultSortType
  /// from the configStore will be used
  final SortType? defaultSort;
  final Object Function(T item)? uniqueProp;
  const SortableInfiniteList({
    required this.fetcher,
    required this.itemBuilder,
    this.controller,
    this.onStyleChange,
    this.noItems = const SizedBox.shrink(),
    this.defaultSort,
    this.uniqueProp,
  });

  @override
  Widget build(BuildContext context) {
    final defaultSortType =
        useStore((ConfigStore store) => store.defaultSortType);
    final defaultController = useInfiniteScrollController();
    final isc = controller ?? defaultController;

    final sort = useState(defaultSort ?? defaultSortType);

    void changeSorting(SortType newSort) {
      sort.value = newSort;
      isc.clear();
    }

    return InfiniteScroll<T>(
      leading: PostListOptions(
        sortValue: sort.value,
        onSortChanged: changeSorting,
      ),
      itemBuilder: itemBuilder,
      padding: EdgeInsets.zero,
      fetcher: (page, batchSize) => fetcher(page, batchSize, sort.value),
      controller: isc,
      batchSize: 20,
      noItems: noItems,
      uniqueProp: uniqueProp,
    );
  }
}

class InfinitePostList extends SortableInfiniteList<PostView> {
  InfinitePostList({
    required super.fetcher,
    super.controller,
  }) : super(
          itemBuilder: (post) => ObserverBuilder<ConfigStore>(
              builder: (context, store) => Column(
                    children: [
                      PostTile.fromPostView(post),
                      SizedBox(height: store.compactPostView ? 2 : 10),
                    ],
                  )),
          noItems: const Text('there are no posts'),
          uniqueProp: (item) => item.post.apId,
        );
}

class InfiniteCommentList extends SortableInfiniteList<CommentView> {
  InfiniteCommentList({
    required super.fetcher,
    super.controller,
  }) : super(
          itemBuilder: (comment) => CommentWidget(
            CommentTree(comment),
            detached: true,
          ),
          noItems: const Text('there are no comments'),
          uniqueProp: (item) => item.comment.apId,
        );
}

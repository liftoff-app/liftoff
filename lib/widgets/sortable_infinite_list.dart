import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../comment_tree.dart';
import '../hooks/infinite_scroll.dart';
import '../hooks/stores.dart';
import 'comment/comment.dart';
import 'infinite_scroll.dart';
import 'post.dart';
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
        useConfigStoreSelect((store) => store.defaultSortType);
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
        styleButton: onStyleChange != null,
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
    required FetcherWithSorting<PostView> fetcher,
    InfiniteScrollController? controller,
  }) : super(
          itemBuilder: (post) => Column(
            children: [
              PostWidget(post),
              const SizedBox(height: 20),
            ],
          ),
          fetcher: fetcher,
          controller: controller,
          noItems: const Text('there are no posts'),
          uniqueProp: (item) => item.post.apId,
        );
}

class InfiniteCommentList extends SortableInfiniteList<CommentView> {
  InfiniteCommentList({
    required FetcherWithSorting<CommentView> fetcher,
    InfiniteScrollController? controller,
  }) : super(
          itemBuilder: (comment) => CommentWidget(
            CommentTree(comment),
            detached: true,
          ),
          fetcher: fetcher,
          controller: controller,
          noItems: const Text('there are no comments'),
          uniqueProp: (item) => item.comment.apId,
        );
}

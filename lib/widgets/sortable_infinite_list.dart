import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../comment_tree.dart';
import '../hooks/infinite_scroll.dart';
import '../hooks/stores.dart';
import '../resources/app_theme.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
import 'comment/comment.dart';
import 'comment_list_options.dart';
import 'infinite_scroll.dart';
import 'post/post.dart';
import 'post/post_store.dart';
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
  final bool refreshOnFetcherUpdate;

  /// if no defaultSort is provided, the defaultSortType
  /// from the configStore will be used
  final SortType? defaultSort;
  final Object Function(T item) uniqueProp;
  const SortableInfiniteList({
    super.key,
    required this.fetcher,
    required this.itemBuilder,
    this.controller,
    this.onStyleChange,
    this.noItems = const SizedBox.shrink(),
    this.defaultSort,
    this.refreshOnFetcherUpdate = false,
    required this.uniqueProp,
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
      refreshOnFetcherUpdate: refreshOnFetcherUpdate,
      uniqueProp: uniqueProp,
    );
  }
}

typedef CommentFetcherWithSorting<T> = Future<List<T>> Function(
    int page, int batchSize, CommentSortType sortType);

/// Infinite list of comments
class SortableInfiniteCommentList<T> extends HookWidget {
  final CommentFetcherWithSorting<T> fetcher;
  final Widget Function(T) itemBuilder;
  final InfiniteScrollController? controller;
  final Function? onStyleChange;
  final Widget noItems;

  /// if no defaultSort is provided, the defaultSortType
  /// from the configStore will be used
  final dynamic defaultSort;
  final Object Function(T item) uniqueProp;
  const SortableInfiniteCommentList({
    super.key,
    required this.fetcher,
    required this.itemBuilder,
    this.controller,
    this.onStyleChange,
    this.noItems = const SizedBox.shrink(),
    this.defaultSort,
    required this.uniqueProp,
  });

  @override
  Widget build(BuildContext context) {
    final defaultCommentSort =
        useStore((ConfigStore store) => store.defaultCommentSort);
    final defaultController = useInfiniteScrollController();
    final isc = controller ?? defaultController;
    final commentSort = useState(defaultSort ?? defaultCommentSort);

    void changeCommentSort(dynamic newSort) {
      commentSort.value = newSort;
      isc.clear();
    }

    return InfiniteScroll<T>(
      leading: CommentListOptions(
        sortValue: commentSort.value,
        onSortChanged: changeCommentSort,
      ),
      itemBuilder: itemBuilder,
      padding: EdgeInsets.zero,
      fetcher: (page, batchSize) => fetcher(page, batchSize, commentSort.value),
      controller: isc,
      batchSize: 20,
      noItems: noItems,
      uniqueProp: uniqueProp,
    );
  }
}

class InfinitePostList extends SortableInfiniteList<PostStore> {
  InfinitePostList({
    super.key,
    required super.fetcher,
    super.controller,
    super.refreshOnFetcherUpdate = false,
  }) : super(
          itemBuilder: (post) => Consumer<AppTheme>(
              builder: (context, state, child) => Column(
                    children: [
                      PostTile.fromPostStore(post, fullPost: false),
                      if (state.useAmoled)
                        SizedBox(
                          width: 250,
                          height: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Theme.of(context).primaryColorDark,
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).primaryColorDark,
                              ],
                            )),
                          ),
                        ),
                      SizedBox(
                          height: context.read<ConfigStore>().compactPostView
                              ? 2
                              : 10),
                    ],
                  )),
          noItems: const Text('there are no posts'),
          uniqueProp: (item) => item.postView.post.apId,
        );
}

class InfiniteCommentList extends SortableInfiniteCommentList<CommentView> {
  InfiniteCommentList({
    super.key,
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

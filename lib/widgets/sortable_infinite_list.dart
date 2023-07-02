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
import 'post_list_options.dart';

typedef FetcherWithSorting<T> = Future<List<T>> Function(
    int page, int batchSize, dynamic sortType);

/// Infinite list of posts
class SortableInfiniteList<T> extends HookWidget {
  final FetcherWithSorting<T> fetcher;
  final Widget Function(T) itemBuilder;
  final InfiniteScrollController? controller;
  final Function? onStyleChange;
  final Widget noItems;

  /// if no defaultSort is provided, the defaultSortType
  /// from the configStore will be used
  final dynamic defaultSort;
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
    final defaultPostSort =
        useStore((ConfigStore store) => store.defaultSortType);

    final defaultCommentSort =
        useStore((ConfigStore store) => store.defaultCommentSort);
    final defaultController = useInfiniteScrollController();
    final isc = controller ?? defaultController;

    final postSort = useState(defaultSort ?? defaultPostSort);
    final commentSort = useState(defaultSort ?? defaultCommentSort);

    void changePostSort(SortType newSort) {
      postSort.value = newSort;
      isc.clear();
    }

    void changeCommentSort(dynamic newSort) {
      commentSort.value = newSort;
      isc.clear();
    }

    return InfiniteScroll<T>(
      leading: T == PostView
          ? PostListOptions(
              sortValue: postSort.value,
              onSortChanged: changePostSort,
            )
          : CommentListOptions(
              sortValue: commentSort.value,
              onSortChanged: changeCommentSort,
            ),
      itemBuilder: itemBuilder,
      padding: EdgeInsets.zero,
      fetcher: (page, batchSize) => fetcher(
          page, batchSize, T == PostView ? postSort.value : commentSort.value),
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
          itemBuilder: (post) => Consumer<AppTheme>(
              builder: (context, state, child) => Column(
                    children: [
                      PostTile.fromPostView(post),
                      if (state.amoled)
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

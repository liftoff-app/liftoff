import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../comment_tree.dart';
import '../hooks/infinite_scroll.dart';
import 'comment.dart';
import 'infinite_scroll.dart';
import 'post.dart';
import 'post_list_options.dart';

typedef FetcherWithSorting<T> = Future<List<T>> Function(
    int page, int batchSize, SortType sortType);

/// Infinite list of posts
class SortableInfiniteList<T> extends HookWidget {
  final FetcherWithSorting<T> fetcher;
  final Widget Function(T) itemBuilder;
  final InfiniteScrollController controller;
  final Function onStyleChange;
  final Widget noItems;
  final SortType defaultSort;

  const SortableInfiniteList({
    @required this.fetcher,
    @required this.itemBuilder,
    this.controller,
    this.onStyleChange,
    this.noItems,
    this.defaultSort = SortType.active,
  })  : assert(fetcher != null),
        assert(itemBuilder != null),
        assert(defaultSort != null);

  @override
  Widget build(BuildContext context) {
    final defaultController = useInfiniteScrollController();
    final isc = controller ?? defaultController;

    final sort = useState(defaultSort);

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
    );
  }
}

class InfinitePostList extends StatelessWidget {
  final FetcherWithSorting<PostView> fetcher;
  final InfiniteScrollController controller;

  const InfinitePostList({
    @required this.fetcher,
    this.controller,
  }) : assert(fetcher != null);

  Widget build(BuildContext context) => SortableInfiniteList<PostView>(
        onStyleChange: () {},
        itemBuilder: (post) => Column(
          children: [
            PostWidget(post),
            const SizedBox(height: 20),
          ],
        ),
        fetcher: fetcher,
        controller: controller,
        noItems: const Text('there are no posts'),
      );
}

class InfiniteCommentList extends StatelessWidget {
  final FetcherWithSorting<CommentView> fetcher;
  final InfiniteScrollController controller;

  const InfiniteCommentList({
    @required this.fetcher,
    this.controller,
  }) : assert(fetcher != null);

  Widget build(BuildContext context) => SortableInfiniteList<CommentView>(
        itemBuilder: (comment) => CommentWidget(
          CommentTree(comment),
          detached: true,
        ),
        fetcher: fetcher,
        controller: controller,
        noItems: const Text('there are no comments'),
      );
}

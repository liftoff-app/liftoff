import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'bottom_safe.dart';
import 'pull_to_refresh.dart';

class InfiniteScrollController {
  late VoidCallback clear;
  late VoidCallback scrollToTop;

  InfiniteScrollController() {
    usedBeforeCreation() => throw Exception(
        'Tried to use $runtimeType before it being initialized');

    clear = usedBeforeCreation;
    scrollToTop = usedBeforeCreation;
  }
}

typedef Fetcher<T> = Future<List<T>> Function(int page, int batchSize);

/// `ListView.builder` with asynchronous data fetching and no `itemCount`
class InfiniteScroll<T> extends HookWidget {
  /// How many items should be fetched per call
  final int batchSize;

  /// Widget displayed at the bottom when InfiniteScroll is fetching
  final Widget loadingWidget;

  /// Builds your widget from the fetched data
  final Widget Function(T data) itemBuilder;

  /// Fetches data to be displayed. It is important to respect `batchSize`,
  /// if the returned list has less than `batchSize` then the InfiniteScroll
  /// is considered finished
  final Fetcher<T> fetcher;

  final InfiniteScrollController? controller;

  /// Widget to be added at the beginning of the list
  final Widget leading;

  /// Padding for the [ListView.builder]
  final EdgeInsetsGeometry? padding;

  /// Widget that will be displayed if there are no items
  final Widget noItems;

  /// Maps an item to its unique property that will allow to detect possible
  /// duplicates thus perfoming deduplication
  final Object Function(T item)? uniqueProp;

  /// If true, all content will be discarded and refetched when value
  /// of [fetcher] changes.
  ///
  /// NOTE: [fetcher] MUST be memoized if this is set to true.
  ///       Otherwise, it will cause an infinite loop.
  final bool refreshOnFetcherUpdate;

  const InfiniteScroll({
    this.batchSize = 10,
    this.leading = const SizedBox.shrink(),
    this.padding,
    this.loadingWidget = const ListTile(
        title: Center(child: CircularProgressIndicator.adaptive())),
    required this.itemBuilder,
    required this.fetcher,
    this.controller,
    this.noItems = const SizedBox.shrink(),
    this.refreshOnFetcherUpdate = false,
    this.uniqueProp,
  }) : assert(batchSize > 0);

  @override
  Widget build(BuildContext context) {
    final pagingController =
        useMemoized(() => PagingController<int, T>(firstPageKey: 1), []);

    useEffect(() {
      controller?.clear = pagingController.refresh;
      controller?.scrollToTop = () => PrimaryScrollController.of(context)
          .animateTo(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
      return null;
    }, []);

    // Need to memoize the callback so we get a single instance
    // that we can add/remove from the controller.
    final pageRequestListener = useCallback((pageKey) async {
      try {
        final items = await fetcher(pageKey, batchSize);
        // TODO: check if deduplication is needed
        // final uniqueItems =
        //     uniqueProp == null ? items : LinkedHashSet<T>.from(items).toList();
        final isLastPage = items.length < batchSize;
        if (isLastPage) {
          pagingController.appendLastPage(items);
        } else {
          pagingController.appendPage(items, pageKey + 1);
        }
      } catch (error) {
        pagingController.error = error;
      }
    }, [fetcher]);

    // Because of the way closures and bindings work in dart, a lambda
    // function we create here will always call the instance of `fetcher`
    // it was created with, even if the `fetcher` variable changes.
    //
    // As such, we have to remove the listener and add a new one every
    // time `fetcher` changes. The `useCallback` hook above will ensure
    // we get a new `pageRequstListener` every time `fetcher` changes.
    useEffect(() {
      pagingController.addPageRequestListener(pageRequestListener);
      return () {
        pagingController.removePageRequestListener(pageRequestListener);
        if (this.refreshOnFetcherUpdate) {
          pagingController.refresh();
        }
      };
    }, [pageRequestListener]);

    return PullToRefresh(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: leading),
          PagedSliverList<int, T>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<T>(
              itemBuilder: (context, item, index) => itemBuilder(item),
              noItemsFoundIndicatorBuilder: (context) => Center(child: noItems),
              noMoreItemsIndicatorBuilder: (context) => const BottomSafe(),
              firstPageProgressIndicatorBuilder: (context) => loadingWidget,
              newPageProgressIndicatorBuilder: (context) => loadingWidget,
            ),
          )
        ]));
  }
}

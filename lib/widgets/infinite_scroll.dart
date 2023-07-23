import 'dart:collection';

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
  final Object Function(T item) uniqueProp;

  /// If true, all content will be discarded and refetched when value
  /// of [fetcher] changes.
  ///
  /// NOTE: [fetcher] MUST be memoized if this is set to true.
  ///       Otherwise, it will cause an infinite loop.
  final bool refreshOnFetcherUpdate;

  const InfiniteScroll({
    super.key,
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
    required this.uniqueProp,
  }) : assert(batchSize > 0);

  @override
  Widget build(BuildContext context) {
    final pagingController =
        useMemoized(() => PagingController<int, T>(firstPageKey: 1), []);

    final dataSet = useRef(HashSet<Object>());

    useEffect(() {
      pagingController.addStatusListener((status) {
        // if there are less rendered items than unique items, we've probably
        // refreshed the page. Rebuilding the set will probably be a no-op.
        if ((pagingController.itemList?.length ?? 0) < dataSet.value.length) {
          dataSet.value =
              HashSet.from(pagingController.itemList?.map(uniqueProp) ?? []);
        }
      });
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
        final newItems = await fetcher(pageKey, batchSize);
        final uniqueNewItems = newItems.where((item) {
          final uniquePropValue = uniqueProp(item);
          if (dataSet.value.contains(uniquePropValue)) {
            return false;
          }

          dataSet.value.add(uniquePropValue);
          return true;
        }).toList();

        // If we got less than `batchSize` items, then we reached the end.
        // Note: we're checking `newItems` and not `uniqueNewItems`.
        final isLastPage = newItems.length < batchSize;
        if (isLastPage) {
          pagingController.appendLastPage(uniqueNewItems);
        } else {
          pagingController.appendPage(uniqueNewItems, pageKey + 1);
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

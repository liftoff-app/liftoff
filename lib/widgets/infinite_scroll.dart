import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    this.uniqueProp,
  }) : assert(batchSize > 0);

  @override
  Widget build(BuildContext context) {
    final data = useState<List<T>>([]);
    // holds unique props of the data
    final dataSet = useRef(HashSet<Object>());
    final hasMore = useRef(true);
    final page = useRef(1);
    final isFetching = useRef(false);

    final uniquePropFunc = uniqueProp ?? (e) => e as Object;

    useEffect(() {
      if (controller != null) {
        controller?.clear = () {
          data.value = [];
          hasMore.value = true;
          page.value = 1;
          dataSet.value.clear();
        };
        controller?.scrollToTop = () {
          // to be implemented
        };
      }

      return null;
    }, []);

    return PullToRefresh(
      onRefresh: () async {
        data.value = [];
        hasMore.value = true;
        page.value = 1;
        dataSet.value.clear();

        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: padding,
        // +2 for the loading widget and leading widget
        itemCount: data.value.length + 2,
        itemBuilder: (_, i) {
          if (i == 0) {
            return leading;
          }
          i -= 1;

          // if we are done but we have no data it means the list is empty
          if (!hasMore.value && data.value.isEmpty) {
            return Center(child: noItems);
          }

          // reached the bottom, fetch more
          if (i == data.value.length) {
            // if there are no more, skip
            if (!hasMore.value) {
              return const BottomSafe();
            }

            // if it's already fetching more, skip
            if (!isFetching.value) {
              isFetching.value = true;
              fetcher(page.value, batchSize).then((incoming) {
                // if got less than the batchSize, mark the list as done
                if (incoming.length < batchSize) {
                  hasMore.value = false;
                }

                final newData = incoming.where(
                  (e) => !dataSet.value.contains(uniquePropFunc(e)),
                );

                // append new data
                data.value = [...data.value, ...newData];
                dataSet.value.addAll(newData.map(uniquePropFunc));
                page.value += 1;
              }).whenComplete(() => isFetching.value = false);
            }

            return SafeArea(
              top: false,
              child: loadingWidget,
            );
          }

          // not last element, render list item
          return itemBuilder(data.value[i]);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/ref.dart';
import 'bottom_safe.dart';

class InfiniteScrollController {
  VoidCallback clear;

  InfiniteScrollController() {
    usedBeforeCreation() => throw Exception(
        'Tried to use $runtimeType before it being initialized');

    clear = usedBeforeCreation;
  }

  void dispose() {
    clear = null;
  }
}

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
  final Future<List<T>> Function(int page, int batchSize) fetcher;

  final InfiniteScrollController controller;

  /// Widget to be added at the beginning of the list
  final Widget leading;

  /// Padding for the [ListView.builder]
  final EdgeInsetsGeometry padding;

  /// Widget that will be displayed if there are no items
  final Widget noItems;

  const InfiniteScroll({
    this.batchSize = 10,
    this.leading = const SizedBox.shrink(),
    this.padding,
    this.loadingWidget =
        const ListTile(title: Center(child: CircularProgressIndicator())),
    @required this.itemBuilder,
    @required this.fetcher,
    this.controller,
    this.noItems = const SizedBox.shrink(),
  })  : assert(itemBuilder != null),
        assert(fetcher != null),
        assert(batchSize > 0);

  @override
  Widget build(BuildContext context) {
    final data = useState<List<T>>([]);
    final hasMore = useRef(true);
    final isFetching = useRef(false);

    useEffect(() {
      if (controller != null) {
        controller.clear = () {
          data.value = [];
          hasMore.current = true;
        };
      }

      return null;
    }, []);

    final page = data.value.length ~/ batchSize + 1;

    return RefreshIndicator(
      onRefresh: () async {
        controller.clear();
        await HapticFeedback.mediumImpact();
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
          if (!hasMore.current && data.value.isEmpty) {
            return Center(child: noItems);
          }

          // reached the bottom, fetch more
          if (i == data.value.length) {
            // if there are no more, skip
            if (!hasMore.current) {
              return const BottomSafe();
            }

            // if it's already fetching more, skip
            if (!isFetching.current) {
              isFetching.current = true;
              fetcher(page, batchSize).then((newData) {
                // if got less than the batchSize, mark the list as done
                if (newData.length < batchSize) {
                  hasMore.current = false;
                }
                // append new data
                data.value = [...data.value, ...newData];
              }).whenComplete(() => isFetching.current = false);
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

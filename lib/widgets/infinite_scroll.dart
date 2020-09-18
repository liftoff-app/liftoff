import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/ref.dart';

class InfiniteScrollController {
  Function() clear;

  InfiniteScrollController() {
    usedBeforeCreation() => throw Exception(
        'Tried to use $runtimeType before it being initialized');

    clear = usedBeforeCreation;
  }

  void dispose() {
    clear = null;
  }
}

class InfiniteScroll<T> extends HookWidget {
  final int batchSize;
  final Widget loadingWidget;
  final Widget Function(T data) builder;
  final Future<List<T>> Function(int page, int batchSize) fetchMore;
  final InfiniteScrollController controller;

  InfiniteScroll({
    this.batchSize = 10,
    this.loadingWidget =
        const ListTile(title: Center(child: CircularProgressIndicator())),
    @required this.builder,
    @required this.fetchMore,
    this.controller,
  })  : assert(builder != null),
        assert(fetchMore != null),
        assert(batchSize > 0);

  @override
  Widget build(BuildContext context) {
    final data = useState<List<T>>([]);
    final hasMore = useRef(true);
    final isFetching = useRef(false);

    useEffect(() {
      if (controller != null) {
        controller.clear = () => data.value = [];
        return controller.dispose;
      }

      return null;
    }, []);

    final page = data.value.length ~/ batchSize + 1;

    return ListView.builder(
      // +1 for the loading widget
      itemCount: data.value.length + 1,
      itemBuilder: (_, i) {
        // reached the bottom, fetch more
        if (i == data.value.length) {
          // if there are no more, skip
          if (!hasMore.current) {
            return Container();
          }

          // if it's already fetching more, skip
          if (!isFetching.current) {
            isFetching.current = true;
            fetchMore(page, batchSize).then((newData) {
              // if got less than the batchSize, mark the list as done
              if (newData.length < batchSize) {
                hasMore.current = false;
              }
              // append new data and increment page count
              data.value = [...data.value, ...newData];
            }).whenComplete(() => isFetching.current = false);
          }

          return loadingWidget;
        }

        // not last element, render list item
        return builder(data.value[i]);
      },
    );
  }
}

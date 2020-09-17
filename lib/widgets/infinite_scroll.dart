import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InfiniteScroll<T> extends HookWidget {
  final int batchSize;
  final Widget loadingWidget;
  final Widget Function(T data) builder;
  final Future<List<T>> Function(int page, int batchSize) fetchMore;

  InfiniteScroll({
    this.batchSize = 10,
    this.loadingWidget =
        const ListTile(title: Center(child: CircularProgressIndicator())),
    this.builder,
    this.fetchMore,
  })  : assert(builder != null),
        assert(fetchMore != null);

  @override
  Widget build(BuildContext context) {
    final page = useState(1);
    final hasMore = useState(true);
    final data = useState<List<T>>([]);

    return ListView.builder(
      // +1 for the loading widget
      itemCount: data.value.length + 1,
      itemBuilder: (_, i) {
        // reached the bottom, fetch more
        if (i == data.value.length) {
          // if there are no more, skip
          if (!hasMore.value) {
            return Container();
          }

          fetchMore(page.value, batchSize).then((value) {
            // if got less than the batchSize, mark the list as done
            if (value.length < batchSize) {
              hasMore.value = false;
            }
            // append new data and increment page count
            data.value.addAll(value);
            page.value++;
          });

          return loadingWidget;
        }

        // not last element, render list item
        return builder(data.value[i]);
      },
    );
  }
}

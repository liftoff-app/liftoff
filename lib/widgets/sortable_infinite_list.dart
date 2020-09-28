import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmur/widgets/post.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/infinite_scroll.dart';
import 'infinite_scroll.dart';
import 'post_list_options.dart';

/// Infinite list of posts
class SortableInfiniteList<T> extends HookWidget {
  final Future<List<T>> Function(int page, int batchSize, SortType sortType)
      fetcher;
  final Widget Function(T) builder;
  final Function onStyleChange;

  SortableInfiniteList({
    @required this.fetcher,
    @required this.builder,
    this.onStyleChange,
  })  : assert(fetcher != null),
        assert(builder != null);

  @override
  Widget build(BuildContext context) {
    final isc = useInfiniteScrollController();
    final sort = useState(SortType.active);

    void changeSorting(SortType newSort) {
      sort.value = newSort;
      isc.clear();
    }

    return InfiniteScroll<T>(
      prepend: PostListOptions(
        onChange: changeSorting,
        defaultSort: SortType.active,
        styleButton: onStyleChange != null,
      ),
      builder: builder,
      padding: EdgeInsets.zero,
      fetchMore: (page, batchSize) => fetcher(page, batchSize, sort.value),
      controller: isc,
      batchSize: 20,
    );
  }
}

class InfinitePostList extends StatelessWidget {
  final Future<List<PostView>> Function(
      int page, int batchSize, SortType sortType) fetcher;

  InfinitePostList({this.fetcher});

  Widget build(BuildContext context) {
    return SortableInfiniteList<PostView>(
      onStyleChange: () {},
      builder: (post) => Column(
        children: [
          Post(post),
          SizedBox(height: 20),
        ],
      ),
      fetcher: fetcher,
    );
  }
}

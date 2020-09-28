import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/infinite_scroll.dart';
import 'infinite_scroll.dart';
import 'post.dart';
import 'post_list_options.dart';

/// Infinite list of posts
class InfinitePostList extends HookWidget {
  final Future<List<PostView>> Function(
      int page, int batchSize, SortType sortType) fetcher;

  InfinitePostList({@required this.fetcher}) : assert(fetcher != null);

  @override
  Widget build(BuildContext context) {
    final isc = useInfiniteScrollController();
    final sort = useState(SortType.active);

    void changeSorting(SortType newSort) {
      sort.value = newSort;
      isc.clear();
    }

    return InfiniteScroll<PostView>(
      prepend: PostListOptions(
        onChange: changeSorting,
        defaultSort: SortType.active,
      ),
      builder: (post) => Column(
        children: [
          Post(post),
          SizedBox(height: 20),
        ],
      ),
      padding: EdgeInsets.zero,
      fetchMore: (page, batchSize) => fetcher(page, batchSize, sort.value),
      controller: isc,
      // batchSize: 20,
    );
  }
}

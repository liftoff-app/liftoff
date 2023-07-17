import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../resources/app_theme.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
import 'infinite_scroll.dart';
import 'post/post.dart';
import 'post/post_store.dart';
import 'post_list_options.dart';
import 'sortable_infinite_list.dart';

class PostListV2 extends HookWidget {
  /// Function that fetches posts from the server.
  /// This *must* be memoized. The widget will refresh
  /// all the content if the function instance changes.
  final FetcherWithSorting<PostStore> fetcher;
  final InfiniteScrollController? infiniteScrollController;

  const PostListV2({
    required this.fetcher,
    this.infiniteScrollController,
  });

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigStore>(context);
    final sort = useState(config.defaultSortType);

    // controller stores the data, so we need to keep it persistent between rebuilds.
    final pagingController =
        useMemoized(() => PagingController<int, PostStore>(firstPageKey: 1));

    // We need cache the instance of the listener,
    // so we can remove it later.
    final listener = useCallback((page) async {
      final posts = await fetcher(page, 10, sort.value);
      if (posts.isEmpty) {
        pagingController.appendLastPage([]);
      } else {
        pagingController.appendPage(posts, page + 1);
      }
    }, [fetcher]);

    useEffect(() {
      pagingController.addPageRequestListener(listener);
      return () {
        pagingController
          ..removePageRequestListener(listener)
          ..refresh();
      };
    }, [listener]);

    useEffect(() {
      infiniteScrollController?.clear = pagingController.refresh;
      infiniteScrollController?.scrollToTop = () =>
          PrimaryScrollController.of(context).animateTo(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);

      // dispose the old controller if we get a new one or the widget is disposed
      return () => pagingController
        ..removePageRequestListener(listener)
        ..dispose();
    }, [pagingController]);

    return CustomScrollView(slivers: <Widget>[
      SliverToBoxAdapter(
          child: PostListOptions(
        sortValue: sort.value,
        onSortChanged: (sortType) {
          sort.value = sortType;
          pagingController.refresh();
        },
      )),
      PagedSliverList<int, PostStore>.separated(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<PostStore>(
              itemBuilder: (context, item, index) {
            final read = context.read<ConfigStore>();
            return Column(
              children: [
                PostTile.fromPostStore(item, fullPost: false),
                SizedBox(height: read.compactPostView ? 2 : 10),
              ],
            );
          }),
          separatorBuilder: (BuildContext context, int index) =>
              Consumer<AppTheme>(
                  builder: (context, theme, child) => (theme.useAmoled)
                      ? SizedBox(
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
                        )
                      : const SizedBox.shrink()))
    ]);
  }
}

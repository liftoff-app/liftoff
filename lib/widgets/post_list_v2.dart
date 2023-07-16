import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:liftoff/widgets/post_list_options.dart';
import 'package:logging/logging.dart';

import '../resources/app_theme.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
import 'infinite_scroll.dart';
import 'post/post.dart';
import 'post/post_store.dart';
import 'sortable_infinite_list.dart';

final _logger = Logger('post_list_v2');

class PostListV2 extends HookWidget {
  final FetcherWithSorting<PostStore> _fetcher;
  final InfiniteScrollController infiniteScrollController;

  /// if contentKey is provided, the list will be refreshed
  /// when the contentKey changes
  final dynamic contentKey;

  FetcherWithSorting<PostStore> get fetcher => _fetcher;

  const PostListV2({
    required FetcherWithSorting<PostStore> fetcher,
    required this.infiniteScrollController,
    this.contentKey,
  }) : _fetcher = fetcher;

  @override
  Widget build(BuildContext context) {
    final config = Provider.of<ConfigStore>(context);
    final sort = useState(config.defaultSortType);

    final scrollController = useScrollController();
    infiniteScrollController.scrollToTop = () => scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

    // controller stores the data, so we need to keep it
    // persistent between rebuilds.
    final pagingController = useMemoized(() {
      _logger.info('creating new paging controller');
      final controller = PagingController<int, PostStore>(firstPageKey: 1);

      infiniteScrollController.clear = controller.refresh;

      return controller;
    });

    final listener = useCallback((page) async {
      _logger.info('fetching page $page with sort $sort');
      final posts = await _fetcher(page, 10, sort.value);
      if (posts.isEmpty) {
        pagingController.appendLastPage([]);
      } else {
        pagingController.appendPage(posts, page + 1);
      }
    }, [contentKey]);
    useEffect(() {
      pagingController.addPageRequestListener(listener);
      return () => pagingController.removePageRequestListener(listener);
    }, [listener]);

    // dispose the old controller if we get a new one or the widget is disposed
    useEffect(() => pagingController.dispose, [pagingController]);
    useValueChanged(
        contentKey, (oldValue, oldResult) => pagingController.refresh());

    return CustomScrollView(controller: scrollController, slivers: <Widget>[
      // PostListOptions(
      //   sortValue: sort.value,
      //   onSortChanged: (sortType) {
      //     sort.value = sortType;
      //     pagingController.refresh();
      //   },
      // ),
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

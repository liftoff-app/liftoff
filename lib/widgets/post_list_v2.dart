import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lemmy_api_client/v3.dart';

import '../resources/app_theme.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
import 'post/post.dart';
import 'post/post_store.dart';
import 'sortable_infinite_list.dart';

PagingController useMyController(PagingController Function() constructor) {
  final controller = useMemoized(constructor, []);
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

class PostListV2 extends HookWidget {
  final FetcherWithSorting<PostView> fetcher;

  const PostListV2({
    required this.fetcher,
  });

  @override
  Widget build(BuildContext context) {
    final pagingController = useMemoized(() {
      final controller = PagingController<int, PostStore>(firstPageKey: 1);
      controller.addPageRequestListener((pageKey) async {
        final newItems = await fetcher(pageKey, 10, SortType.active);
        controller.appendPage(
            newItems.map(PostStore.new).toList(), pageKey + 1);
      });
      return controller;
    });

    return PagedListView.separated(
        pagingController: pagingController,
        
        builderDelegate: PagedChildBuilderDelegate<PostStore>(
            itemBuilder: (context, item, index) {
          final read = context.read<ConfigStore>();
          return Column(
            children: [
              PostTile.fromPostStore(item),
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
                    : const SizedBox.shrink()));
  }
}

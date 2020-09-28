import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/infinite_scroll.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/markdown_text.dart';
import '../widgets/post_list_options.dart';

class CommunitiesListPage extends StatelessWidget {
  final String title;
  final Future<List<CommunityView>> Function(
    int page,
    int batchSize,
    SortType sortType,
  ) fetcher;

  const CommunitiesListPage({Key key, @required this.fetcher, this.title})
      : assert(fetcher != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? '', style: theme.textTheme.headline6),
        centerTitle: true,
        backgroundColor: theme.cardColor,
        iconTheme: theme.iconTheme,
      ),
      body: InfiniteCommunitiesList(fetcher: fetcher),
    );
  }
}

/// Infinite list of posts
class InfiniteCommunitiesList extends HookWidget {
  final Future<List<CommunityView>> Function(
      int page, int batchSize, SortType sortType) fetcher;

  InfiniteCommunitiesList({@required this.fetcher}) : assert(fetcher != null);

  @override
  Widget build(BuildContext context) {
    final isc = useInfiniteScrollController();
    final sort = useState(SortType.active);

    void changeSorting(SortType newSort) {
      sort.value = newSort;
      isc.clear();
    }

    return InfiniteScroll<CommunityView>(
      prepend: PostListOptions(
        onChange: changeSorting,
        styleButton: false,
      ),
      builder: (community) => Column(
        children: [
          Divider(),
          ListTile(
            title: Text(community.name),
            subtitle: community.description != null
                ? Opacity(
                    opacity: 0.5,
                    child: MarkdownText(
                      community.description,
                      instanceUrl: community.instanceUrl,
                    ),
                  )
                : null,
            onTap: () => goToCommunity.byId(
                context, community.instanceUrl, community.id),
            leading: community.icon != null
                ? CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: community.icon,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider),
                      ),
                    ),
                    errorWidget: (_, __, ___) => SizedBox(width: 50),
                  )
                : SizedBox(width: 50),
            // TODO: add trailing button for un/subscribing to communities
          ),
        ],
      ),
      padding: EdgeInsets.zero,
      fetchMore: (page, batchSize) => fetcher(page, batchSize, sort.value),
      controller: isc,
      batchSize: 20,
    );
  }
}

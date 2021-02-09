import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v2.dart';

import '../util/goto.dart';
import '../widgets/markdown_text.dart';
import '../widgets/sortable_infinite_list.dart';

/// Infinite list of Communities fetched by the given fetcher
class CommunitiesListPage extends StatelessWidget {
  final String title;
  final Future<List<CommunityView>> Function(
    int page,
    int batchSize,
    SortType sortType,
  ) fetcher;

  const CommunitiesListPage({Key key, @required this.fetcher, this.title = ''})
      : assert(fetcher != null),
        assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text(title),
      ),
      body: SortableInfiniteList<CommunityView>(
        fetcher: fetcher,
        builder: (community) => Column(
          children: [
            const Divider(),
            CommunitiesListItem(
              community: community,
            )
          ],
        ),
      ),
    );
  }
}

class CommunitiesListItem extends StatelessWidget {
  final CommunityView community;

  const CommunitiesListItem({Key key, @required this.community})
      : assert(community != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(community.community.name),
        subtitle: community.community.description != null
            ? Opacity(
                opacity: 0.7,
                child: MarkdownText(
                  community.community.description,
                  instanceHost: community.instanceHost,
                ),
              )
            : null,
        onTap: () => goToCommunity.byId(
            context, community.instanceHost, community.community.id),
        leading: community.community.icon != null
            ? CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: community.community.icon,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: imageProvider),
                  ),
                ),
                errorWidget: (_, __, ___) => const SizedBox(width: 50),
              )
            : const SizedBox(width: 50),
      );
}

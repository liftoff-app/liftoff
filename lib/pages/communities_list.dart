import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/markdown_text.dart';
import '../widgets/sortable_infinite_list.dart';

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
        brightness: theme.brightness,
        title: Text(title ?? '', style: theme.textTheme.headline6),
        centerTitle: true,
        backgroundColor: theme.cardColor,
        iconTheme: theme.iconTheme,
      ),
      body: SortableInfiniteList<CommunityView>(
        fetcher: fetcher,
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
      ),
    );
  }
}

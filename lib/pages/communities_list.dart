import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/markdown_text.dart';

class CommunitiesListPage extends StatelessWidget {
  final String title;
  final List<CommunityView> communities;

  const CommunitiesListPage({Key key, @required this.communities, this.title})
      : assert(communities != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // TODO: abillity to load more, right now its 10 - default page size
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? '', style: theme.textTheme.headline6),
          centerTitle: true,
          backgroundColor: theme.cardColor,
          iconTheme: theme.iconTheme,
        ),
        body: ListView.builder(
          itemBuilder: (context, i) => ListTile(
            title: Text(communities[i].name),
            subtitle: communities[i].description != null
                ? Opacity(
                    opacity: 0.5,
                    child: MarkdownText(
                      communities[i].description,
                      instanceUrl: communities[i].instanceUrl,
                    ),
                  )
                : null,
            onTap: () => goToCommunity.byId(
                context, communities[i].instanceUrl, communities[i].id),
            leading: communities[i].icon != null
                ? CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: communities[i].icon,
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
          itemCount: communities.length,
        ));
  }
}

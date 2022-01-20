import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/context.dart';
import '../../util/icons.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../util/share.dart';
import '../../util/text_color.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/failed_to_load.dart';
import '../../widgets/fullscreenable_image.dart';
import '../../widgets/reveal_after_scroll.dart';
import '../../widgets/sortable_infinite_list.dart';
import 'instance_about_tab.dart';
import 'instance_more_menu.dart';
import 'instance_store.dart';

/// Displays posts, comments, and general info about the given instance
class InstancePage extends HookWidget {
  const InstancePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorOnCard = textColorBasedOnBackground(theme.cardColor);
    final scrollController = useScrollController();

    return ObserverBuilder<InstanceStore>(
      builder: (context, store) {
        final instanceUrl = 'https://${store.instanceHost}';

        return store.siteState.map(
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator.adaptive()),
          ),
          error: (errorTerm) => Scaffold(
            appBar: AppBar(),
            body: Center(
              child: FailedToLoad(
                refresh: () => store.fetch(
                  context.defaultJwt(store.instanceHost),
                ),
                message: errorTerm.tr(context),
              ),
            ),
          ),
          data: (site) {
            final siteView = site.siteView;

            if (siteView == null) {
              return Scaffold(
                appBar: AppBar(),
                body: Center(child: Text(L10n.of(context).site_not_set_up)),
              );
            }

            return Scaffold(
              body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      expandedHeight: 250,
                      pinned: true,
                      backgroundColor: theme.cardColor,
                      title: RevealAfterScroll(
                        after: 150,
                        fade: true,
                        scrollController: scrollController,
                        child: Text(
                          siteView.site.name,
                          style: TextStyle(color: colorOnCard),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(shareIcon),
                          onPressed: () => share(instanceUrl, context: context),
                        ),
                        IconButton(
                          icon: Icon(moreIcon),
                          onPressed: () => InstanceMoreMenu.open(context, site),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            if (siteView.site.banner != null)
                              FullscreenableImage(
                                url: siteView.site.banner!,
                                child: CachedNetworkImage(
                                  imageUrl: siteView.site.banner!,
                                  errorBuilder: (_, ___) => const SizedBox(),
                                ),
                              ),
                            SafeArea(
                              child: Center(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40),
                                      child: siteView.site.icon == null
                                          ? const SizedBox(
                                              height: 100,
                                              width: 100,
                                            )
                                          : FullscreenableImage(
                                              url: siteView.site.icon!,
                                              child: CachedNetworkImage(
                                                width: 100,
                                                height: 100,
                                                imageUrl: siteView.site.icon!,
                                                errorBuilder: (_, ___) =>
                                                    const Icon(Icons.warning),
                                              ),
                                            ),
                                    ),
                                    Text(
                                      siteView.site.name,
                                      style: theme.textTheme.headline6,
                                    ),
                                    Text(
                                      store.instanceHost,
                                      style: theme.textTheme.caption,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const TabBar(tabs: []).preferredSize,
                        child: Material(
                          color: theme.cardColor,
                          child: TabBar(
                            tabs: [
                              Tab(text: L10n.of(context).posts),
                              Tab(text: L10n.of(context).comments),
                              Tab(text: L10n.of(context).about),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  body: TabBarView(
                    children: [
                      InfinitePostList(
                        fetcher: (page, batchSize, sort) =>
                            LemmyApiV3(store.instanceHost).run(GetPosts(
                          // TODO: switch between all and subscribed
                          type: PostListingType.all,
                          sort: sort,
                          limit: batchSize,
                          page: page,
                          savedOnly: false,
                          auth: context.defaultJwt(store.instanceHost)?.raw,
                        )),
                      ),
                      InfiniteCommentList(
                        fetcher: (page, batchSize, sort) =>
                            LemmyApiV3(store.instanceHost).run(GetComments(
                          type: CommentListingType.all,
                          sort: sort,
                          limit: batchSize,
                          page: page,
                          savedOnly: false,
                          auth: context.defaultJwt(store.instanceHost)?.raw,
                        )),
                      ),
                      InstanceAboutTab(
                        site: site,
                        siteView: siteView,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Route route(String instanceHost) {
    return MaterialPageRoute(
      builder: (context) {
        return MobxProvider(
          create: (context) => InstanceStore(instanceHost)
            ..fetch(context.defaultJwt(instanceHost)),
          child: const InstancePage(),
        );
      },
    );
  }
}

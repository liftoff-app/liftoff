import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/context.dart';
import '../../util/extensions/spaced.dart';
import '../../util/goto.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/avatar.dart';
import '../../widgets/failed_to_load.dart';
import '../../widgets/markdown_text.dart';
import '../../widgets/pull_to_refresh.dart';
import '../../widgets/user_tile.dart';
import '../communities_list.dart';
import '../community/community.dart';
import '../modlog/modlog.dart';
import 'instance_store.dart';

class InstanceAboutTab extends HookWidget {
  final FullSiteView site;
  final SiteView siteView;

  const InstanceAboutTab({required this.site, required this.siteView});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    void goToCommunities() {
      goTo(
        context,
        (_) => CommunitiesListPage(
          fetcher: (page, batchSize, sortType) =>
              LemmyApiV3(site.instanceHost).run(
            ListCommunities(
              type: PostListingType.local,
              sort: sortType,
              limit: batchSize,
              page: page,
              auth: context.defaultJwt(site.instanceHost)?.raw,
            ),
          ),
          title: l10n.communities_of_instance(siteView.site.name),
        ),
      );
    }

    return PullToRefresh(
      onRefresh: () => context
          .read<InstanceStore>()
          .fetch(context.defaultJwt(site.instanceHost), refresh: true),
      child: SingleChildScrollView(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              if (siteView.site.description != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: MarkdownText(
                    siteView.site.description!,
                    instanceHost: site.instanceHost,
                  ),
                ),
                const _Divider(),
              ],
              SizedBox(
                height: 32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    Chip(
                      label: Text(
                        l10n.number_of_users_online(site.online),
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${l10n.number_of_users(siteView.counts.usersActiveDay)} / ${l10n.day}',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${l10n.number_of_users(siteView.counts.usersActiveWeek)} / ${l10n.week}',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${l10n.number_of_users(siteView.counts.usersActiveMonth)} / ${l10n.month}',
                      ),
                    ),
                    Chip(
                      label: Text(
                        '${l10n.number_of_users(siteView.counts.usersActiveHalfYear)} / ${l10n.six_months}',
                      ),
                    ),
                    Chip(
                      label: Text(
                        l10n.number_of_users(siteView.counts.users),
                      ),
                    ),
                    Chip(
                      label: Text(
                        l10n.number_of_communities(siteView.counts.communities),
                      ),
                    ),
                    Chip(
                      label: Text(
                        l10n.number_of_posts(siteView.counts.posts),
                      ),
                    ),
                    Chip(
                      label: Text(
                        l10n.number_of_comments(siteView.counts.comments),
                      ),
                    ),
                  ].spaced(8),
                ),
              ),
              const _Divider(),
              ListTile(
                title: Center(
                  child: Text(
                    l10n.trending_communities,
                    style: theme.textTheme.headline6?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              ObserverBuilder<InstanceStore>(
                builder: (context, store) => store.communitiesState.map(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  error: (errorTerm) => FailedToLoad(
                    refresh: () => store.fetchCommunites(
                        context.defaultJwt(store.instanceHost)),
                    message: errorTerm.tr(context),
                  ),
                  data: (communities) => Column(
                    children: [
                      for (final c in communities)
                        ListTile(
                          onTap: () => Navigator.of(context).push(
                            CommunityPage.fromIdRoute(
                              store.instanceHost,
                              c.community.id,
                            ),
                          ),
                          title: Text(c.community.name),
                          leading: Avatar(url: c.community.icon),
                        )
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Center(child: Text(l10n.see_all)),
                onTap: goToCommunities,
              ),
              const _Divider(),
              ListTile(
                title: Center(
                  child: Text(
                    l10n.admins,
                    style: theme.textTheme.headline6?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              for (final u in site.admins)
                PersonTile(
                  u.person,
                  expanded: true,
                ),
              const _Divider(),
              ListTile(
                title: Center(child: Text(l10n.modlog)),
                onTap: () => Navigator.of(context).push(
                  ModlogPage.forInstanceRoute(site.instanceHost),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Divider(),
    );
  }
}

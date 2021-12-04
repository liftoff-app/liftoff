import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/extensions/spaced.dart';
import '../util/goto.dart';
import '../util/icons.dart';
import '../util/share.dart';
import '../util/text_color.dart';
import '../widgets/avatar.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/cached_network_image.dart';
import '../widgets/fullscreenable_image.dart';
import '../widgets/info_table_popup.dart';
import '../widgets/markdown_text.dart';
import '../widgets/reveal_after_scroll.dart';
import '../widgets/sortable_infinite_list.dart';
import '../widgets/user_tile.dart';
import 'communities_list.dart';
import 'modlog/modlog.dart';
import 'users_list.dart';

/// Displays posts, comments, and general info about the given instance
class InstancePage extends HookWidget {
  final String instanceHost;
  final Future<FullSiteView> siteFuture;
  final Future<List<CommunityView>> communitiesFuture;

  InstancePage({required this.instanceHost})
      : siteFuture = LemmyApiV3(instanceHost).run(const GetSite()),
        communitiesFuture = LemmyApiV3(instanceHost).run(const ListCommunities(
            type: PostListingType.local, sort: SortType.hot, limit: 6));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final siteSnap = useFuture(siteFuture);
    final colorOnCard = textColorBasedOnBackground(theme.cardColor);
    final accStore = useAccountsStore();
    final scrollController = useScrollController();

    if (!siteSnap.hasData || siteSnap.data!.siteView == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (siteSnap.hasError) ...[
                const Icon(Icons.error),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('ERROR: ${siteSnap.error}'),
                )
              ] else if (siteSnap.hasData && siteSnap.data!.siteView == null)
                const Text('ERROR')
              else
                const CircularProgressIndicator.adaptive(
                    semanticsLabel: 'loading')
            ],
          ),
        ),
      );
    }

    final site = siteSnap.data!;
    final siteView = site.siteView!;

    void _share() => share('https://$instanceHost', context: context);

    void _openMoreMenu() {
      showBottomModal(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open in browser'),
              onTap: () async => await ul
                      .canLaunch('https://${site.instanceHost}')
                  ? ul.launch('https://${site.instanceHost}')
                  : ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("can't open in browser"))),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Nerd stuff'),
              onTap: () {
                showInfoTablePopup(context: context, table: site.toJson());
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
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
                IconButton(icon: Icon(shareIcon), onPressed: _share),
                IconButton(icon: Icon(moreIcon), onPressed: _openMoreMenu),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: [
                  if (siteView.site.banner != null)
                    FullscreenableImage(
                      url: siteView.site.banner!,
                      child: CachedNetworkImage(
                        imageUrl: siteView.site.banner!,
                        errorBuilder: (_, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: siteView.site.icon == null
                                ? const SizedBox(height: 100, width: 100)
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
                          Text(siteView.site.name,
                              style: theme.textTheme.headline6),
                          Text(instanceHost, style: theme.textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              bottom: PreferredSize(
                preferredSize: const TabBar(tabs: []).preferredSize,
                child: Material(
                  color: theme.cardColor,
                  child: TabBar(
                    tabs: [
                      Tab(text: L10n.of(context).posts),
                      Tab(text: L10n.of(context).comments),
                      const Tab(text: 'About'),
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
                      LemmyApiV3(instanceHost).run(GetPosts(
                        // TODO: switch between all and subscribed
                        type: PostListingType.all,
                        sort: sort,
                        limit: batchSize,
                        page: page,
                        savedOnly: false,
                        auth:
                            accStore.defaultUserDataFor(instanceHost)?.jwt.raw,
                      ))),
              InfiniteCommentList(
                  fetcher: (page, batchSize, sort) =>
                      LemmyApiV3(instanceHost).run(GetComments(
                        type: CommentListingType.all,
                        sort: sort,
                        limit: batchSize,
                        page: page,
                        savedOnly: false,
                        auth:
                            accStore.defaultUserDataFor(instanceHost)?.jwt.raw,
                      ))),
              _AboutTab(site,
                  communitiesFuture: communitiesFuture,
                  instanceHost: instanceHost),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutTab extends HookWidget {
  final FullSiteView site;
  final Future<List<CommunityView>> communitiesFuture;
  final String instanceHost;

  const _AboutTab(
    this.site, {
    required this.communitiesFuture,
    required this.instanceHost,
  });

  void goToBannedUsers(BuildContext context) {
    goTo(
      context,
      (_) => UsersListPage(
        users: site.banned.reversed.toList(),
        title: L10n.of(context).banned_users,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commSnap = useFuture(communitiesFuture);
    final accStore = useAccountsStore();

    void goToCommunities() {
      goTo(
        context,
        (_) => CommunitiesListPage(
          fetcher: (page, batchSize, sortType) => LemmyApiV3(instanceHost).run(
            ListCommunities(
              type: PostListingType.local,
              sort: sortType,
              limit: batchSize,
              page: page,
              auth: accStore.defaultUserDataFor(instanceHost)?.jwt.raw,
            ),
          ),
          title: 'Communities of ${site.siteView?.site.name}',
        ),
      );
    }

    final siteView = site.siteView;

    if (siteView == null) {
      return const SingleChildScrollView(
          child: Center(
              child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('error'),
      )));
    }

    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            if (siteView.site.description != null) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: MarkdownText(
                  siteView.site.description!,
                  instanceHost: instanceHost,
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
                      label: Text(L10n.of(context)
                          .number_of_users_online(site.online))),
                  Chip(
                      label: Text(
                          '${siteView.counts.usersActiveDay} users / day')),
                  Chip(
                      label: Text(
                          '${siteView.counts.usersActiveWeek} users / week')),
                  Chip(
                      label: Text(
                          '${siteView.counts.usersActiveMonth} users / month')),
                  Chip(
                      label: Text(
                          '${siteView.counts.usersActiveHalfYear} users / 6 months')),
                  Chip(
                      label: Text(L10n.of(context)
                          .number_of_users(siteView.counts.users))),
                  Chip(
                      label:
                          Text('${siteView.counts.communities} communities')),
                  Chip(label: Text('${siteView.counts.posts} posts')),
                  Chip(label: Text('${siteView.counts.comments} comments')),
                ].spaced(8),
              ),
            ),
            const _Divider(),
            ListTile(
              title: Center(
                child: Text(
                  'Trending communities:',
                  style: theme.textTheme.headline6?.copyWith(fontSize: 18),
                ),
              ),
            ),
            if (commSnap.hasData)
              for (final c in commSnap.data!)
                ListTile(
                  onTap: () => goToCommunity.byId(
                      context, c.instanceHost, c.community.id),
                  title: Text(c.community.name),
                  leading: Avatar(url: c.community.icon),
                )
            else if (commSnap.hasError)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("Can't load communities, ${commSnap.error}"),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator.adaptive(),
              ),
            ListTile(
              title: const Center(child: Text('See all')),
              onTap: goToCommunities,
            ),
            const _Divider(),
            ListTile(
              title: Center(
                child: Text(
                  'Admins:',
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
              title: Center(child: Text(L10n.of(context).banned_users)),
              onTap: () => goToBannedUsers(context),
            ),
            ListTile(
              title: Center(child: Text(L10n.of(context).modlog)),
              onTap: () => Navigator.of(context).push(
                ModlogPage.forInstanceRoute(instanceHost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Divider(),
      );
}

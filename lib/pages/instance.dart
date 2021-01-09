import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import '../util/more_icon.dart';
import '../util/text_color.dart';
import '../widgets/badge.dart';
import '../widgets/fullscreenable_image.dart';
import '../widgets/info_table_popup.dart';
import '../widgets/markdown_text.dart';
import '../widgets/sortable_infinite_list.dart';
import 'communities_list.dart';
import 'users_list.dart';

/// Displays posts, comments, and general info about the given instance
class InstancePage extends HookWidget {
  final String instanceHost;
  final Future<FullSiteView> siteFuture;
  final Future<List<CommunityView>> communitiesFuture;

  void _share() =>
      Share.text('Share instance', 'https://$instanceHost', 'text/plain');

  InstancePage({@required this.instanceHost})
      : assert(instanceHost != null),
        siteFuture = LemmyApi(instanceHost).v1.getSite(),
        communitiesFuture =
            LemmyApi(instanceHost).v1.listCommunities(sort: SortType.hot);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final siteSnap = useFuture(siteFuture);
    final colorOnCard = textColorBasedOnBackground(theme.cardColor);
    final accStore = useAccountsStore();

    if (!siteSnap.hasData) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: theme.iconTheme,
          brightness: theme.brightness,
          backgroundColor: theme.cardColor,
          elevation: 0,
        ),
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
              ] else
                const CircularProgressIndicator(semanticsLabel: 'loading')
            ],
          ),
        ),
      );
    }

    final site = siteSnap.data;

    void _openMoreMenu(BuildContext c) {
      showInfoTablePopup(context, {
        'url': instanceHost,
        'creator': '@${site.site.creatorName}',
        'version': site.version,
        'enableDownvotes': site.site.enableDownvotes,
        'enableNsfw': site.site.enableNsfw,
        'published': site.site.published,
        'updated': site.site.updated,
      });
    }

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              brightness: theme.brightness,
              expandedHeight: 200,
              pinned: true,
              elevation: 0,
              backgroundColor: theme.cardColor,
              iconTheme: theme.iconTheme,
              title: Text(
                site.site.name,
                style: TextStyle(color: colorOnCard),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.share), onPressed: _share),
                IconButton(
                    icon: Icon(moreIcon),
                    onPressed: () => _openMoreMenu(context)),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(children: [
                  if (site.site.banner != null)
                    FullscreenableImage(
                      url: site.site.banner,
                      child: CachedNetworkImage(
                        imageUrl: site.site.banner,
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: site.site.icon == null
                                ? const SizedBox(height: 100, width: 100)
                                : FullscreenableImage(
                                    url: site.site.icon,
                                    child: CachedNetworkImage(
                                      width: 100,
                                      height: 100,
                                      imageUrl: site.site.icon,
                                      errorWidget: (_, __, ___) =>
                                          const Icon(Icons.warning),
                                    ),
                                  ),
                          ),
                          Text(site.site.name,
                              style: theme.textTheme.headline6),
                          Text(instanceHost, style: theme.textTheme.caption)
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelColor: theme.textTheme.bodyText1.color,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: 'About'),
                  ],
                ),
              ),
              pinned: true,
            ),
          ],
          body: TabBarView(
            children: [
              InfinitePostList(
                  fetcher: (page, batchSize, sort) =>
                      LemmyApi(instanceHost).v1.getPosts(
                            // TODO: switch between all and subscribed
                            type: PostListingType.all,
                            sort: sort,
                            limit: batchSize,
                            page: page,
                            auth: accStore.defaultTokenFor(instanceHost)?.raw,
                          )),
              InfiniteCommentList(
                  fetcher: (page, batchSize, sort) =>
                      LemmyApi(instanceHost).v1.getComments(
                            type: CommentListingType.all,
                            sort: sort,
                            limit: batchSize,
                            page: page,
                            auth: accStore.defaultTokenFor(instanceHost)?.raw,
                          )),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  const _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Container(color: theme.cardColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class _AboutTab extends HookWidget {
  final FullSiteView site;
  final Future<List<CommunityView>> communitiesFuture;
  final String instanceHost;

  const _AboutTab(this.site,
      {@required this.communitiesFuture, @required this.instanceHost})
      : assert(communitiesFuture != null),
        assert(instanceHost != null);

  void goToUser(int id) {
    print('GO TO USER $id');
  }

  void goToModLog() {
    print('GO TO MODLOG');
  }

  void goToBannedUsers(BuildContext c) {
    goTo(
      c,
      (_) => UsersListPage(
          users: site.banned.reversed.toList(), title: 'Banned users'),
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
          fetcher: (page, batchSize, sortType) =>
              LemmyApi(instanceHost).v1.listCommunities(
                    sort: sortType,
                    limit: batchSize,
                    page: page,
                    auth: accStore.defaultTokenFor(instanceHost)?.raw,
                  ),
          title: 'Communities of ${site.site.name}',
        ),
      );
    }

    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: MarkdownText(
                site.site.description,
                instanceHost: instanceHost,
              ),
            ),
            const _Divider(),
            SizedBox(
              height: 25,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 7),
                  const _Badge('X users online'),
                  _Badge('${site.site.numberOfUsers} users'),
                  _Badge('${site.site.numberOfCommunities} communities'),
                  _Badge('${site.site.numberOfPosts} posts'),
                  _Badge('${site.site.numberOfComments} comments'),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            const _Divider(),
            ListTile(
              title: Center(
                child: Text(
                  'Trending communities:',
                  style: theme.textTheme.headline6.copyWith(fontSize: 18),
                ),
              ),
            ),
            if (commSnap.hasData)
              ...commSnap.data.take(6).map((e) => ListTile(
                    onTap: () =>
                        goToCommunity.byId(context, e.instanceHost, e.id),
                    title: Text(e.name),
                    leading: e.icon != null
                        ? CachedNetworkImage(
                            height: 50,
                            width: 50,
                            imageUrl: e.icon,
                            errorWidget: (_, __, ___) =>
                                const SizedBox(width: 50, height: 50),
                            imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: imageProvider,
                                    ),
                                  ),
                                ))
                        : const SizedBox(width: 50),
                  ))
            else if (commSnap.hasError)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text("Can't load communities, ${commSnap.error}"),
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
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
                  style: theme.textTheme.headline6.copyWith(fontSize: 18),
                ),
              ),
            ),
            ...site.admins.map((e) => ListTile(
                  title: Text((e.preferredUsername == null ||
                          e.preferredUsername.isEmpty)
                      ? '@${e.name}'
                      : e.preferredUsername),
                  subtitle: e.bio != null
                      ? MarkdownText(e.bio, instanceHost: instanceHost)
                      : null,
                  onTap: () => goToUser(e.id),
                  leading: e.avatar != null
                      ? CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: e.avatar,
                          errorWidget: (_, __, ___) =>
                              const SizedBox(width: 50, height: 50),
                          imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: imageProvider),
                                ),
                              ))
                      : const SizedBox(width: 50),
                )),
            const _Divider(),
            ListTile(
              title: const Center(child: Text('Banned users')),
              onTap: () => goToBannedUsers(context),
            ),
            ListTile(
              title: const Center(child: Text('Modlog')),
              onTap: goToModLog,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;

  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Badge(
        child: Text(
          text,
          style:
              TextStyle(color: textColorBasedOnBackground(theme.accentColor)),
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

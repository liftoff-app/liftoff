import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../util/intl.dart';
import '../util/more_icon.dart';
import '../util/text_color.dart';
import '../widgets/badge.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/fullscreenable_image.dart';
import '../widgets/info_table_popup.dart';
import '../widgets/markdown_text.dart';
import '../widgets/sortable_infinite_list.dart';

/// Displays posts, comments, and general info about the given community
class CommunityPage extends HookWidget {
  final CommunityView _community;
  final String instanceHost;
  final String communityName;
  final int communityId;

  CommunityPage.fromName({
    @required this.communityName,
    @required this.instanceHost,
  })  : assert(communityName != null),
        assert(instanceHost != null),
        communityId = null,
        _community = null;
  CommunityPage.fromId({
    @required this.communityId,
    @required this.instanceHost,
  })  : assert(communityId != null),
        assert(instanceHost != null),
        communityName = null,
        _community = null;
  CommunityPage.fromCommunityView(this._community)
      : instanceHost = _community.instanceHost,
        communityId = _community.id,
        communityName = _community.name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    final fullCommunitySnap = useMemoFuture(() {
      final token = accountsStore.defaultTokenFor(instanceHost);

      if (communityId != null) {
        return LemmyApi(instanceHost).v1.getCommunity(
              id: communityId,
              auth: token?.raw,
            );
      } else {
        return LemmyApi(instanceHost).v1.getCommunity(
              name: communityName,
              auth: token?.raw,
            );
      }
    });

    final colorOnCard = textColorBasedOnBackground(theme.cardColor);

    final community = () {
      if (fullCommunitySnap.hasData) {
        return fullCommunitySnap.data.community;
      } else if (_community != null) {
        return _community;
      } else {
        return null;
      }
    }();

    // FALLBACK

    if (community == null) {
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
              if (fullCommunitySnap.hasError) ...[
                Icon(Icons.error),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('ERROR: ${fullCommunitySnap.error}'),
                )
              ] else
                CircularProgressIndicator(semanticsLabel: 'loading')
            ],
          ),
        ),
      );
    }

    // FUNCTIONS
    void _share() =>
        Share.text('Share instance', community.actorId, 'text/plain');

    void _openMoreMenu() {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => BottomModal(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.open_in_browser),
                title: Text('Open in browser'),
                onTap: () async => await ul.canLaunch(community.actorId)
                    ? ul.launch(community.actorId)
                    : Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("can't open in browser"))),
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('Nerd stuff'),
                onTap: () {
                  showInfoTablePopup(context, {
                    'id': community.id,
                    'actorId': community.actorId,
                    'created by': '@${community.creatorName}',
                    'hot rank': community.hotRank,
                    'published': community.published,
                  });
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            // TODO: change top section to be more flexible
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: theme.cardColor,
              brightness: theme.brightness,
              iconTheme: theme.iconTheme,
              title: Text('!${community.name}',
                  style: TextStyle(color: colorOnCard)),
              actions: [
                IconButton(icon: Icon(Icons.share), onPressed: _share),
                IconButton(icon: Icon(moreIcon), onPressed: _openMoreMenu),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background:
                    _CommunityOverview(community, instanceHost: instanceHost),
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  labelColor: theme.textTheme.bodyText1.color,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
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
                    LemmyApi(community.instanceHost).v1.getPosts(
                          type: PostListingType.community,
                          sort: sort,
                          communityId: community.id,
                          page: page,
                          limit: batchSize,
                        ),
              ),
              InfiniteCommentList(
                  fetcher: (page, batchSize, sortType) =>
                      LemmyApi(community.instanceHost).v1.getComments(
                            communityId: community.id,
                            auth: accountsStore
                                .defaultTokenFor(community.instanceHost)
                                ?.raw,
                            type: CommentListingType.community,
                            sort: sortType,
                            limit: batchSize,
                            page: page,
                          )),
              _AboutTab(
                community: community,
                moderators: fullCommunitySnap.data?.moderators,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityOverview extends StatelessWidget {
  final CommunityView community;
  final String instanceHost;

  _CommunityOverview(
    this.community, {
    @required this.instanceHost,
  })  : assert(instanceHost != null),
        assert(goToInstance != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadow = BoxShadow(color: theme.canvasColor, blurRadius: 5);

    final icon = community.icon != null
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.7), blurRadius: 3)
                    ]),
              ),
              Container(
                width: 83,
                height: 83,
                child: FullscreenableImage(
                  url: community.icon,
                  child: CachedNetworkImage(
                    imageUrl: community.icon,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Icon(Icons.warning),
                  ),
                ),
              ),
            ],
          )
        : null;

    return Stack(children: [
      if (community.banner != null)
        FullscreenableImage(
          url: community.banner,
          child: CachedNetworkImage(
            imageUrl: community.banner,
            errorWidget: (_, __, ___) => SizedBox.shrink(),
          ),
        ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 45),
          child: Column(children: [
            if (community.icon != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Center(child: icon),
                ),
              ),
            // NAME
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RichText(
                overflow: TextOverflow.ellipsis, // TODO: fix overflowing
                text: TextSpan(
                  style: theme.textTheme.subtitle1.copyWith(shadows: [shadow]),
                  children: [
                    TextSpan(
                        text: '!',
                        style: TextStyle(fontWeight: FontWeight.w200)),
                    TextSpan(
                        text: community.name,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: '@',
                        style: TextStyle(fontWeight: FontWeight.w200)),
                    TextSpan(
                        text: community.originInstanceHost,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => goToInstance(
                              context, community.originInstanceHost)),
                  ],
                ),
              ),
            )),
            // TITLE/MOTTO
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
              child: Text(
                community.title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.w300, shadows: [shadow]),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  // INFO ICONS
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(Icons.people, size: 20),
                        ),
                        Text(compactNumber(community.numberOfSubscribers)),
                        Spacer(
                          flex: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Icon(Icons.record_voice_over, size: 20),
                        ),
                        Text('xx'), // TODO: display online users
                        Spacer(),
                      ],
                    ),
                  ),
                  _FollowButton(community),
                ],
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Container(child: _tabBar, color: theme.cardColor);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class _AboutTab extends StatelessWidget {
  final CommunityView community;
  final List<CommunityModeratorView> moderators;

  const _AboutTab({
    Key key,
    @required this.community,
    @required this.moderators,
  }) : super(key: key);

  void goToModlog() {
    print('GO TO MODLOG');
  }

  void goToCategories() {
    print('GO TO CATEGORIES');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.only(top: 20),
      children: [
        if (community.description != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MarkdownText(community.description,
                instanceHost: community.instanceHost),
          ),
          _Divider(),
        ],
        SizedBox(
          height: 25,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // TODO: consider using Chips
              Padding(
                padding: const EdgeInsets.only(left: 7),
                child: _Badge('X users online'),
              ),
              _Badge(
                  '''${community.numberOfSubscribers} subscriber${pluralS(community.numberOfSubscribers)}'''),
              _Badge(
                  '''${community.numberOfPosts} post${pluralS(community.numberOfPosts)}'''),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: _Badge(
                    '''${community.numberOfComments} comment${pluralS(community.numberOfComments)}'''),
              ),
            ],
          ),
        ),
        _Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: OutlineButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('${community.categoryName}'),
            onPressed: goToCategories,
          ),
        ),
        _Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: OutlineButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('Modlog'),
            onPressed: goToModlog,
          ),
        ),
        _Divider(),
        if (moderators != null && moderators.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('Mods:', style: theme.textTheme.subtitle2),
          ),
          for (final mod in moderators)
            ListTile(
              title: Text(mod.userPreferredUsername ?? '@${mod.userName}'),
              onTap: () => goToUser.byId(context, mod.instanceHost, mod.userId),
            ),
        ]
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final bool noPad;

  _Badge(this.text, {this.noPad = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: noPad ? const EdgeInsets.all(0) : const EdgeInsets.only(left: 8),
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
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Divider(),
      );
}

class _FollowButton extends HookWidget {
  final CommunityView community;

  _FollowButton(this.community);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isSubbed = useState(community.subscribed ?? false);
    final delayed = useDelayedLoading(const Duration(milliseconds: 500));
    final loggedInAction = useLoggedInAction(community.instanceHost);

    final colorOnTopOfAccent = textColorBasedOnBackground(theme.accentColor);

    subscribe(Jwt token) async {
      delayed.start();
      try {
        await LemmyApi(community.instanceHost).v1.followCommunity(
            communityId: community.id,
            follow: !isSubbed.value,
            auth: token.raw);
        isSubbed.value = !isSubbed.value;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning),
              SizedBox(width: 10),
              Text("couldn't ${isSubbed.value ? 'un' : ''}sub :<"),
            ],
          ),
        ));
      }

      delayed.cancel();
    }

    return Center(
      child: SizedBox(
        height: 27,
        width: 160,
        child: delayed.loading
            ? RaisedButton(
                onPressed: null,
                child: SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              )
            : RaisedButton.icon(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                onPressed: loggedInAction(delayed.pending ? (_) {} : subscribe),
                icon: isSubbed.value
                    ? Icon(Icons.remove, size: 18, color: colorOnTopOfAccent)
                    : Icon(Icons.add, size: 18, color: colorOnTopOfAccent),
                color: theme.accentColor,
                label: Text(
                  '${isSubbed.value ? 'un' : ''}subscribe',
                  style: TextStyle(
                      color: colorOnTopOfAccent,
                      fontSize: theme.textTheme.subtitle1.fontSize),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
      ),
    );
  }
}

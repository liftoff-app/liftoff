import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/intl.dart';
import '../util/text_color.dart';
import '../widgets/badge.dart';
import '../widgets/markdown_text.dart';

class CommunityPage extends HookWidget {
  final Future<FullCommunityView> _fullCommunityFuture;
  final CommunityView _community;
  final String instanceUrl;

  void _goToInstance() {
    print('GO TO INSTANCE');
  }

  void _subscribe() {
    print('SUBSCRIBE');
  }

  void _share() {
    print('SHARE');
  }

  void _openMoreMenu() {
    print('OPEN MORE MENU');
  }

  void _goToUser(int id) {
    print('GO TO USER $id');
  }

  void _goToModlog() {
    print('GO TO MODLOG');
  }

  void _goToCategories() {
    print('GO RO CATEGORIES');
  }

  CommunityPage({@required String communityName, @required this.instanceUrl})
      : assert(communityName != null, instanceUrl != null),
        _fullCommunityFuture =
            LemmyApi(instanceUrl).v1.getCommunity(name: communityName),
        _community = null;
  CommunityPage.fromCommunityView(this._community)
      : instanceUrl = _community.actorId.split('/')[2],
        _fullCommunityFuture = LemmyApi(_community.actorId.split('/')[2])
            .v1
            .getCommunity(name: _community.name);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var fullCommunitySnap = useFuture(_fullCommunityFuture);

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

    if (community == null) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: theme.iconTheme,
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

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              // TODO: change top section to be more flexible
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: theme.cardColor,
                iconTheme: theme.iconTheme,
                title: Text('!${community.name}',
                    style: TextStyle(color: colorOnCard)),
                actions: [
                  IconButton(icon: Icon(Icons.share), onPressed: _share),
                  IconButton(
                      icon: Icon(Icons.more_vert), onPressed: _openMoreMenu),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _CommunityOverview(
                    community,
                    instanceUrl: instanceUrl,
                    goToInstance: _goToInstance,
                    subscribe: _subscribe,
                  ),
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
            ];
          },
          body: TabBarView(
            children: [
              ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Center(child: Text('posts go here')),
                ],
              ),
              ListView(
                padding: EdgeInsets.all(0),
                children: [
                  Center(child: Text('comments go here')),
                ],
              ),
              _AboutSection(
                community: community,
                moderators: fullCommunitySnap.data?.moderators,
                goToUser: _goToUser,
                goToModlog: _goToModlog,
                goToCategories: _goToCategories,
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
  final String instanceUrl;
  final void Function() goToInstance;
  final void Function() subscribe;

  _CommunityOverview(
    this.community, {
    @required this.instanceUrl,
    @required this.goToInstance,
    @required this.subscribe,
  })  : assert(instanceUrl != null),
        assert(goToInstance != null),
        assert(subscribe != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorOnTopOfAccent = textColorBasedOnBackground(theme.accentColor);
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
                ),
              ),
            ],
          )
        : null;
    final subscribed = community.subscribed ?? false;

    return Stack(children: [
      if (community.banner != null)
        CachedNetworkImage(imageUrl: community.banner),
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
                        text: instanceUrl,
                        style: TextStyle(fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = goToInstance),
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
                  // SUBSCRIBE BUTTON
                  Center(
                    child: SizedBox(
                      height: 27,
                      child: RaisedButton.icon(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        onPressed: subscribe,
                        icon: subscribed
                            ? Icon(Icons.remove,
                                size: 18, color: colorOnTopOfAccent)
                            : Icon(Icons.add,
                                size: 18, color: colorOnTopOfAccent),
                        color: theme.accentColor,
                        label: Text(
                          '${subscribed ? 'un' : ''}subscribe',
                          style: TextStyle(
                              color: colorOnTopOfAccent,
                              fontSize: theme.textTheme.subtitle1.fontSize),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
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
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _AboutSection extends StatelessWidget {
  final CommunityView community;
  final List<CommunityModeratorView> moderators;
  final Function(int id) goToUser;
  final Function() goToModlog;
  final Function() goToCategories;

  const _AboutSection({
    Key key,
    @required this.community,
    @required this.moderators,
    @required this.goToUser,
    @required this.goToModlog,
    @required this.goToCategories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.only(top: 20),
      children: [
        if (community.description != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MarkdownText(community.description),
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
              _Badge(
                  '''${community.numberOfComments} comment${pluralS(community.numberOfComments)}'''),
            ],
          ),
        ),
        _Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          child: FlatButton(
            child: Text('Category: ${community.categoryName}'),
            onPressed: goToCategories,
          ),
        ),
        _Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: FlatButton(
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
              onTap: () => goToUser(mod.id),
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
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Divider(),
    );
  }
}

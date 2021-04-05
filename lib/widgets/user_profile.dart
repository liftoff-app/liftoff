import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../pages/manage_account.dart';
import '../util/extensions/api.dart';
import '../util/extensions/datetime.dart';
import '../util/goto.dart';
import '../util/text_color.dart';
import 'avatar.dart';
import 'fullscreenable_image.dart';
import 'markdown_text.dart';
import 'sortable_infinite_list.dart';

/// Shared widget of UserPage and ProfileTab
class UserProfile extends HookWidget {
  final String instanceHost;
  final int userId;

  final FullPersonView _fullUserView;

  const UserProfile({@required this.userId, @required this.instanceHost})
      : assert(userId != null),
        assert(instanceHost != null),
        _fullUserView = null;

  UserProfile.fromFullPersonView(this._fullUserView)
      : assert(_fullUserView != null),
        userId = _fullUserView.personView.person.id,
        instanceHost = _fullUserView.instanceHost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();
    final userDetailsSnap = useMemoFuture(() async {
      if (_fullUserView != null) return _fullUserView;

      return await LemmyApiV3(instanceHost).run(GetPersonDetails(
        personId: userId,
        savedOnly: false,
        sort: SortType.active,
        auth: accountsStore.defaultTokenFor(instanceHost)?.raw,
      ));
    }, [userId, instanceHost]);

    if (!userDetailsSnap.hasData) {
      return const Center(child: CircularProgressIndicator());
    } else if (userDetailsSnap.hasError) {
      return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('ERROR: ${userDetailsSnap.error}'),
          )
        ]),
      );
    }

    final userView = userDetailsSnap.data.personView;

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            toolbarHeight: 0,
            forceElevated: true,
            backgroundColor: theme.cardColor,
            flexibleSpace:
                FlexibleSpaceBar(background: _UserOverview(userView)),
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
        body: TabBarView(children: [
          // TODO: first batch is already fetched on render
          // TODO: comment and post come from the same endpoint, could be shared
          InfinitePostList(
            fetcher: (page, batchSize, sort) => LemmyApiV3(instanceHost)
                .run(GetPersonDetails(
                  personId: userView.person.id,
                  savedOnly: false,
                  sort: SortType.active,
                  page: page,
                  limit: batchSize,
                  auth: accountsStore.defaultTokenFor(instanceHost)?.raw,
                ))
                .then((val) => val.posts),
          ),
          InfiniteCommentList(
            fetcher: (page, batchSize, sort) => LemmyApiV3(instanceHost)
                .run(GetPersonDetails(
                  personId: userView.person.id,
                  savedOnly: false,
                  sort: SortType.active,
                  page: page,
                  limit: batchSize,
                  auth: accountsStore.defaultTokenFor(instanceHost)?.raw,
                ))
                .then((val) => val.comments),
          ),
          _AboutTab(userDetailsSnap.data),
        ]),
      ),
    );
  }
}

/// Content in the sliver flexible space
/// Renders general info about the given user.
/// Such as his nickname, no. of posts, no. of posts,
/// banner, avatar etc.
class _UserOverview extends HookWidget {
  final PersonViewSafe userView;

  const _UserOverview(this.userView);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorOnTopOfAccentColor =
        textColorBasedOnBackground(theme.accentColor);

    return Stack(
      children: [
        if (userView.person.banner != null)
          // TODO: for some reason doesnt react to presses
          FullscreenableImage(
            url: userView.person.banner,
            child: CachedNetworkImage(
              imageUrl: userView.person.banner,
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 200,
            color: theme.accentColor,
          ),
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.black26,
                Colors.transparent,
              ],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  color: theme.cardColor,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              if (userView.person.avatar != null)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 6, color: Colors.black54)
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: FullscreenableImage(
                        url: userView.person.avatar,
                        child: CachedNetworkImage(
                          imageUrl: userView.person.avatar,
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              if (userView.person.avatar != null)
                const SizedBox(height: 8)
              else
                const SizedBox(height: 80),
              Text(
                userView.person.displayName,
                style: theme.textTheme.headline6,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${userView.person.name}@',
                    style: theme.textTheme.caption,
                  ),
                  InkWell(
                    onTap: () => goToInstance(
                        context, userView.person.originInstanceHost),
                    child: Text(
                      userView.person.originInstanceHost,
                      style: theme.textTheme.caption,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Chip(
                    label: Row(
                      children: [
                        Icon(
                          Icons.article,
                          size: 15,
                          color: colorOnTopOfAccentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          L10n.of(context)
                              .number_of_posts(userView.counts.postCount),
                          style: TextStyle(color: colorOnTopOfAccentColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Chip(
                    label: Row(
                      children: [
                        Icon(
                          Icons.comment,
                          size: 15,
                          color: colorOnTopOfAccentColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          L10n.of(context)
                              .number_of_comments(userView.counts.commentCount),
                          style: TextStyle(color: colorOnTopOfAccentColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Joined ${userView.person.published.fancy}',
                style: theme.textTheme.bodyText1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cake,
                    size: 13,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      DateFormat('MMM dd, yyyy')
                          .format(userView.person.published),
                      style: theme.textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutTab extends HookWidget {
  final FullPersonView userDetails;

  const _AboutTab(this.userDetails);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceHost = userDetails.personView.person.instanceHost;

    final accStore = useAccountsStore();

    final isOwnedAccount = accStore.loggedInInstances.contains(instanceHost) &&
        accStore
            .usernamesFor(instanceHost)
            .contains(userDetails.personView.person.name);

    const wallPadding = EdgeInsets.symmetric(horizontal: 15);

    final divider = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: wallPadding.horizontal / 2, vertical: 10),
      child: const Divider(),
    );

    communityTile(String name, String icon, int id) => ListTile(
          dense: true,
          onTap: () => goToCommunity.byId(context, instanceHost, id),
          title: Text('!$name'),
          leading: Avatar(
            url: icon,
            radius: 20,
          ),
        );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        if (isOwnedAccount)
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit),
                SizedBox(width: 10),
                Text('edit profile'),
              ],
            ),
            onTap: () => goTo(
              context,
              (_) => ManageAccountPage(
                  instanceHost: userDetails.instanceHost,
                  username: userDetails.personView.person.name),
            ),
          ),
        if (userDetails.personView.person.bio != null) ...[
          Padding(
              padding: wallPadding,
              child: MarkdownText(userDetails.personView.person.bio,
                  instanceHost: instanceHost)),
          divider,
        ],
        if (userDetails.moderates.isNotEmpty) ...[
          ListTile(
            title: Center(
              child: Text(
                'Moderates:',
                style: theme.textTheme.headline6.copyWith(fontSize: 18),
              ),
            ),
          ),
          for (final comm
              in userDetails.moderates
                ..sort((a, b) => a.community.name.compareTo(b.community.name)))
            communityTile(
                comm.community.name, comm.community.icon, comm.community.id),
          divider,
        ],
        if (userDetails.follows.isNotEmpty) ...[
          ListTile(
            title: Center(
              child: Text(
                'Subscribed:',
                style: theme.textTheme.headline6.copyWith(fontSize: 18),
              ),
            ),
          ),
          for (final comm
              in userDetails.follows
                ..sort((a, b) => a.community.name.compareTo(b.community.name)))
            communityTile(
                comm.community.name, comm.community.icon, comm.community.id)
        ]
      ],
    );
  }
}

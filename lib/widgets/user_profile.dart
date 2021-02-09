import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/v2.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../pages/manage_account.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../util/intl.dart';
import '../util/text_color.dart';
import 'fullscreenable_image.dart';
import 'markdown_text.dart';
import 'sortable_infinite_list.dart';

/// Shared widget of UserPage and ProfileTab
class UserProfile extends HookWidget {
  final String instanceHost;
  final int userId;

  final FullUserView _fullUserView;

  const UserProfile({@required this.userId, @required this.instanceHost})
      : assert(userId != null),
        assert(instanceHost != null),
        _fullUserView = null;

  UserProfile.fromFullUserView(this._fullUserView)
      : assert(_fullUserView != null),
        userId = _fullUserView.userView.user.id,
        instanceHost = _fullUserView.instanceHost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();
    final userDetailsSnap = useMemoFuture(() async {
      if (_fullUserView != null) return _fullUserView;

      return await LemmyApiV2(instanceHost).run(GetUserDetails(
        userId: userId,
        savedOnly: false,
        sort: SortType.active,
        auth: accountsStore.defaultTokenFor(instanceHost)?.raw,
      ));
    });

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

    final userView = userDetailsSnap.data.userView;

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
                child: const TabBar(
                  tabs: [
                    Tab(text: 'Posts'),
                    Tab(text: 'Comments'),
                    Tab(text: 'About'),
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
            fetcher: (page, batchSize, sort) => LemmyApiV2(instanceHost)
                .run(GetUserDetails(
                  userId: userView.user.id,
                  savedOnly: false,
                  sort: SortType.active,
                  page: page,
                  limit: batchSize,
                  auth: accountsStore.defaultTokenFor(instanceHost)?.raw,
                ))
                .then((val) => val.posts),
          ),
          InfiniteCommentList(
            fetcher: (page, batchSize, sort) => LemmyApiV2(instanceHost)
                .run(GetUserDetails(
                  userId: userView.user.id,
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
  final UserViewSafe userView;

  const _UserOverview(this.userView);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorOnTopOfAccentColor =
        textColorBasedOnBackground(theme.accentColor);

    return Stack(
      children: [
        if (userView.user.banner != null)
          // TODO: for some reason doesnt react to presses
          FullscreenableImage(
            url: userView.user.banner,
            child: CachedNetworkImage(
              imageUrl: userView.user.banner,
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
              if (userView.user.avatar != null)
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
                        url: userView.user.avatar,
                        child: CachedNetworkImage(
                          imageUrl: userView.user.avatar,
                          errorWidget: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              if (userView.user.avatar != null)
                const SizedBox(height: 8)
              else
                const SizedBox(height: 80),
              Text(
                userView.user.displayName,
                style: theme.textTheme.headline6,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${userView.user.name}@',
                    style: theme.textTheme.caption,
                  ),
                  InkWell(
                    onTap: () =>
                        goToInstance(context, userView.user.originInstanceHost),
                    child: Text(
                      userView.user.originInstanceHost,
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
                          '${compactNumber(userView.counts.postCount)}'
                          ' Post${pluralS(userView.counts.postCount)}',
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
                          '${compactNumber(userView.counts.commentCount)} Comment${pluralS(userView.counts.commentCount)}',
                          style: TextStyle(color: colorOnTopOfAccentColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Joined ${timeago.format(userView.user.published)}',
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
                          .format(userView.user.published),
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
  final FullUserView userDetails;

  const _AboutTab(this.userDetails);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceHost = userDetails.userView.user.instanceHost;

    final accStore = useAccountsStore();

    final isOwnedAccount = accStore.loggedInInstances.contains(instanceHost) &&
        accStore
            .usernamesFor(instanceHost)
            .contains(userDetails.userView.user.name);

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
          leading: icon != null
              ? CachedNetworkImage(
                  height: 40,
                  width: 40,
                  imageUrl: icon,
                  errorWidget: (_, __, ___) =>
                      const SizedBox(width: 40, height: 40),
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      ))
              : const SizedBox(width: 40),
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
                  username: userDetails.userView.user.name),
            ),
          ),
        if (userDetails.userView.user.bio != null) ...[
          Padding(
              padding: wallPadding,
              child: MarkdownText(userDetails.userView.user.bio,
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
          divider
        ],
        ListTile(
          title: Center(
            child: Text(
              'Subscribed:',
              style: theme.textTheme.headline6.copyWith(fontSize: 18),
            ),
          ),
        ),
        if (userDetails.follows.isNotEmpty)
          for (final comm
              in userDetails.follows
                ..sort((a, b) => a.community.name.compareTo(b.community.name)))
            communityTile(
                comm.community.name, comm.community.icon, comm.community.id)
        else
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Center(
              child: Text(
                'this user does not subscribe to any community',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          )
      ],
    );
  }
}

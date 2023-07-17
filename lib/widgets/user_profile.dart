import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../pages/instance/instance.dart';
import '../pages/manage_account.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../util/text_color.dart';
import 'avatar.dart';
import 'cached_network_image.dart';
import 'fullscreenable_image.dart';
import 'markdown_text.dart';
import 'post/post_store.dart';
import 'sortable_infinite_list.dart';

/// Shared widget of UserPage and ProfileTab
class UserProfile extends HookWidget {
  final String instanceHost;
  final int userId;

  final FullPersonView? _fullUserView;

  const UserProfile(
      {super.key, required this.userId, required this.instanceHost})
      : _fullUserView = null;

  UserProfile.fromFullPersonView(FullPersonView this._fullUserView, {super.key})
      : userId = _fullUserView.personView.person.id,
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
        auth: accountsStore.defaultUserDataFor(instanceHost)?.jwt.raw,
      ));
    }, [userId, instanceHost]);

    if (!userDetailsSnap.hasData) {
      return const Center(child: CircularProgressIndicator.adaptive());
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
    final fullPersonView = userDetailsSnap.data!;
    final userView = fullPersonView.personView;

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            toolbarHeight: 0,
            forceElevated: true,
            backgroundColor: theme.canvasColor,
            flexibleSpace:
                FlexibleSpaceBar(background: _UserOverview(userView)),
            bottom: PreferredSize(
              preferredSize: const TabBar(tabs: []).preferredSize,
              child: Material(
                color: theme.canvasColor,
                child: TabBar(
                  indicatorColor: theme.colorScheme.primary,
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
            physics: const NeverScrollableScrollPhysics(),
            children: [
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
                      auth: accountsStore
                          .defaultUserDataFor(instanceHost)
                          ?.jwt
                          .raw,
                    ))
                    .then((val) => val.posts)
                    .toPostStores(),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: InfiniteCommentList(
                    fetcher: (page, batchSize, sort) => LemmyApiV3(instanceHost)
                        .run(GetPersonDetails(
                          personId: userView.person.id,
                          savedOnly: false,
                          sort: SortType.active,
                          page: page,
                          limit: batchSize,
                          auth: accountsStore
                              .defaultUserDataFor(instanceHost)
                              ?.jwt
                              .raw,
                        ))
                        .then((val) => val.comments),
                  ),
                ),
              ),
              _AboutTab(fullPersonView),
            ]),
      ),
    );
  }
}

/// Content in the sliver flexible space
/// Renders general info about the given user.
/// Such as their nickname, no. of posts, no. of posts,
/// banner, avatar etc.
class _UserOverview extends HookWidget {
  final PersonViewSafe userView;

  const _UserOverview(this.userView);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorOnTopOfAccentColor =
        textColorBasedOnBackground(theme.colorScheme.secondary);

    return Stack(
      fit: StackFit.expand,
      children: [
        if (userView.person.banner != null)
          Align(
            alignment: Alignment.topCenter,
            child: FullscreenableImage(
              url: userView.person.banner!,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: MediaQuery.of(context).padding.top + 100,
                width: double.infinity,
                imageUrl: userView.person.banner!,
                errorBuilder: (_, ___) => const SizedBox.shrink(),
              ),
            ),
          )
        else
          ColoredBox(color: theme.colorScheme.secondary),
        const IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
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
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                color: theme.canvasColor,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              if (userView.person.avatar != null)
                Container(
                  width: 80,
                  height: 80,
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
                      url: userView.person.avatar!,
                      child: CachedNetworkImage(
                        imageUrl: userView.person.avatar!,
                        errorBuilder: (_, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              if (userView.person.avatar != null)
                const SizedBox(height: 8)
              else
                const SizedBox(height: 80),
              Text(
                '${userView.person.preferredName}${userView.person.isCakeDay ? ' 🍰' : ''}',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '@${userView.person.name}@',
                    style: theme.textTheme.bodySmall,
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      InstancePage.route(
                        userView.person.originInstanceHost,
                      ),
                    ),
                    child: Text(
                      userView.person.originInstanceHost,
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
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
                          L10n.of(context).number_of_comments(
                              userView.counts.commentCount,
                              userView.counts.commentCount),
                          style: TextStyle(color: colorOnTopOfAccentColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Joined ${userView.person.published.timeago(context)}',
                style: theme.textTheme.bodyLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cake,
                    size: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMMd(
                      Localizations.localeOf(context).toLanguageTag(),
                    ).format(userView.person.published),
                    style: theme.textTheme.bodyLarge,
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
    final token = accStore
        .userDataFor(instanceHost, userDetails.personView.person.name)
        ?.jwt;

    final isOwnedAccount = token != null;

    final followsSnap = useMemoFuture<List<CommunityFollowerView>>(() async {
      if (token == null) return const [];

      try {
        return LemmyApiV3(instanceHost)
            .run(GetSite(auth: token.raw))
            .then((value) => value.myUser!.follows);
      } catch (e) {
        return List.empty();
      }
    }, [token]);

    const wallPadding = EdgeInsets.symmetric(horizontal: 15);

    final divider = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: wallPadding.horizontal / 2,
        vertical: 10,
      ),
      child: const Divider(),
    );

    communityTile(String name, String? icon, int id) => ListTile(
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
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              child: MarkdownText(userDetails.personView.person.bio!,
                  instanceHost: instanceHost)),
          divider,
        ],
        if (userDetails.moderates.isNotEmpty) ...[
          ListTile(
            title: Center(
              child: Text(
                'Moderates:',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
            ),
          ),
          for (final comm
              in List.from(userDetails.moderates)
                ..sort((a, b) => a.community.name.compareTo(b.community.name)))
            communityTile(
                comm.community.name, comm.community.icon, comm.community.id),
          divider,
        ],
        if (followsSnap.hasData && followsSnap.data!.isNotEmpty) ...[
          ListTile(
            title: Center(
              child: Text(
                'Subscribed:',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
              ),
            ),
          ),
          for (final comm
              in List.from(followsSnap.data!)
                ..sort((a, b) => a.community.name.compareTo(b.community.name)))
            communityTile(
                comm.community.name, comm.community.icon, comm.community.id)
        ]
      ],
    );
  }
}

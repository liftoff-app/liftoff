import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/delayed_loading.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/extensions/api.dart';
import '../util/extensions/spaced.dart';
import '../util/goto.dart';
import '../util/icons.dart';
import '../util/intl.dart';
import '../util/share.dart';
import '../widgets/avatar.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/bottom_safe.dart';
import '../widgets/cached_network_image.dart';
import '../widgets/fullscreenable_image.dart';
import '../widgets/info_table_popup.dart';
import '../widgets/markdown_text.dart';
import '../widgets/reveal_after_scroll.dart';
import '../widgets/sortable_infinite_list.dart';
import 'create_post.dart';
import 'modlog_page.dart';

/// Displays posts, comments, and general info about the given community
class CommunityPage extends HookWidget {
  final CommunityView? _community;
  final String instanceHost;
  final String? communityName;
  final int? communityId;

  const CommunityPage.fromName({
    required String this.communityName,
    required this.instanceHost,
  })  : communityId = null,
        _community = null;
  const CommunityPage.fromId({
    required int this.communityId,
    required this.instanceHost,
  })  : communityName = null,
        _community = null;
  CommunityPage.fromCommunityView(CommunityView this._community)
      : instanceHost = _community.instanceHost,
        communityId = _community.community.id,
        communityName = _community.community.name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();
    final scrollController = useScrollController();

    final fullCommunitySnap = useMemoFuture(() {
      final token = accountsStore.defaultUserDataFor(instanceHost)?.jwt;

      if (communityId != null) {
        return LemmyApiV3(instanceHost).run(GetCommunity(
          id: communityId,
          auth: token?.raw,
        ));
      } else {
        return LemmyApiV3(instanceHost).run(GetCommunity(
          name: communityName,
          auth: token?.raw,
        ));
      }
    });

    final community = () {
      if (fullCommunitySnap.hasData) {
        return fullCommunitySnap.data!.communityView;
      } else if (_community != null) {
        return _community;
      } else {
        return null;
      }
    }();

    // FALLBACK

    if (community == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (fullCommunitySnap.hasError) ...[
                const Icon(Icons.error),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text('ERROR: ${fullCommunitySnap.error}'),
                )
              ] else
                const CircularProgressIndicator.adaptive(
                    semanticsLabel: 'loading')
            ],
          ),
        ),
      );
    }

    // FUNCTIONS
    void _share() => share(community.community.actorId, context: context);

    void _openMoreMenu() {
      showBottomModal(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: const Text('Open in browser'),
              onTap: () async => await ul.canLaunch(community.community.actorId)
                  ? ul.launch(community.community.actorId)
                  : ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("can't open in browser"))),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Nerd stuff'),
              onTap: () {
                showInfoTablePopup(context: context, table: community.toJson());
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      floatingActionButton: CreatePostFab(community: community),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => <Widget>[
            SliverAppBar(
              expandedHeight: community.community.icon == null ? 220 : 300,
              pinned: true,
              backgroundColor: theme.cardColor,
              title: RevealAfterScroll(
                scrollController: scrollController,
                after: community.community.icon == null ? 110 : 190,
                fade: true,
                child: Text(
                  community.community.preferredName,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              actions: [
                IconButton(icon: Icon(shareIcon), onPressed: _share),
                IconButton(icon: Icon(moreIcon), onPressed: _openMoreMenu),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _CommunityOverview(
                  community: community,
                  instanceHost: instanceHost,
                  onlineUsers: fullCommunitySnap.data?.online,
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
                    LemmyApiV3(community.instanceHost).run(GetPosts(
                  type: PostListingType.community,
                  sort: sort,
                  communityId: community.community.id,
                  page: page,
                  limit: batchSize,
                  savedOnly: false,
                )),
              ),
              InfiniteCommentList(
                  fetcher: (page, batchSize, sortType) =>
                      LemmyApiV3(community.instanceHost).run(GetComments(
                        communityId: community.community.id,
                        auth: accountsStore
                            .defaultUserDataFor(community.instanceHost)
                            ?.jwt
                            .raw,
                        type: CommentListingType.community,
                        sort: sortType,
                        limit: batchSize,
                        page: page,
                        savedOnly: false,
                      ))),
              _AboutTab(
                community: community,
                moderators: fullCommunitySnap.data?.moderators,
                onlineUsers: fullCommunitySnap.data?.online,
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
  final int? onlineUsers;

  const _CommunityOverview({
    required this.community,
    required this.instanceHost,
    required this.onlineUsers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadow = BoxShadow(color: theme.canvasColor, blurRadius: 5);

    final icon = community.community.icon != null
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
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              FullscreenableImage(
                url: community.community.icon!,
                child: Avatar(
                  url: community.community.icon,
                  radius: 83 / 2,
                  alwaysShow: true,
                ),
              ),
            ],
          )
        : null;

    return Stack(
      children: [
        if (community.community.banner != null)
          FullscreenableImage(
            url: community.community.banner!,
            child: CachedNetworkImage(
              imageUrl: community.community.banner!,
              errorBuilder: (_, ___) => const SizedBox.shrink(),
            ),
          ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 45),
              if (icon != null) icon,
              const SizedBox(height: 10),
              // NAME
              RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: theme.textTheme.subtitle1?.copyWith(shadows: [shadow]),
                  children: [
                    const TextSpan(
                      text: '!',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                    TextSpan(
                      text: community.community.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const TextSpan(
                      text: '@',
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                    TextSpan(
                      text: community.community.originInstanceHost,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => goToInstance(
                              context,
                              community.community.originInstanceHost,
                            ),
                    ),
                  ],
                ),
              ),
              // TITLE/MOTTO
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  community.community.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    shadows: [shadow],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  // INFO ICONS
                  Row(
                    children: [
                      const Spacer(),
                      const Icon(Icons.people, size: 20),
                      const SizedBox(width: 3),
                      Text(compactNumber(community.counts.subscribers)),
                      const Spacer(flex: 4),
                      const Icon(Icons.record_voice_over, size: 20),
                      const SizedBox(width: 3),
                      Text(onlineUsers == null
                          ? 'xx'
                          : compactNumber(onlineUsers!)),
                      const Spacer(),
                    ],
                  ),
                  _FollowButton(community),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  final CommunityView community;
  final List<CommunityModeratorView>? moderators;
  final int? onlineUsers;

  const _AboutTab({
    Key? key,
    required this.community,
    required this.moderators,
    required this.onlineUsers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.only(top: 20),
      children: [
        if (community.community.description != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: MarkdownText(
              community.community.description!,
              instanceHost: community.instanceHost,
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
                      .number_of_users_online(onlineUsers ?? 0))),
              Chip(
                  label:
                      Text('${community.counts.usersActiveDay} users / day')),
              Chip(
                  label:
                      Text('${community.counts.usersActiveWeek} users / week')),
              Chip(
                  label: Text(
                      '${community.counts.usersActiveMonth} users / month')),
              Chip(
                  label: Text(
                      '${community.counts.usersActiveHalfYear} users / 6 months')),
              Chip(
                  label: Text(L10n.of(context)
                      .number_of_subscribers(community.counts.subscribers))),
              Chip(
                  label: Text(
                      '${community.counts.posts} post${pluralS(community.counts.posts)}')),
              Chip(
                  label: Text(
                      '${community.counts.comments} comment${pluralS(community.counts.comments)}')),
            ].spaced(8),
          ),
        ),
        const _Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: OutlinedButton(
            onPressed: () => goTo(
              context,
              (context) => ModlogPage.forCommunity(
                instanceHost: community.instanceHost,
                communityId: community.community.id,
                communityName: community.community.name,
              ),
            ),
            child: Text(L10n.of(context).modlog),
          ),
        ),
        const _Divider(),
        if (moderators != null && moderators!.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text('Mods:', style: theme.textTheme.subtitle2),
          ),
          for (final mod in moderators!)
            // TODO: add user picture, maybe make it into reusable component
            ListTile(
              title: Text(mod.moderator.preferredName),
              onTap: () => goToUser.fromPersonSafe(context, mod.moderator),
            ),
        ],
        const BottomSafe(),
      ],
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

class _FollowButton extends HookWidget {
  final CommunityView community;

  const _FollowButton(this.community);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isSubbed = useState(community.subscribed);
    final delayed = useDelayedLoading(Duration.zero);
    final loggedInAction = useLoggedInAction(community.instanceHost);

    subscribe(Jwt token) async {
      delayed.start();
      try {
        await LemmyApiV3(community.instanceHost).run(FollowCommunity(
            communityId: community.community.id,
            follow: !isSubbed.value,
            auth: token.raw));
        isSubbed.value = !isSubbed.value;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning),
              const SizedBox(width: 10),
              Text("couldn't ${isSubbed.value ? 'un' : ''}sub :<"),
            ],
          ),
        ));
      }

      delayed.cancel();
    }

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: theme.elevatedButtonTheme.style?.copyWith(
          shape: MaterialStateProperty.all(const StadiumBorder()),
          textStyle: MaterialStateProperty.all(theme.textTheme.subtitle1),
        ),
      ),
      child: Center(
        child: SizedBox(
          height: 27,
          width: 160,
          child: delayed.loading
              ? const ElevatedButton(
                  onPressed: null,
                  child: SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed:
                      loggedInAction(delayed.pending ? (_) {} : subscribe),
                  icon: isSubbed.value
                      ? const Icon(Icons.remove, size: 18)
                      : const Icon(Icons.add, size: 18),
                  label: Text(isSubbed.value
                      ? L10n.of(context).unsubscribe
                      : L10n.of(context).subscribe),
                ),
        ),
      ),
    );
  }
}

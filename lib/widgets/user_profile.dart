import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../util/intl.dart';
import '../util/text_color.dart';
import 'badge.dart';
import 'fullscreenable_image.dart';

/// Shared widget of UserPage and ProfileTab
class UserProfile extends HookWidget {
  final Future<UserView> _userView;
  final String instanceUrl;

  UserProfile({@required int userId, @required this.instanceUrl})
      : _userView = LemmyApi(instanceUrl)
            .v1
            .getUserDetails(
                userId: userId, savedOnly: true, sort: SortType.active)
            .then((res) => res.user);

  UserProfile.fromUserView(UserView userView)
      : _userView = Future.value(userView),
        instanceUrl = userView.instanceUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userViewSnap = useFuture(_userView, preserveState: false);

    if (!userViewSnap.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final userView = userViewSnap.data;

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 255,
            toolbarHeight: 0,
            forceElevated: true,
            elevation: 0,
            backgroundColor: theme.cardColor,
            brightness: theme.brightness,
            iconTheme: theme.iconTheme,
            flexibleSpace:
                FlexibleSpaceBar(background: _UserOverview(userView)),
            bottom: TabBar(
              labelColor: theme.textTheme.bodyText1.color,
              tabs: [
                Tab(text: 'Posts'),
                Tab(text: 'Comments'),
                Tab(text: 'About'),
              ],
            ),
          ),
        ],
        body: TabBarView(children: [
          ListView(children: [
            Text(
              'Posts',
              style: const TextStyle(fontSize: 36),
            )
          ]),
          ListView(children: [
            Text(
              'Comments',
              style: const TextStyle(fontSize: 36),
            )
          ]),
          // InfinitePostList(
          //       fetcher: (page, batchSize, sort) =>
          //           LemmyApi(community.instanceUrl).v1.getPosts(
          //                 type: PostListingType.community,
          //                 sort: sort,
          //                 communityId: community.id,
          //                 page: page,
          //                 limit: batchSize,
          //               ),
          //     ),
          //     InfiniteCommentList(
          //         fetcher: (page, batchSize, sortType) =>
          //             LemmyApi(community.instanceUrl).v1.getComments(
          //                   communityId: community.id,
          //                   auth: accountsStore
          //                       .defaultTokenFor(community.instanceUrl)
          //                       ?.raw,
          //                   type: CommentListingType.community,
          //                   sort: sortType,
          //                   limit: batchSize,
          //                   page: page,
          //                 )),
          _AboutTab(userView),
        ]),
      ),
    );
  }
}

class _UserOverview extends HookWidget {
  final UserView userView;

  const _UserOverview(this.userView);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorOnTopOfAccentColor =
        textColorBasedOnBackground(theme.accentColor);

    return Stack(
      children: [
        if (userView.banner != null)
          // TODO: for some reason doesnt react to presses
          FullscreenableImage(
            url: userView.banner,
            child: CachedNetworkImage(
              imageUrl: userView.banner,
              errorWidget: (_, __, ___) => SizedBox.shrink(),
            ),
          )
        else
          Container(
            width: double.infinity,
            height: double.infinity,
            color: theme.primaryColor,
          ),
        Container(
          height: 200,
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
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40),
                  ),
                  color: theme.scaffoldBackgroundColor,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              if (userView.avatar != null)
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Container(
                    // clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 6, color: Colors.black54)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: FullscreenableImage(
                        url: userView.avatar,
                        child: CachedNetworkImage(
                          imageUrl: userView.avatar,
                          errorWidget: (_, __, ___) => SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: userView.avatar != null
                    ? const EdgeInsets.only(top: 8.0)
                    : const EdgeInsets.only(top: 70),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: userView.avatar == null ? 10 : 0),
                  child: Text(
                    userView.preferredUsername ?? userView.name,
                    style: theme.textTheme.headline6,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '@${userView.name}@',
                      style: theme.textTheme.caption,
                    ),
                    InkWell(
                      onTap: () => goToInstance(context, userView.instanceUrl),
                      child: Text(
                        '${userView.instanceUrl}',
                        style: theme.textTheme.caption,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Badge(
                      child: Row(
                        children: [
                          Icon(
                            Icons.comment, // TODO: should be article icon
                            size: 15,
                            color: colorOnTopOfAccentColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              '${compactNumber(userView.numberOfPosts)}'
                              ' Post${pluralS(userView.numberOfPosts)}',
                              style: TextStyle(color: colorOnTopOfAccentColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Badge(
                        child: Row(
                          children: [
                            Icon(
                              Icons.comment,
                              size: 15,
                              color: colorOnTopOfAccentColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                '${compactNumber(userView.numberOfComments)}'
                                ' Comment${pluralS(userView.numberOfComments)}',
                                style:
                                    TextStyle(color: colorOnTopOfAccentColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  'Joined ${timeago.format(userView.published)}',
                  style: theme.textTheme.bodyText1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cake,
                      size: 13,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        DateFormat('MMM dd, yyyy').format(userView.published),
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(child: tabs())
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutTab extends HookWidget {
  final UserView userView;

  const _AboutTab(this.userView);

  @override
  Widget build(BuildContext context) {
    final bio = () {
      if (userView.bio != null) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Text(userView.bio),
        );
      } else {
        return Center(
          child: Text(
            'no bio',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }
    }();

    return ListView();
  }
}

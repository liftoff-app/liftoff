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

/// Shared widget of UserPage and ProfileTab
class UserProfile extends HookWidget {
  final Future<UserView> _userView;
  final String instanceUrl;

  // TODO: add `.fromUser` constructor
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
    final colorOnTopOfAccentColor =
        textColorBasedOnBackground(theme.accentColor);

    final userViewSnap = useFuture(_userView, preserveState: false);

    final bio = () {
      if (userViewSnap.hasData) {
        if (userViewSnap.data.bio != null) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Text(userViewSnap.data.bio),
          );
        } else {
          return Center(
            child: Text(
              'no bio',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          );
        }
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }();

    Widget tabs() => DefaultTabController(
          length: 3,
          child: Column(
            children: [
              TabBar(
                labelColor: theme.textTheme.bodyText1.color,
                tabs: [
                  Tab(text: 'Posts'),
                  Tab(text: 'Comments'),
                  Tab(text: 'About'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Text(
                        'Posts',
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Comments',
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    bio,
                  ],
                ),
              )
            ],
          ),
        );

    return Center(
      child: Stack(
        children: [
          if (userViewSnap.data?.banner != null)
            CachedNetworkImage(
              imageUrl: userViewSnap.data.banner,
              errorWidget: (_, __, ___) => SizedBox.shrink(),
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
                if (userViewSnap.data?.avatar != null)
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
                        child: CachedNetworkImage(
                          imageUrl: userViewSnap.data.avatar,
                          errorWidget: (_, __, ___) => SizedBox.shrink(),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: userViewSnap.data?.avatar != null
                      ? const EdgeInsets.only(top: 8.0)
                      : const EdgeInsets.only(top: 70),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: userViewSnap.data?.avatar == null ? 10 : 0),
                    child: Text(
                      userViewSnap.data?.preferredUsername ??
                          userViewSnap.data?.name ??
                          '',
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
                        '@${userViewSnap.data?.name ?? ''}@',
                        style: theme.textTheme.caption,
                      ),
                      InkWell(
                        onTap: () => goToInstance(context, instanceUrl),
                        child: Text(
                          '$instanceUrl',
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
                                '''
${userViewSnap.hasData ? compactNumber(userViewSnap.data.numberOfPosts) : '-'} Post${pluralS(userViewSnap.data?.numberOfPosts ?? 0)}''',
                                style:
                                    TextStyle(color: colorOnTopOfAccentColor),
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
                                  '''
${userViewSnap.hasData ? compactNumber(userViewSnap.data.numberOfComments) : '-'} Comment${pluralS(userViewSnap.data?.numberOfComments ?? 0)}''',
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
                    '''
Joined ${userViewSnap.hasData ? timeago.format(userViewSnap.data.published) : ''}''',
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
                          userViewSnap.hasData
                              ? DateFormat('MMM dd, yyyy')
                                  .format(userViewSnap.data.published)
                              : '',
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: tabs())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

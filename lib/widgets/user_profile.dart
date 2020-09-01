import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../util/intl.dart';

class UserProfile extends HookWidget {
  final int userId;
  final Future<UserView> _userView;
  final String instanceUrl;

  UserProfile({@required this.userId, @required this.instanceUrl})
      : _userView = LemmyApi(instanceUrl)
            .v1
            .getUserDetails(
                userId: userId, savedOnly: true, sort: SortType.active)
            .then((res) => res.user);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var userViewSnap = useFuture(_userView);

    Widget bio;

    if (userViewSnap.hasData) {
      if (userViewSnap.data.bio != null) {
        bio = Text(userViewSnap.data.bio);
      } else {
        bio = Center(
          child: Text(
            'no bio',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        );
      }
    } else {
      bio = Center(child: CircularProgressIndicator());
    }

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
            )
          else
            Container(
              width: double.infinity,
              height: double.infinity,
              color: theme.primaryColor,
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
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: userViewSnap.data?.avatar != null
                      ? const EdgeInsets.only(top: 8.0)
                      : const EdgeInsets.only(top: 70),
                  child: Text(
                    userViewSnap.data?.preferredUsername ??
                        userViewSnap.data?.name ??
                        '',
                    style: theme.textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '@${userViewSnap.data?.name ?? ''}@$instanceUrl',
                    style: theme.textTheme.caption,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _Badge(
                        icon: Icons.comment, // TODO: should be article icon
                        text: '''
${compactNumber(userViewSnap.data?.numberOfPosts ?? 0)} Post${pluralS(userViewSnap.data?.numberOfPosts ?? 0)}''',
                        isLoading: !userViewSnap.hasData,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: _Badge(
                          icon: Icons.comment,
                          text: '''
${compactNumber(userViewSnap.data?.numberOfComments ?? 0)} Comment${pluralS(userViewSnap.data?.numberOfComments ?? 1)}''',
                          isLoading: !userViewSnap.hasData,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '''
Joined ${userViewSnap.hasData ? timeago.format(userViewSnap.data.published) : ''}''',
                    style: theme.textTheme.bodyText1,
                  ),
                ),
                Row(
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
                Expanded(child: tabs())
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLoading;

  _Badge({
    @required this.icon,
    @required this.isLoading,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.accentColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: isLoading
            ? CircularProgressIndicator()
            : Row(
                children: [
                  Icon(icon, size: 15, color: Colors.white),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text(text),
                  ),
                ],
              ),
      ),
    );
  }
}

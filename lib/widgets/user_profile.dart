import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../util/intl.dart';

class UserProfile extends HookWidget {
  final User user;
  final Future<UserView> _userView;

  UserProfile(this.user)
      : _userView = LemmyApi('dev.lemmy.ml')
            .v1
            .search(q: user.name, type: SearchType.users, sort: SortType.active)
            .then((res) => res.users[0]);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var userViewSnap = useFuture(_userView);

    return Center(
      child: Stack(
        children: [
          Image.network(
              'https://c4.wallpaperflare.com/wallpaper/500/442/354/outrun-vaporwave-hd-wallpaper-preview.jpg'), // TODO: should be the banner
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(blurRadius: 6, color: Colors.black54)
                      ],
                      color:
                          theme.backgroundColor, // TODO: add avatar, not color
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    user.preferredUsername ?? user.name,
                    style: theme.textTheme.headline6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '@${user.name}@', // TODO: add instance host uri
                    style: theme.textTheme.caption,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _badge(
                        context: context,
                        icon: Icons.comment, // TODO: should be article icon
                        text: '''
${compactNumber(userViewSnap.data?.numberOfPosts ?? 0)} Post${pluralS(userViewSnap.data?.numberOfPosts ?? 0)}''',
                        loading: !userViewSnap.hasData,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: _badge(
                          context: context,
                          icon: Icons.comment,
                          text: '''
${compactNumber(userViewSnap.data?.numberOfComments ?? 0)} Comment${pluralS(userViewSnap.data?.numberOfComments ?? 1)}''',
                          loading: !userViewSnap.hasData,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Joined ${timeago.format(user.published)}',
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
                        DateFormat('MMM dd, yyyy').format(user.published),
                        style: theme.textTheme.bodyText1,
                      ),
                    ),
                  ],
                ),
                Expanded(child: _tabs())
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(
          {IconData icon, String text, bool loading, BuildContext context}) =>
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: loading
              ? CircularProgressIndicator()
              : Row(
                  children: [
                    Icon(icon, size: 15, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(text, style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
        ),
      );

  Widget _tabs() => DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
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
                  )),
                  Center(
                      child: Text(
                    'Comments',
                    style: const TextStyle(fontSize: 36),
                  )),
                  if (user.bio == null)
                    Center(
                      child: Text(
                        'No bio.',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    )
                  else
                    Text(user.bio),
                ],
              ),
            )
          ],
        ),
      );
}

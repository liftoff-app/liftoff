import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserProfileTab extends HookWidget {
  final User user;
  final Future<UserView> _userView;

  UserProfileTab(this.user)
      : _userView = LemmyApi('dev.lemmy.ml')
            .v1
            .search(q: user.name, type: SearchType.users, sort: SortType.active)
            .then((res) => res.users[0]);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var userViewSnap = useFuture(_userView);

    return Scaffold(
      appBar: AppBar(
        title: Text('hello'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: 65,
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black54)],
                  color: theme.backgroundColor, // TODO: add avatar, not color
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
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '@${user.name}@', // TODO: add instance host uri
                style: theme.textTheme.caption,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _blueBadge(
                    icon: Icons.comment,
                    text: '''
${NumberFormat.compact().format(userViewSnap.data.numberOfPosts ?? 0)} Posts''',
                    loading: !userViewSnap.hasData,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: _blueBadge(
                      icon: Icons.comment,
                      text: '''
${NumberFormat.compact().format(userViewSnap.data.numberOfPosts ?? 0)} Comments''',
                      loading: !userViewSnap.hasData,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('''Joined ${timeago.format(user.published)}'''),
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
                  child:
                      Text(DateFormat('MMM dd, yyyy').format(user.published)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _blueBadge({IconData icon, String text, bool loading}) => Container(
        decoration: BoxDecoration(
          color: Colors.blue[300],
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
}

import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/avatar.dart';
import '../widgets/markdown_text.dart';

/// Infinite list of Users fetched by the given fetcher
class UsersListPage extends StatelessWidget {
  final String title;
  final List<PersonViewSafe> users;

  const UsersListPage({Key? key, required this.users, this.title = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: change to infinite scroll
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text(title),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => UsersListItem(user: users[i]),
        itemCount: users.length,
      ),
    );
  }
}

class UsersListItem extends StatelessWidget {
  final PersonViewSafe user;

  const UsersListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(user.person.originPreferredName),
        subtitle: user.person.bio != null
            ? Opacity(
                opacity: 0.7,
                child: MarkdownText(
                  user.person.bio!,
                  instanceHost: user.instanceHost,
                ),
              )
            : null,
        onTap: () => goToUser.fromPersonSafe(context, user.person),
        leading: Avatar(url: user.person.avatar),
      );
}

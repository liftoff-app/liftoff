import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/avatar.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/markdown_text.dart';

/// Infinite list of Users fetched by the given fetcher
class UsersListPage extends StatelessWidget {
  final String title;
  final Fetcher<PersonViewSafe> fetcher;

  const UsersListPage({Key? key, required this.fetcher, this.title = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text(title),
      ),
      body: InfiniteScroll<PersonViewSafe>(
        fetcher: fetcher,
        itemBuilder: (user) => Column(
          children: [
            const Divider(),
            UsersListItem(user: user),
          ],
        ),
        uniqueProp: (user) => user.person.actorId,
      ),
    );
  }
}

class UsersListItem extends StatelessWidget {
  final PersonViewSafe user;

  const UsersListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
}

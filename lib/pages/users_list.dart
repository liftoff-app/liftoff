import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../util/extensions/api.dart';
import '../util/extensions/truncate.dart';
import '../util/goto.dart';
import '../widgets/avatar.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/markdown_text.dart';

/// Infinite list of Users fetched by the given fetcher
class UsersListPage extends StatelessWidget {
  final String title;
  final Fetcher<PersonViewSafe> fetcher;

  const UsersListPage({super.key, required this.fetcher, this.title = ''});

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

  const UsersListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Find a reasonable cutoff point for the description.
    var desc = '';
    if (user.person.bio != null) {
      desc = user.person.bio!.truncate(200);
      final par = desc.indexOf('\n');
      if (par > 0) desc = desc.substring(0, par);
    }

    return ListTile(
      title: Text(user.person.originPreferredName),
      subtitle: user.person.bio != null
          ? Opacity(
              opacity: 0.7,
              child: MarkdownText(
                desc,
                instanceHost: user.instanceHost,
              ),
            )
          : const SizedBox(height: 5),
      onTap: () => goToUser.fromPersonSafe(context, user.person),
      leading: Avatar(url: user.person.avatar),
    );
  }
}

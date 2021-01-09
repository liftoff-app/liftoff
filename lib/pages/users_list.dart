import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/goto.dart';
import '../widgets/markdown_text.dart';

/// Infinite list of Users fetched by the given fetcher
class UsersListPage extends StatelessWidget {
  final String title;
  final List<UserView> users;

  const UsersListPage({Key key, @required this.users, this.title})
      : assert(users != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: change to infinite scroll
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? '', style: theme.textTheme.headline6),
          centerTitle: true,
          backgroundColor: theme.cardColor,
          iconTheme: theme.iconTheme,
        ),
        body: ListView.builder(
          itemBuilder: (context, i) => UsersListItem(user: users[i]),
          itemCount: users.length,
        ));
  }
}

class UsersListItem extends StatelessWidget {
  final UserView user;

  const UsersListItem({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(
            (user.preferredUsername == null || user.preferredUsername.isEmpty)
                ? '@${user.name}'
                : user.preferredUsername),
        subtitle: user.bio != null
            ? Opacity(
                opacity: 0.5,
                child: MarkdownText(
                  user.bio,
                  instanceHost: user.instanceHost,
                ),
              )
            : null,
        onTap: () => goToUser.byId(context, user.instanceHost, user.id),
        leading: user.avatar != null
            ? CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: user.avatar,
                errorWidget: (_, __, ___) =>
                    const SizedBox(height: 50, width: 50),
                imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: imageProvider),
                      ),
                    ))
            : const SizedBox(width: 50),
      );
}

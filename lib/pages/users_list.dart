import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v2.dart';

import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/markdown_text.dart';

/// Infinite list of Users fetched by the given fetcher
class UsersListPage extends StatelessWidget {
  final String title;
  final List<UserViewSafe> users;

  const UsersListPage({Key key, @required this.users, this.title})
      : assert(users != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: change to infinite scroll
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        title: Text(title ?? ''),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => UsersListItem(user: users[i]),
        itemCount: users.length,
      ),
    );
  }
}

class UsersListItem extends StatelessWidget {
  final UserViewSafe user;

  const UsersListItem({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(user.user.originDisplayName),
        subtitle: user.user.bio != null
            ? Opacity(
                opacity: 0.5,
                child: MarkdownText(
                  user.user.bio,
                  instanceHost: user.instanceHost,
                ),
              )
            : null,
        onTap: () => goToUser.byId(context, user.instanceHost, user.user.id),
        leading: user.user.avatar != null
            ? CachedNetworkImage(
                height: 50,
                width: 50,
                imageUrl: user.user.avatar,
                errorWidget: (_, __, ___) =>
                    const SizedBox(height: 50, width: 50),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover, image: imageProvider),
                  ),
                ),
              )
            : const SizedBox(width: 50),
      );
}

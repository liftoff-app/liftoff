import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../util/api_extensions.dart';
import '../widgets/markdown_text.dart';

class UsersListPage extends StatelessWidget {
  final String title;
  final List<UserView> users;

  const UsersListPage({Key key, @required this.users, this.title})
      : assert(users != null),
        super(key: key);

  void goToUser(BuildContext context, int id) {
    print('GO TO USER $id');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(title ?? '', style: theme.textTheme.headline6),
          centerTitle: true,
          backgroundColor: theme.cardColor,
          iconTheme: theme.iconTheme,
        ),
        body: ListView.builder(
          itemBuilder: (context, i) => ListTile(
            title: Text((users[i].preferredUsername == null ||
                    users[i].preferredUsername.isEmpty)
                ? '@${users[i].name}'
                : users[i].preferredUsername),
            subtitle: users[i].bio != null
                ? Opacity(
                    opacity: 0.5,
                    child: MarkdownText(
                      users[i].bio,
                      instanceUrl: users[i].instanceUrl,
                    ),
                  )
                : null,
            onTap: () => goToUser(context, users[i].id),
            leading: users[i].avatar != null
                ? CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: users[i].avatar,
                    errorWidget: (_, __, ___) =>
                        SizedBox(height: 50, width: 50),
                    imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover, image: imageProvider),
                          ),
                        ))
                : SizedBox(width: 50),
          ),
          itemCount: users.length,
        ));
  }
}

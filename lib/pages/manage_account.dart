import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/stores.dart';

class ManageAccount extends HookWidget {
  final String instanceHost;
  final String username;

  const ManageAccount({@required this.instanceHost, @required this.username})
      : assert(instanceHost != null),
        assert(username != null);

  @override
  Widget build(BuildContext context) {
    final accountStore = useAccountsStore();
    final theme = Theme.of(context);

    final displayNameController = useTextEditingController();
    final bioController = useTextEditingController();
    final emailController = useTextEditingController();

    final userViewFuture = useMemoized(() async {
      final userDetails = await LemmyApi(instanceHost).v1.getUserDetails(
          sort: SortType.active,
          savedOnly: false,
          auth: accountStore.tokens[instanceHost][username].raw,
          username: username);

      return userDetails.user;
    });

    final uploadButton = ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          visualDensity: VisualDensity.comfortable,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: const [Text('upload'), Icon(Icons.publish)],
        ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        brightness: theme.brightness,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title:
            Text('$instanceHost@$username', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: FutureBuilder<UserView>(
        future: userViewFuture,
        builder: (_, userViewSnap) {
          if (userViewSnap.hasError) {
            return Center(
                child: Text('Error: ${userViewSnap.error?.toString()}'));
          }
          if (!userViewSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userView = userViewSnap.data;

          bioController.text = userView.bio;
          displayNameController.text = userView.preferredUsername;
          emailController.text = userView.email;

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Avatar', style: theme.textTheme.headline6),
                  uploadButton
                ],
              ),
              if (userView.avatar != null)
                CachedNetworkImage(
                  imageUrl: userView.avatar,
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Banner', style: theme.textTheme.headline6),
                  uploadButton
                ],
              ),
              if (userView.banner != null)
                CachedNetworkImage(
                  imageUrl: userView.banner,
                  errorWidget: (_, __, ___) => const Icon(Icons.error),
                ),
              Text('Display Name', style: theme.textTheme.headline6),
              TextField(
                controller: displayNameController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text('Bio', style: theme.textTheme.headline6),
              TextField(
                controller: bioController,
                minLines: 4,
                maxLines: 10,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text('Email', style: theme.textTheme.headline6),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  visualDensity: VisualDensity.comfortable,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('DELETE ACCOUNT'),
              ),
            ],
          );
        },
      ),
    );
  }
}

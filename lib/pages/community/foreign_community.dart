import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import 'community.dart';

class ForeignCommunityPage extends HookWidget {
  final UserData userData;
  final String community;

  const ForeignCommunityPage(this.userData, this.community);

  @override
  Widget build(BuildContext context) {
    final lemmyApi = LemmyApiV3(userData.instanceHost);

    return FutureBuilder(
      future: lemmyApi
          .run(ResolveObject(q: community, auth: userData.jwt.raw))
          .then((data) {
        Navigator.of(context).pop();
        Navigator.of(context).push(CommunityPage.fromIdRoute(
            userData.instanceHost, data.community!.community.id));
      }),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(),
            body: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(height: 36),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                    Container(height: 24),
                    Text(
                      snapshot.hasError
                          ? 'Error: ${snapshot.error}'
                          : L10n.of(context).foreign_community_info,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )));
      },
    );
  }
}

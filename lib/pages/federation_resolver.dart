import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';

class FederationResolver extends HookWidget {
  final UserData userData;
  final String query;
  final String loadingMessage;
  final bool Function(ResolveObjectResponse response) exists;
  final Widget Function(BuildContext buildContext, ResolveObjectResponse object)
      builder;

  const FederationResolver({
    super.key,
    required this.userData,
    required this.query,
    required this.loadingMessage,
    required this.builder,
    required this.exists,
  });

  @override
  Widget build(BuildContext context) {
    final lemmyApi = LemmyApiV3(userData.instanceHost);

    return FutureBuilder(
      future: lemmyApi.run(ResolveObject(q: query, auth: userData.jwt.raw)),
      builder: (context, snapshot) {
        var message = loadingMessage;

        if (snapshot.hasData) {
          if (exists(snapshot.data!)) {
            return Builder(
                builder: (context) => builder(context, snapshot.data!));
          } else {
            message = L10n.of(context).not_found;
          }
        }

        if (snapshot.hasError) {
          message = 'Error: ${snapshot.error}';
        }

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
                      message,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )));
      },
    );
  }
}

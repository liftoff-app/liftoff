import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../pages/settings.dart';
import '../util/goto.dart';
import 'stores.dart';

Function(Function(Jwt token) action) useLoggedInAction(
  String instanceUrl, [
  String message,
]) {
  final context = useContext();
  final store = useAccountsStore();

  return (Function(Jwt token) action) {
    if (store.isAnonymousFor(instanceUrl)) {
      return () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(message ?? 'you gotta be logged in to do that'),
          action: SnackBarAction(
              label: 'log in',
              onPressed: () => goTo(context, (_) => AccountsConfigPage())),
        ));
      };
    }
    final token = store.defaultTokenFor(instanceUrl);
    return () => action(token);
  };
}

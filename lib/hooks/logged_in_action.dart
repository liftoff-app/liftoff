import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../pages/settings.dart';
import '../util/goto.dart';
import 'stores.dart';

/// If user has an account for the given instance the passed wrapper will call
/// the passed action with a Jwt token. Otherwise the action is ignored and a
/// Snackbar is rendered. If [any] is set to true, this check is performed for
/// all instances and if any of them have an account, the wrapped action will be
/// called with a null token.
Function(
  Function(Jwt token) action, [
  String message,
]) useLoggedInAction(String instanceUrl, {bool any = false}) {
  final context = useContext();
  final store = useAccountsStore();

  return (Function(Jwt token) action, [message]) {
    if (any && store.hasNoAccount ||
        !any && store.isAnonymousFor(instanceUrl)) {
      return () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(message ?? 'you have to be logged in to do that'),
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

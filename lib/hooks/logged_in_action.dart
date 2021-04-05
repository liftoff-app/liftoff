import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../pages/settings.dart';
import '../util/goto.dart';
import 'stores.dart';

/// If user has an account for the given instance the passed wrapper will call
/// the passed action with a Jwt token. Otherwise the action is ignored and a
/// Snackbar is rendered. If [any] is set to true, this check is performed for
/// all instances and if any of them have an account, the wrapped action will be
/// called with a null token.

VoidCallback Function(
  void Function(Jwt token) action, [
  String message,
]) useLoggedInAction(String instanceHost, {bool any = false}) {
  final context = useContext();
  final store = useAccountsStore();

  return (action, [message]) {
    if (any && store.hasNoAccount ||
        !any && store.isAnonymousFor(instanceHost)) {
      return () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message ?? 'you have to be logged in to do that'),
          action: SnackBarAction(
              label: 'log in',
              onPressed: () => goTo(context, (_) => AccountsConfigPage())),
        ));
      };
    }
    final token = store.defaultTokenFor(instanceHost);
    return () => action(token);
  };
}

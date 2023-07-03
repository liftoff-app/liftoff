import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../pages/settings/settings.dart';
import '../util/goto.dart';
import 'stores.dart';

/// If user has an account for the given instance the passed wrapper will call
/// the passed action with a Jwt token. Otherwise the action is ignored and a
/// Snackbar is rendered. If [any] is set to true, this check is performed for
/// all instances and if any of them have an account, the wrapped action will be
/// called with a null token.

VoidCallback Function(
  void Function(Jwt token) action, [
  String? message,
]) useAnyLoggedInAction() {
  final context = useContext();
  final store = useAccountsStore();

  return (action, [message]) {
    if (store.hasNoAccount) {
      return () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              message ?? 'You have to add an account and log in to do that'),
          action: SnackBarAction(
              label: 'log in',
              onPressed: () => goTo(context, (_) => AccountsConfigPage())),
        ));
      };
    }
    return () => action(store.defaultUserData!.jwt);
  };
}

VoidCallback Function(
  void Function(Jwt token) action, [
  String? message,
]) useLoggedInAction(String instanceHost) {
  final context = useContext();
  final store = useAccountsStore();

  return (action, [message]) {
    if (store.isAnonymousFor(instanceHost)) {
      return () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 7),
          content: Text(message ??
              'This thread was retrieved via $instanceHost.\nYou are not logged in there.'),
          action: SnackBarAction(
              label: 'log in',
              onPressed: () => goTo(context, (_) => AccountsConfigPage())),
        ));
      };
    }
    final token = store.defaultUserDataFor(instanceHost)!.jwt;
    return () => action(token);
  };
}

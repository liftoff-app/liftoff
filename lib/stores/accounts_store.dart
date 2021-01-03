import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/unawaited.dart';
import 'shared_pref_keys.dart';

/// Store that manages all accounts
class AccountsStore extends ChangeNotifier {
  /// Map containing JWT tokens of specific users.
  /// If a token is in this map, the user is considered logged in
  /// for that account.
  /// `tokens['instanceHost']['username']`
  HashMap<String, HashMap<String, Jwt>> get tokens => _tokens;
  HashMap<String, HashMap<String, Jwt>> _tokens;

  /// default account for a given instance
  /// map where keys are instanceHosts and values are usernames
  HashMap<String, String> _defaultAccounts;

  /// default account for the app
  /// It is in a form of `username@instanceHost`
  String _defaultAccount;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    // I barely understand what I did. Long story short it casts a
    // raw json into a nested ObservableMap
    nestedMapsCast<T>(T f(Map<String, dynamic> json)) => HashMap.of(
          (jsonDecode(prefs.getString(SharedPrefKeys.tokens) ??
                  '{"lemmy.ml":{}}') as Map<String, dynamic>)
              ?.map(
            (k, e) => MapEntry(
              k,
              HashMap.of(
                (e as Map<String, dynamic>)?.map(
                  (k, e) => MapEntry(
                      k, e == null ? null : f(e as Map<String, dynamic>)),
                ),
              ),
            ),
          ),
        );

    // set saved settings or create defaults
    _tokens = nestedMapsCast((json) => Jwt(json['raw'] as String));
    _defaultAccount = prefs.getString(SharedPrefKeys.defaultAccount);
    _defaultAccounts = HashMap.of(Map.castFrom(
      jsonDecode(prefs.getString(SharedPrefKeys.defaultAccounts) ?? 'null')
              as Map<dynamic, dynamic> ??
          {},
    ));

    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(SharedPrefKeys.defaultAccount, _defaultAccount);
    await prefs.setString(
        SharedPrefKeys.defaultAccounts, jsonEncode(_defaultAccounts));
    await prefs.setString(SharedPrefKeys.tokens, jsonEncode(tokens));
  }

  /// automatically sets default accounts
  void _assignDefaultAccounts() {
    // remove dangling defaults
    _defaultAccounts.entries.map((dft) {
      final instance = dft.key;
      final username = dft.value;
      // if instance or username doesn't exist, remove
      if (!instances.contains(instance) ||
          !tokens[instance].containsKey(username)) {
        return instance;
      }
    }).forEach(_defaultAccounts.remove);
    if (_defaultAccount != null) {
      final instance = _defaultAccount.split('@')[1];
      final username = _defaultAccount.split('@')[0];
      // if instance or username doesn't exist, remove
      if (!instances.contains(instance) ||
          !tokens[instance].containsKey(username)) {
        _defaultAccount = null;
      }
    }

    // set local defaults
    for (final instanceHost in instances) {
      // if this instance is not in defaults
      if (!_defaultAccounts.containsKey(instanceHost)) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceHost)) {
          setDefaultAccountFor(instanceHost, tokens[instanceHost].keys.first);
        }
      }
    }

    // set global default
    if (_defaultAccount == null) {
      // select first account of first instance
      for (final instanceHost in instances) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceHost)) {
          setDefaultAccount(instanceHost, tokens[instanceHost].keys.first);
        }
      }
    }
  }

  String get defaultUsername {
    if (_defaultAccount == null) {
      return null;
    }

    return _defaultAccount.split('@')[0];
  }

  String get defaultInstanceHost {
    if (_defaultAccount == null) {
      return null;
    }

    return _defaultAccount.split('@')[1];
  }

  String defaultUsernameFor(String instanceHost) {
    if (isAnonymousFor(instanceHost)) {
      return null;
    }

    return _defaultAccounts[instanceHost];
  }

  Jwt get defaultToken {
    if (_defaultAccount == null) {
      return null;
    }

    final userTag = _defaultAccount.split('@');
    return tokens[userTag[1]][userTag[0]];
  }

  Jwt defaultTokenFor(String instanceHost) {
    if (isAnonymousFor(instanceHost)) {
      return null;
    }

    return tokens[instanceHost][_defaultAccounts[instanceHost]];
  }

  /// sets globally default account
  void setDefaultAccount(String instanceHost, String username) {
    _defaultAccount = '$username@$instanceHost';

    notifyListeners();
    save();
  }

  /// sets default account for given instance
  void setDefaultAccountFor(String instanceHost, String username) {
    _defaultAccounts[instanceHost] = username;

    notifyListeners();
    save();
  }

  /// An instance is considered anonymous if it was not
  /// added or there are no accounts assigned to it.
  bool isAnonymousFor(String instanceHost) {
    if (!instances.contains(instanceHost)) {
      return true;
    }

    return tokens[instanceHost].isEmpty;
  }

  /// `true` if no added instance has an account assigned to it
  bool get hasNoAccount => loggedInInstances.isEmpty;

  Iterable<String> get instances => tokens.keys;

  Iterable<String> get loggedInInstances =>
      instances.where((e) => !isAnonymousFor(e));

  /// adds a new account
  /// if it's the first account ever the account is
  /// set as default for the app
  /// if it's the first account for an instance the account is
  /// set as default for that instance
  Future<void> addAccount(
    String instanceHost,
    String usernameOrEmail,
    String password,
  ) async {
    if (!instances.contains(instanceHost)) {
      throw Exception('No such instance was added');
    }

    final lemmy = LemmyApi(instanceHost).v1;

    final token = await lemmy.login(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );
    final userData =
        await lemmy.getSite(auth: token.raw).then((value) => value.myUser);

    tokens[instanceHost][userData.name] = token;

    _assignDefaultAccounts();
    notifyListeners();
    unawaited(save());
  }

  /// adds a new instance with no accounts associated with it.
  /// Additionally makes a test `GET /site` request to check if the instance exists.
  /// Check is skipped when [assumeValid] is `true`
  Future<void> addInstance(
    String instanceHost, {
    bool assumeValid = false,
  }) async {
    if (instances.contains(instanceHost)) {
      throw Exception('This instance has already been added');
    }

    if (!assumeValid) {
      try {
        await LemmyApi(instanceHost).v1.getSite();
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {
        throw Exception('This instance seems to not exist');
      }
    }

    tokens[instanceHost] = HashMap();

    _assignDefaultAccounts();
    notifyListeners();
    unawaited(save());
  }

  /// This also removes all accounts assigned to this instance
  void removeInstance(String instanceHost) {
    tokens.remove(instanceHost);

    _assignDefaultAccounts();
    notifyListeners();
    save();
  }

  void removeAccount(String instanceHost, String username) {
    tokens[instanceHost].remove(username);

    _assignDefaultAccounts();
    notifyListeners();
    save();
  }
}

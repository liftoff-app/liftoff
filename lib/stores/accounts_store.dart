import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lemmy_api_client/v2.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/unawaited.dart';

part 'accounts_store.g.dart';

/// Store that manages all accounts
@JsonSerializable()
class AccountsStore extends ChangeNotifier {
  static const prefsKey = 'v1:AccountsStore';
  static final _prefs = SharedPreferences.getInstance();

  /// Map containing JWT tokens of specific users.
  /// If a token is in this map, the user is considered logged in
  /// for that account.
  /// `tokens['instanceHost']['username']`
  @protected
  @JsonKey(defaultValue: {'lemmy.ml': {}})
  Map<String, Map<String, Jwt>> tokens;

  /// default account for a given instance
  /// map where keys are instanceHosts and values are usernames
  @protected
  @JsonKey(defaultValue: {})
  Map<String, String> defaultAccounts;

  /// default account for the app
  /// It is in a form of `username@instanceHost`
  @protected
  String defaultAccount;

  static Future<AccountsStore> load() async {
    final prefs = await _prefs;

    return _$AccountsStoreFromJson(
      jsonDecode(prefs.getString(prefsKey) ?? '{}') as Map<String, dynamic>,
    );
  }

  Future<void> save() async {
    final prefs = await _prefs;

    await prefs.setString(prefsKey, jsonEncode(_$AccountsStoreToJson(this)));
  }

  /// automatically sets default accounts
  void _assignDefaultAccounts() {
    // remove dangling defaults
    defaultAccounts.entries
        .map((dft) {
          final instance = dft.key;
          final username = dft.value;
          // if instance or username doesn't exist, remove
          if (!instances.contains(instance) ||
              !usernamesFor(instance).contains(username)) {
            return instance;
          }
        })
        .toList()
        .forEach(defaultAccounts.remove);
    if (defaultAccount != null) {
      final instance = defaultAccount.split('@')[1];
      final username = defaultAccount.split('@')[0];
      // if instance or username doesn't exist, remove
      if (!instances.contains(instance) ||
          !usernamesFor(instance).contains(username)) {
        defaultAccount = null;
      }
    }

    // set local defaults
    for (final instanceHost in instances) {
      // if this instance is not in defaults
      if (!defaultAccounts.containsKey(instanceHost)) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceHost)) {
          setDefaultAccountFor(instanceHost, usernamesFor(instanceHost).first);
        }
      }
    }

    // set global default
    if (defaultAccount == null) {
      // select first account of first instance
      for (final instanceHost in instances) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceHost)) {
          setDefaultAccount(instanceHost, usernamesFor(instanceHost).first);
        }
      }
    }
  }

  String get defaultUsername {
    if (defaultAccount == null) {
      return null;
    }

    return defaultAccount.split('@')[0];
  }

  String get defaultInstanceHost {
    if (defaultAccount == null) {
      return null;
    }

    return defaultAccount.split('@')[1];
  }

  String defaultUsernameFor(String instanceHost) {
    if (isAnonymousFor(instanceHost)) {
      return null;
    }

    return defaultAccounts[instanceHost];
  }

  Jwt get defaultToken {
    if (defaultAccount == null) {
      return null;
    }

    final userTag = defaultAccount.split('@');
    return tokens[userTag[1]][userTag[0]];
  }

  Jwt defaultTokenFor(String instanceHost) {
    if (isAnonymousFor(instanceHost)) {
      return null;
    }

    return tokens[instanceHost][defaultAccounts[instanceHost]];
  }

  /// returns token for user of a certain id
  Jwt tokenForId(String instanceHost, int userId) =>
      tokens.containsKey(instanceHost)
          ? tokens[instanceHost]
              .values
              .firstWhere((val) => val.payload.id == userId, orElse: () => null)
          : null;

  Jwt tokenFor(String instanceHost, String username) {
    if (!usernamesFor(instanceHost).contains(username)) {
      return null;
    }

    return tokens[instanceHost][username];
  }

  /// sets globally default account
  void setDefaultAccount(String instanceHost, String username) {
    defaultAccount = '$username@$instanceHost';

    notifyListeners();
    save();
  }

  /// sets default account for given instance
  void setDefaultAccountFor(String instanceHost, String username) {
    defaultAccounts[instanceHost] = username;

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

  /// Usernames that are assigned to a given instance
  Iterable<String> usernamesFor(String instanceHost) =>
      tokens[instanceHost].keys;

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

    final lemmy = LemmyApiV2(instanceHost);
    final token = await lemmy.run(Login(
      usernameOrEmail: usernameOrEmail,
      password: password,
    ));
    final userData =
        await lemmy.run(GetSite(auth: token.raw)).then((value) => value.myUser);

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
        await LemmyApiV2(instanceHost).run(const GetSite());
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

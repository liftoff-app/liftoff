import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'accounts_store.g.dart';

/// Store that manages all accounts
@JsonSerializable()
class AccountsStore extends ChangeNotifier {
  static const prefsKey = 'v4:AccountsStore';
  static final _prefs = SharedPreferences.getInstance();

  /// Map containing user data (jwt token, userId) of specific accounts.
  /// If a token is in this map, the user is considered logged in
  /// for that account.
  /// `accounts['instanceHost']['username']`
  @protected
  @JsonKey(defaultValue: {'lemmy.world': {}})
  late Map<String, Map<String, UserData>> accounts;

  /// default account for a given instance
  /// map where keys are instanceHosts and values are usernames
  @protected
  @JsonKey(defaultValue: {})
  late Map<String, String> defaultAccounts;

  /// default account for the app
  /// It is in a form of `username@instanceHost`
  @protected
  String? defaultAccount;

  static Future<AccountsStore> load() async {
    final prefs = await _prefs;

    // Migrate old accounts store which didn't store instanceHost or username.
    final accountsStoreJson =
        jsonDecode(prefs.getString(prefsKey) ?? '{}') as Map<String, dynamic>;

    if (accountsStoreJson.containsKey('accounts')) {
      final accountsJson =
          accountsStoreJson['accounts'] as Map<String, dynamic>;

      for (final instanceEntry in accountsJson.entries) {
        for (final accountEntry in instanceEntry.value.entries) {
          if (!accountEntry.value.containsKey('instanceHost') ||
              !accountEntry.value.containsKey('username')) {
            accountEntry.value['instanceHost'] = instanceEntry.key;
            accountEntry.value['username'] = accountEntry.key;
          }
        }
      }
    }

    return _$AccountsStoreFromJson(accountsStoreJson);
  }

  Future<void> save() async {
    final prefs = await _prefs;

    await prefs.setString(prefsKey, jsonEncode(_$AccountsStoreToJson(this)));
  }

  /// automatically sets default accounts
  Future<void> _assignDefaultAccounts() async {
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
      final instance = defaultAccount!.split('@')[1];
      final username = defaultAccount!.split('@')[0];
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
          await setDefaultAccountFor(
              instanceHost, usernamesFor(instanceHost).first);
        }
      }
    }

    // set global default
    if (defaultAccount == null) {
      // select first account of first instance
      for (final instanceHost in instances) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceHost)) {
          await setDefaultAccount(
              instanceHost, usernamesFor(instanceHost).first);
        }
      }
    }
  }

  String? get defaultUsername => defaultAccount?.split('@')[0];

  String? get defaultInstanceHost => defaultAccount?.split('@')[1];

  UserData? get defaultUserData {
    if (defaultAccount == null) {
      return null;
    }

    final userTag = defaultAccount!.split('@');
    return accounts[userTag[1]]?[userTag[0]];
  }

  String? defaultUsernameFor(String instanceHost) {
    if (isAnonymousFor(instanceHost)) {
      return null;
    }

    return defaultAccounts[instanceHost];
  }

  UserData? defaultUserDataFor(String instanceHost) {
    if (isAnonymousFor(instanceHost)) {
      return null;
    }

    return accounts[instanceHost]?[defaultAccounts[instanceHost]];
  }

  UserData? userDataFor(String instanceHost, String username) {
    if (!usernamesFor(instanceHost).contains(username)) {
      return null;
    }

    return accounts[instanceHost]?[username];
  }

  List<UserData> allUserDataFor(String instanceHost) {
    if (!accounts.containsKey(instanceHost)) {
      return [];
    }

    return [
      for (final account in accounts[instanceHost]!.keys) ...[
        userDataFor(instanceHost, account)!
      ]
    ];
  }

  /// sets globally default account
  Future<void> setDefaultAccount(String instanceHost, String username) {
    defaultAccount = '$username@$instanceHost';

    notifyListeners();
    return save();
  }

  /// clear the globally default account
  Future<void> clearDefaultAccount() {
    defaultAccount = null;

    notifyListeners();
    return save();
  }

  /// sets default account for given instance
  Future<void> setDefaultAccountFor(String instanceHost, String username) {
    defaultAccounts[instanceHost] = username;

    notifyListeners();
    return save();
  }

  /// An instance is considered anonymous if it was not
  /// added or there are no accounts assigned to it.
  bool isAnonymousFor(String instanceHost) {
    if (!instances.contains(instanceHost)) {
      return true;
    }

    return accounts[instanceHost]!.isEmpty;
  }

  /// `true` if no added instance has an account assigned to it
  bool get hasNoAccount => loggedInInstances.isEmpty;

  Iterable<String> get instances => accounts.keys;

  Iterable<String> get loggedInInstances =>
      instances.where((e) => !isAnonymousFor(e));

  /// Usernames that are assigned to a given instance
  Iterable<String> usernamesFor(String instanceHost) =>
      accounts[instanceHost]?.keys ?? const Iterable.empty();

  /// adds a new account
  /// if it's the first account ever the account is
  /// set as default for the app
  /// if it's the first account for an instance the account is
  /// set as default for that instance
  Future<void> addAccount(
    String instanceHost,
    String usernameOrEmail,
    String password,
    String totp2faToken,
  ) async {
    if (!instances.contains(instanceHost)) {
      throw Exception('No such instance was added');
    }

    final lemmy = LemmyApiV3(instanceHost);
    final response = await lemmy.run(Login(
      usernameOrEmail: usernameOrEmail,
      password: password,
      totp2faToken: totp2faToken,
    ));
    final jwt = response.jwt;
    if (jwt == null) {
      if (response.verifyEmailSent) {
        throw const VerifyEmailException();
      } else if (response.registrationCreated) {
        throw const RegistrationApplicationSentException();
      }
      throw Exception('Unknown error'); // should never happen
    }
    final userData = await lemmy
        .run(GetSite(auth: jwt.raw))
        .then((value) => value.myUser!.localUserView.person);

    accounts[instanceHost]![userData.name] = UserData(
      jwt: jwt,
      userId: userData.id,
      instanceHost: instanceHost,
      username: userData.name,
    );

    await _assignDefaultAccounts();
    notifyListeners();
    return save();
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
        await LemmyApiV3(instanceHost).run(const GetSite());
      } catch (_) {
        throw Exception('This instance seems to not exist');
      }
    }

    accounts[instanceHost] = HashMap();

    await _assignDefaultAccounts();
    notifyListeners();
    return save();
  }

  /// This also removes all accounts assigned to this instance
  Future<void> removeInstance(String instanceHost) async {
    accounts.remove(instanceHost);

    await _assignDefaultAccounts();
    notifyListeners();
    return save();
  }

  Future<void> removeAccount(String instanceHost, String username) async {
    if (!accounts.containsKey(instanceHost)) {
      throw Exception("instance doesn't exist");
    }

    accounts[instanceHost]!.remove(username);

    await _assignDefaultAccounts();
    notifyListeners();
    return save();
  }
}

/// Stores data associated with a logged in user
@JsonSerializable()
class UserData {
  final Jwt jwt;
  final int userId;
  final String username;
  final String instanceHost;

  const UserData({
    required this.jwt,
    required this.userId,
    required this.username,
    required this.instanceHost,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
//if (data.verify_email_sent) {
//   toast(i18n.t("verify_email_sent"));
// }
// if (data.registration_created) {
//   toast(i18n.t("registration_application_sent"));
// }

class VerifyEmailException implements Exception {
  final message = 'verify_email_sent';
  const VerifyEmailException();
}

class RegistrationApplicationSentException implements Exception {
  final message = 'registration_application_sent';
  const RegistrationApplicationSentException();
}

import 'dart:convert';

import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'accounts_store.g.dart';

class AccountsStore extends _AccountsStore with _$AccountsStore {}

abstract class _AccountsStore with Store {
  ReactionDisposer _saveReactionDisposer;
  ReactionDisposer _pickDefaultsDisposer;

  _AccountsStore() {
    // persistently save settings each time they are changed
    _saveReactionDisposer = reaction(
      (_) => [
        users.forEach((k, submap) =>
            MapEntry(k, submap.forEach((k2, v2) => MapEntry(k2, v2)))),
        tokens.forEach((k, submap) =>
            MapEntry(k, submap.forEach((k2, v2) => MapEntry(k2, v2)))),
        _defaultAccount,
        _defaultAccounts.asObservable(),
      ],
      (_) => save(),
    );

    // check if there's a default profile and if not, select one
    _pickDefaultsDisposer = reaction(
      (_) => [
        users.forEach((k, submap) =>
            MapEntry(k, submap.forEach((k2, v2) => MapEntry(k2, v2)))),
        tokens.forEach((k, submap) =>
            MapEntry(k, submap.forEach((k2, v2) => MapEntry(k2, v2)))),
      ],
      (_) => _assignDefaultAccounts(),
    );
  }

  @action
  void _assignDefaultAccounts() {
    // remove dangling defaults
    _defaultAccounts.entries.map((dft) {
      final instance = dft.key;
      final username = dft.value;
      // if instance or username doesn't exist, remove
      if (!users.containsKey(instance) ||
          !users[instance].containsKey(username)) {
        return instance;
      }
    }).forEach(_defaultAccounts.remove);
    if (_defaultAccount != null) {
      final instance = _defaultAccount.split('@')[1];
      final username = _defaultAccount.split('@')[0];
      // if instance or username doesn't exist, remove
      if (!users.containsKey(instance) ||
          !users[instance].containsKey(username)) {
        _defaultAccount = null;
      }
    }

    // set local defaults
    for (final instanceUrl in users.keys) {
      // if this instance is not in defaults
      if (!_defaultAccounts.containsKey(instanceUrl)) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceUrl)) {
          setDefaultAccountFor(instanceUrl, users[instanceUrl].keys.first);
        }
      }
    }

    // set global default
    if (_defaultAccount == null) {
      // select first account of first instance
      for (final instanceUrl in users.keys) {
        // select first account in this instance, if any
        if (!isAnonymousFor(instanceUrl)) {
          setDefaultAccount(instanceUrl, users[instanceUrl].keys.first);
        }
      }
    }
  }

  void dispose() {
    _saveReactionDisposer();
    _pickDefaultsDisposer();
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();

    nestedMapsCast<T>(String key, T f(Map<String, dynamic> json)) =>
        ObservableMap.of(
          (jsonDecode(prefs.getString(key) ?? '{}') as Map<String, dynamic>)
              ?.map(
            (k, e) => MapEntry(
              k,
              ObservableMap.of(
                (e as Map<String, dynamic>)?.map(
                  (k, e) => MapEntry(
                      k, e == null ? null : f(e as Map<String, dynamic>)),
                ),
              ),
            ),
          ),
        );

    // set saved settings or create defaults
    users = nestedMapsCast('users', (json) => User.fromJson(json));
    tokens = nestedMapsCast('tokens', (json) => Jwt(json['raw']));
    _defaultAccount = prefs.getString('defaultAccount');
    _defaultAccounts = ObservableMap.of(Map.castFrom(
        jsonDecode(prefs.getString('defaultAccounts') ?? 'null') ?? {}));
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('defaultAccount', _defaultAccount);
    await prefs.setString('defaultAccounts', jsonEncode(_defaultAccounts));
    await prefs.setString('users', jsonEncode(users));
    await prefs.setString('tokens', jsonEncode(tokens));
  }

  /// if path to tokens map exists, it exists for users as well
  /// `users['instanceUrl']['username']`
  @observable
  ObservableMap<String, ObservableMap<String, User>> users;

  /// if path to users map exists, it exists for tokens as well
  /// `tokens['instanceUrl']['username']`
  @observable
  ObservableMap<String, ObservableMap<String, Jwt>> tokens;

  /// default account for a given instance
  /// map where keys are instanceUrls and values are usernames
  @observable
  ObservableMap<String, String> _defaultAccounts;

  /// default account for the app
  /// username@instanceUrl
  @observable
  String _defaultAccount;

  @computed
  User get defaultUser {
    if (_defaultAccount == null) {
      return null;
    }

    final userTag = _defaultAccount.split('@');
    return users[userTag[1]][userTag[0]];
  }

  @computed
  Jwt get defaultToken {
    if (_defaultAccount == null) {
      return null;
    }

    final userTag = _defaultAccount.split('@');
    return tokens[userTag[1]][userTag[0]];
  }

  User defaultUserFor(String instanceUrl) => Computed(() {
        if (isAnonymousFor(instanceUrl)) {
          return null;
        }

        return users[instanceUrl][_defaultAccounts[instanceUrl]];
      }).value;

  Jwt defaultTokenFor(String instanceUrl) => Computed(() {
        if (isAnonymousFor(instanceUrl)) {
          return null;
        }

        return tokens[instanceUrl][_defaultAccounts[instanceUrl]];
      }).value;

  /// sets globally default account
  @action
  void setDefaultAccount(String instanceUrl, String username) {
    _defaultAccount = '$username@$instanceUrl';
  }

  /// sets default account for given instance
  @action
  void setDefaultAccountFor(String instanceUrl, String username) {
    _defaultAccounts[instanceUrl] = username;
  }

  bool isAnonymousFor(String instanceUrl) => Computed(() {
        if (!instances.contains(instanceUrl)) {
          return true;
        }

        return users[instanceUrl].isEmpty;
      }).value;

  @computed
  bool get hasNoAccount => loggedInInstances.isEmpty;

  @computed
  Iterable<String> get instances => users.keys;

  @computed
  Iterable<String> get loggedInInstances =>
      instances.where((e) => !isAnonymousFor(e));

  /// adds a new account
  /// if it's the first account ever the account is
  /// set as default for the app
  /// if it's the first account for an instance the account is
  /// set as default for that instance
  @action
  Future<void> addAccount(
    String instanceUrl,
    String usernameOrEmail,
    String password,
  ) async {
    if (!users.containsKey(instanceUrl)) {
      throw Exception('No such instance was added');
    }

    final lemmy = LemmyApi(instanceUrl).v1;

    final token = await lemmy.login(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );
    final userData =
        await lemmy.getSite(auth: token.raw).then((value) => value.myUser);

    users[instanceUrl][userData.name] = userData;
    tokens[instanceUrl][userData.name] = token;
  }

  /// adds a new instance with no accounts associated with it.
  /// Additionally makes a test GET /site request to check if the instance exists
  @action
  Future<void> addInstance(
    String instanceUrl, {
    bool assumeValid = false,
  }) async {
    if (users.containsKey(instanceUrl)) {
      throw Exception('This instance has already been added');
    }

    if (!assumeValid) {
      try {
        await LemmyApi(instanceUrl).v1.getSite();
        // ignore: avoid_catches_without_on_clauses
      } catch (_) {
        throw Exception('This instance seems to not exist');
      }
    }

    users[instanceUrl] = ObservableMap();
    tokens[instanceUrl] = ObservableMap();
  }

  @action
  void removeInstance(String instanceUrl) {
    users.remove(instanceUrl);
    tokens.remove(instanceUrl);
  }

  @action
  void removeAccount(String instanceUrl, String username) {
    users[instanceUrl].remove(username);
    tokens[instanceUrl].remove(username);
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/l10n.dart';

part 'config_store.g.dart';

/// Store managing user-level configuration such as theme or language
@JsonSerializable()
class ConfigStore extends ChangeNotifier {
  static const prefsKey = 'v1:ConfigStore';
  static final _prefs = SharedPreferences.getInstance();

  late ThemeMode _theme;
  @JsonKey(defaultValue: ThemeMode.system)
  ThemeMode get theme => _theme;
  set theme(ThemeMode theme) {
    _theme = theme;
    notifyListeners();
    save();
  }

  late bool _amoledDarkMode;
  @JsonKey(defaultValue: false)
  bool get amoledDarkMode => _amoledDarkMode;
  set amoledDarkMode(bool amoledDarkMode) {
    _amoledDarkMode = amoledDarkMode;
    notifyListeners();
    save();
  }

  late Locale _locale;
  // default value is set in the `LocaleSerde.fromJson` method because json_serializable does
  // not accept non-literals as defaultValue
  @JsonKey(fromJson: LocaleSerde.fromJson, toJson: LocaleSerde.toJson)
  Locale get locale => _locale;
  set locale(Locale locale) {
    _locale = locale;
    notifyListeners();
    save();
  }

  late bool _showAvatars;
  @JsonKey(defaultValue: true)
  bool get showAvatars => _showAvatars;
  set showAvatars(bool showAvatars) {
    _showAvatars = showAvatars;
    notifyListeners();
    save();
  }

  late bool _showNsfw;
  @JsonKey(defaultValue: false)
  bool get showNsfw => _showNsfw;
  set showNsfw(bool showNsfw) {
    _showNsfw = showNsfw;
    notifyListeners();
    save();
  }

  late bool _showScores;
  @JsonKey(defaultValue: true)
  bool get showScores => _showScores;
  set showScores(bool showScores) {
    _showScores = showScores;
    notifyListeners();
    save();
  }

  /// Copies over settings from lemmy to [ConfigStore]
  void copyLemmyUserSettings(LocalUserSettings localUserSettings) {
    // themes from lemmy-ui that are dark mode
    // const darkModeLemmyUiThemes = {
    //   'solar',
    //   'cyborg',
    //   'darkly',
    //   'vaporwave-dark',
    //   // TODO: is it dark theme?
    //   'i386',
    // };

    _showAvatars = localUserSettings.showAvatars;
    _showNsfw = localUserSettings.showNsfw;
    // TODO: should these also be imported? If so, how?
    // _theme = darkModeLemmyUiThemes.contains(localUserSettings.theme)
    //     ? ThemeMode.dark
    //     : ThemeMode.light;
    // _locale = L10n.supportedLocales.contains(Locale(localUserSettings.lang))
    //     ? Locale(localUserSettings.lang)
    //     : _locale;
    // TODO: add when it is released
    // _showScores = localUserSettings.showScores;

    // TODO: should these even be supported? Or we should use our own per-community setting
    // SortType defaultSortType
    // PostListingType defaultListingType

    notifyListeners();
    save();
  }

  /// Fetches [LocalUserSettings] and imports them with [.copyLemmyUserSettings]
  Future<void> importLemmyUserSettings(Jwt token) async {
    final site =
        await LemmyApiV3(token.payload.iss).run(GetSite(auth: token.raw));
    copyLemmyUserSettings(site.myUser!.localUser);
  }

  static Future<ConfigStore> load() async {
    final prefs = await _prefs;

    return _$ConfigStoreFromJson(
      jsonDecode(prefs.getString(prefsKey) ?? '{}') as Map<String, dynamic>,
    );
  }

  Future<void> save() async {
    final prefs = await _prefs;

    await prefs.setString(prefsKey, jsonEncode(_$ConfigStoreToJson(this)));
  }
}

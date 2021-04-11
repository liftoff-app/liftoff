import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
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

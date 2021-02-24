import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'config_store.g.dart';

/// Store managing user-level configuration such as theme or language
@JsonSerializable()
class ConfigStore extends ChangeNotifier {
  static const prefsKey = 'v1:ConfigStore';
  static final _prefs = SharedPreferences.getInstance();

  ThemeMode _theme;
  @JsonKey(defaultValue: ThemeMode.system)
  ThemeMode get theme => _theme;
  set theme(ThemeMode theme) {
    _theme = theme;
    notifyListeners();
    save();
  }

  bool _amoledDarkMode;
  @JsonKey(defaultValue: false)
  bool get amoledDarkMode => _amoledDarkMode;
  set amoledDarkMode(bool amoledDarkMode) {
    _amoledDarkMode = amoledDarkMode;
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

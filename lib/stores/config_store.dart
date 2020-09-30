import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'config_store.g.dart';

/// Store managing user-level configuration such as theme or language
class ConfigStore extends _ConfigStore with _$ConfigStore {}

abstract class _ConfigStore with Store {
  ReactionDisposer _saveReactionDisposer;

  _ConfigStore() {
    // persitently save settings each time they are changed
    _saveReactionDisposer = reaction((_) => [theme, amoledDarkMode], (_) {
      save();
    });
  }

  void dispose() {
    _saveReactionDisposer();
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    // load saved settings or create defaults
    theme = _themeModeFromString(prefs.getString('theme') ?? 'system');
    amoledDarkMode = prefs.getBool('amoledDarkMode') ?? false;
  }

  void save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('theme', describeEnum(theme));
    await prefs.setBool('amoledDarkMode', amoledDarkMode);
  }

  @observable
  ThemeMode theme;

  @observable
  bool amoledDarkMode;
}

/// converts string to ThemeMode
ThemeMode _themeModeFromString(String theme) =>
    ThemeMode.values.firstWhere((e) => describeEnum(e) == theme);

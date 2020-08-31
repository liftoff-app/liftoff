import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'config_store.g.dart';

class ConfigStore extends _ConfigStore with _$ConfigStore {}

abstract class _ConfigStore with Store {
  ReactionDisposer _saveReactionDisposer;

  _ConfigStore() {
    // persitently save settings each time they are changed
    _saveReactionDisposer = reaction((_) => [theme], (_) {
      save();
    });
  }

  void dispose() {
    _saveReactionDisposer();
  }

  void load() async {
    var prefs = await SharedPreferences.getInstance();
    // set saved settings or create defaults
    theme = _themeModeFromString(prefs.getString('theme') ?? 'system');
  }

  void save() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('theme', describeEnum(theme));
  }

  @observable
  ThemeMode theme;

  @observable
  MaterialColor accentColor;
}

ThemeMode _themeModeFromString(String theme) =>
    ThemeMode.values.firstWhere((e) => describeEnum(e) == theme);

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Store managing user-level configuration such as theme or language
class ConfigStore extends ChangeNotifier {
  ThemeMode _theme;
  ThemeMode get theme => _theme;
  set theme(ThemeMode theme) {
    _theme = theme;
    notifyListeners();
    save();
  }

  bool _amoledDarkMode;
  bool get amoledDarkMode => _amoledDarkMode;
  set amoledDarkMode(bool amoledDarkMode) {
    _amoledDarkMode = amoledDarkMode;
    notifyListeners();
    save();
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // load saved settings or create defaults
    theme = _themeModeFromString(prefs.getString('theme') ?? 'system');
    amoledDarkMode = prefs.getBool('amoledDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('theme', describeEnum(theme));
    await prefs.setBool('amoledDarkMode', amoledDarkMode);
  }
}

/// converts string to ThemeMode
ThemeMode _themeModeFromString(String theme) =>
    ThemeMode.values.firstWhere((e) => describeEnum(e) == theme);

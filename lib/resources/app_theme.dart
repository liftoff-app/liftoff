import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme extends ChangeNotifier {
  final String themeKey = 'theme';
  final String amoledKey = 'amoled';
  final String primaryKey = 'primary';

  SharedPreferences? _prefs;
  bool _amoled = false;
  ThemeMode _theme = ThemeMode.dark;
  Color _primaryColor = ThemeData().colorScheme.secondary;

  bool get amoled => _amoled;
  ThemeMode get theme => _theme;
  Color get primaryColor => _primaryColor;

  AppTheme() {
    _theme = ThemeMode.dark;
    _loadprefs();
  }

  void switchtheme(ThemeMode theme) {
    _theme = theme;
    if (theme != ThemeMode.dark) {
      _amoled = false;
    }
    _saveprefs();
    notifyListeners();
  }

  void switchamoled() {
    _amoled = !_amoled;
    _saveprefs();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _saveprefs();
    notifyListeners();
  }

  _initiateprefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  _loadprefs() async {
    await _initiateprefs();
    _theme = ThemeMode.values[_prefs?.getInt(themeKey) ?? 2];
    _amoled = _prefs?.getBool(amoledKey) ?? false;

    final defaultPrimary = _theme == ThemeMode.light
        ? ThemeData.light().colorScheme.primary
        : ThemeData.dark().colorScheme.secondary;
    _primaryColor = Color(_prefs?.getInt(primaryKey) ?? defaultPrimary.value);

    notifyListeners();
  }

  _saveprefs() async {
    await _initiateprefs();
    await _prefs?.setInt(themeKey, _theme.index);
    await _prefs?.setBool(amoledKey, _amoled);
    await _prefs?.setInt(primaryKey, _primaryColor.value);
  }
}

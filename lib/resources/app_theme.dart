import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme extends ChangeNotifier {
  final String themeKey = 'theme';
  final String amoledKey = 'amoled';
  final String primaryColorDarkKey = 'primaryColorDark';
  final String primaryColorLightKey = 'primaryColorLight';

  SharedPreferences? _prefs;
  bool _amoled = false;
  late ThemeMode _theme;

  Color _primaryColorDark = ThemeData.dark().colorScheme.secondary;
  Color _primaryColorLight = ThemeData.light().colorScheme.primary;

  // Reports user preference whether to use amoled.
  bool get amoledWanted => _amoled;
  // System decision whether we should be using amoled right now.
  bool get useAmoled => areWeDark && _amoled;
  ThemeMode get theme => _theme;
  Color get primaryColor => areWeDark ? _primaryColorDark : _primaryColorLight;

  AppTheme() {
    _loadprefs();
  }

  bool get isSystemDark =>
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  bool get areWeDark =>
      theme == ThemeMode.dark || (theme == ThemeMode.system && isSystemDark);

  void switchtheme(ThemeMode theme) {
    _theme = theme;

    _saveprefs();
    notifyListeners();
  }

  void switchamoled() {
    _amoled = !_amoled;
    _saveprefs();
    notifyListeners();
  }

  void setPrimaryColor(Color color) {
    if (areWeDark) {
      _primaryColorDark = color;
    } else {
      _primaryColorLight = color;
    }
    _saveprefs();
    notifyListeners();
  }

  _initiateprefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Set sensible default values for ThemeMode and primaryColor
  _loadprefs() async {
    await _initiateprefs();

    // Default new installations to following the system theme.
    final oldMode = _prefs?.getInt(themeKey);
    _theme = (oldMode == null) ? ThemeMode.system : ThemeMode.values[oldMode];

    _amoled = _prefs?.getBool(amoledKey) ?? false;
    _primaryColorDark =
        Color(_prefs?.getInt(primaryColorDarkKey) ?? _primaryColorDark.value);
    _primaryColorLight =
        Color(_prefs?.getInt(primaryColorLightKey) ?? _primaryColorLight.value);
    notifyListeners();
  }

  _saveprefs() async {
    await _initiateprefs();
    await _prefs?.setInt(themeKey, _theme.index);
    await _prefs?.setBool(amoledKey, _amoled);
    await _prefs?.setInt(primaryColorDarkKey, _primaryColorDark.value);
    await _prefs?.setInt(primaryColorLightKey, _primaryColorLight.value);
  }
}

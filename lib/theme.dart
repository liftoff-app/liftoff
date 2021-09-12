import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'util/text_color.dart';

ThemeData _themeFactory({bool dark = false, bool amoled = false}) {
  assert(dark || !amoled, "Can't have amoled without dark mode");

  final theme = dark ? ThemeData.dark() : ThemeData.light();
  final maybeAmoledColor = amoled ? Colors.black : null;

  return theme.copyWith(
    scaffoldBackgroundColor: maybeAmoledColor,
    backgroundColor: maybeAmoledColor,
    canvasColor: maybeAmoledColor,
    cardColor: maybeAmoledColor,
    splashColor: maybeAmoledColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      elevation: 0,
      systemOverlayStyle: theme.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      centerTitle: true,
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      titleTextStyle: theme.textTheme.headline6
          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.grey,
      labelColor: theme.colorScheme.onSurface,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: theme.colorScheme.secondary,
      disabledColor: Colors.amber,
      selectedColor: Colors.amber,
      secondarySelectedColor: Colors.amber,
      padding: EdgeInsets.zero,
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        color: textColorBasedOnBackground(theme.colorScheme.secondary),
      ),
      secondaryLabelStyle: const TextStyle(color: Colors.amber),
      brightness: theme.brightness,
      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: theme.colorScheme.secondary,
        onPrimary: textColorBasedOnBackground(theme.colorScheme.secondary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: theme.colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: TextButton.styleFrom(
        primary: theme.colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}

final lightTheme = _themeFactory();
final darkTheme = _themeFactory(dark: true);
final amoledTheme = _themeFactory(dark: true, amoled: true);

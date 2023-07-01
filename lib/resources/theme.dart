import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/text_color.dart';

ThemeData themeFactory(
    {bool dark = false, bool amoled = false, required Color primaryColor}) {
  assert(dark || !amoled, "Can't have amoled without dark mode");

  var theme = dark ? ThemeData.dark() : ThemeData.light();
  final maybeAmoledColor = amoled ? Colors.black : null;

  theme = theme.copyWith(
    colorScheme: theme.colorScheme
        .copyWith(primary: primaryColor, secondary: primaryColor),
  );

  return theme.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: maybeAmoledColor,
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
      titleTextStyle: theme.textTheme.titleLarge
          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
    ),
    bottomAppBarTheme:
        BottomAppBarTheme(color: maybeAmoledColor, shadowColor: Colors.white),
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
        backgroundColor: theme.colorScheme.background,
        foregroundColor:
            textColorBasedOnBackground(theme.colorScheme.background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: theme.colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: theme.colorScheme.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.onSecondary,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/text_color.dart';

ThemeData themeFactory(
    {bool dark = false, bool amoled = false, required Color primaryColor}) {
  assert(dark || !amoled, "Can't have amoled without dark mode");

  final theme = dark
      ? ThemeData.dark().copyWith(
          colorScheme: ColorScheme.dark(background: Colors.grey[850]!),
          canvasColor: Colors.grey[850],
          cardColor: Colors.grey.shade900)
      : ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(background: Color(0xFFE9EEF8)),
          canvasColor: const Color(0xFFE9EEF8),
        );
  final backgroundColor = amoled ? Colors.black : theme.colorScheme.background;
  final canvasColor = amoled ? Colors.black : theme.canvasColor;
  final cardColor = amoled ? Colors.black : theme.cardColor;
  final splashColor = amoled ? Colors.black : theme.splashColor;

  return theme.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.fuchsia: CupertinoPageTransitionsBuilder(),
      },
    ),
    scaffoldBackgroundColor: backgroundColor,
    canvasColor: canvasColor,
    cardColor: cardColor,
    splashColor: splashColor,
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
    badgeTheme: const BadgeThemeData(
        textColor: Colors.white,
        textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
    bottomAppBarTheme:
        BottomAppBarTheme(color: backgroundColor, shadowColor: Colors.white),
    tabBarTheme: TabBarTheme(
      unselectedLabelColor: Colors.grey,
      labelColor: theme.colorScheme.onSurface,
      indicatorColor: primaryColor,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryColor,
      disabledColor: Colors.amber,
      selectedColor: Colors.amber,
      secondarySelectedColor: Colors.amber,
      padding: EdgeInsets.zero,
      shape: const StadiumBorder(),
      labelStyle: TextStyle(
        color: textColorBasedOnBackground(primaryColor),
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
        backgroundColor: primaryColor,
        foregroundColor: textColorBasedOnBackground(primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor:
            textColorBasedOnBackground(theme.colorScheme.background),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textColorBasedOnBackground(primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(theme.canvasColor),
        foregroundColor: MaterialStateProperty.all(
            textColorBasedOnBackground(theme.canvasColor)),
        side: MaterialStateProperty.all(
            BorderSide(color: textColorBasedOnBackground(theme.canvasColor))),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
                color: textColorBasedOnBackground(theme.canvasColor)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: textColorBasedOnBackground(primaryColor)),
    colorScheme: theme.colorScheme.copyWith(
      primary: primaryColor,
      secondary: primaryColor,
    ),
  );
}

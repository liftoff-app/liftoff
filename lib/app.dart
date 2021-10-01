import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'hooks/stores.dart';
import 'l10n/l10n.dart';
import 'pages/home_page.dart';
import 'theme.dart';

class MyApp extends HookWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final configStore = useConfigStore();

    return KeyboardDismisser(
      child: MaterialApp(
        title: 'lemmur',
        supportedLocales: L10n.supportedLocales,
        localizationsDelegates: L10n.localizationsDelegates,
        themeMode: configStore.theme,
        darkTheme: configStore.amoledDarkMode ? amoledTheme : darkTheme,
        locale: configStore.locale,
        theme: lightTheme,
        home: const HomePage(),
      ),
    );
  }
}

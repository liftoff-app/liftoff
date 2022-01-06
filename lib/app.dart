import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'l10n/l10n.dart';
import 'pages/home_page.dart';
import 'resources/theme.dart';
import 'stores/config_store.dart';
import 'util/observer_consumers.dart';

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: ObserverBuilder<ConfigStore>(
        builder: (context, store) => MaterialApp(
          title: 'lemmur',
          supportedLocales: L10n.supportedLocales,
          localizationsDelegates: L10n.localizationsDelegates,
          themeMode: store.theme,
          darkTheme: store.amoledDarkMode ? amoledTheme : darkTheme,
          locale: store.locale,
          theme: lightTheme,
          home: const HomePage(),
        ),
      ),
    );
  }
}

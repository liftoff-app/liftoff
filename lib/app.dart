import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

import 'l10n/l10n.dart';
import 'pages/home_page.dart';
import 'resources/app_theme.dart';
import 'resources/theme.dart';
import 'stores/config_store.dart';
import 'util/observer_consumers.dart';

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: ChangeNotifierProvider(
        create: (context) => AppTheme(),
        child: Consumer<AppTheme>(
          builder: (context, state, child) {
            return MaterialApp(
              title: 'Liftoff',
              supportedLocales: L10n.supportedLocales,
              localizationsDelegates: L10n.localizationsDelegates,
              themeMode: state.theme,
              darkTheme: state.amoled
                  ? themeFactory(
                      primaryColor: state.primaryColor,
                      dark: true,
                      amoled: true)
                  : themeFactory(primaryColor: state.primaryColor, dark: true),
              locale: context.read<ConfigStore>().locale,
              theme: themeFactory(primaryColor: state.primaryColor),
              home: const HomePage(),
            );
          },
        ),
      ),
    );
  }
}

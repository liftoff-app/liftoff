import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lemmur/pages/profile_tab.dart';
import 'package:provider/provider.dart';

import 'hooks/stores.dart';
import 'stores/accounts_store.dart';
import 'stores/config_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configStore = ConfigStore();
  await configStore.load();

  final accountsStore = AccountsStore();
  await accountsStore.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<ConfigStore>(
          create: (_) => configStore,
          dispose: (_, store) => store.dispose(),
        ),
        Provider<AccountsStore>(
          create: (_) => accountsStore,
          dispose: (_, store) => store.dispose(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final configStore = useConfigStore();

    return Observer(
      builder: (ctx) {
        final maybeAmoledColor =
            configStore.amoledDarkMode ? Colors.black : null;

        return MaterialApp(
          title: 'Lemmur',
          themeMode: configStore.theme,
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: maybeAmoledColor,
            backgroundColor: maybeAmoledColor,
            canvasColor: maybeAmoledColor,
            cardColor: maybeAmoledColor,
            splashColor: maybeAmoledColor,
          ),
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    useEffect(() {
      print('about to change');
      print(theme.scaffoldBackgroundColor);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
      ));

      return null;
    }, [theme.scaffoldBackgroundColor]);

    return UserProfileTab();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:provider/provider.dart';

import 'hooks/stores.dart';
import 'l10n/l10n.dart';
import 'pages/communities_tab.dart';
import 'pages/create_post.dart';
import 'pages/home_tab.dart';
import 'pages/profile_tab.dart';
import 'pages/search_tab.dart';
import 'stores/accounts_store.dart';
import 'stores/config_store.dart';
import 'theme.dart';
import 'util/extensions/brightness.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configStore = await ConfigStore.load();
  final accountsStore = await AccountsStore.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: configStore),
        ChangeNotifierProvider.value(value: accountsStore),
      ],
      child: const MyApp(),
    ),
  );
}

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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage();

  static const List<Widget> pages = [
    HomeTab(),
    CommunitiesTab(),
    SearchTab(),
    UserProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTab = useState(0);

    useEffect(() {
      Future.microtask(
        () => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: theme.brightness.reverse,
        )),
      );

      return null;
    }, [theme.scaffoldBackgroundColor]);

    var tabCounter = 0;

    tabButton(IconData icon) {
      final tabNum = tabCounter++;

      return IconButton(
        icon: Icon(icon),
        color: tabNum == currentTab.value ? theme.colorScheme.secondary : null,
        onPressed: () => currentTab.value = tabNum,
      );
    }

    return Scaffold(
      extendBody: true,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: currentTab.value,
              children: pages,
            ),
          ),
          const SizedBox(height: kMinInteractiveDimension / 2),
        ],
      ),
      floatingActionButton: const CreatePostFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 7,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              tabButton(Icons.home),
              tabButton(Icons.list),
              const SizedBox.shrink(),
              const SizedBox.shrink(),
              tabButton(Icons.search),
              tabButton(Icons.person),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'hooks/stores.dart';
import 'pages/communities_tab.dart';
import 'pages/create_post.dart';
import 'pages/home_tab.dart';
import 'pages/profile_tab.dart';
import 'pages/search_tab.dart';
import 'stores/accounts_store.dart';
import 'stores/config_store.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final configStore = ConfigStore();
  await configStore.load();

  final accountsStore = AccountsStore();
  await accountsStore.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: configStore,
        ),
        ChangeNotifierProvider.value(
          value: accountsStore,
        ),
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

    return MaterialApp(
      title: 'lemmur',
      themeMode: configStore.theme,
      darkTheme: configStore.amoledDarkMode ? amoledTheme : darkTheme,
      theme: lightTheme,
      home: const MyHomePage(),
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
        )),
      );

      return null;
    }, [theme.scaffoldBackgroundColor]);

    var tabCounter = 0;

    tabButton(IconData icon) {
      final tabNum = tabCounter++;

      return IconButton(
        icon: Icon(icon),
        color: tabNum == currentTab.value ? theme.accentColor : null,
        onPressed: () => currentTab.value = tabNum,
      );
    }

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: currentTab.value,
        children: pages,
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

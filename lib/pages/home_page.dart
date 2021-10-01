import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../util/extensions/brightness.dart';
import 'communities_tab.dart';
import 'create_post.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'search_tab.dart';

class HomePage extends HookWidget {
  const HomePage();

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

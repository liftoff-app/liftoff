import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../app_link_handler.dart';
import '../util/extensions/brightness.dart';
import 'communities_tab.dart';
import 'create_post/create_post_fab.dart';
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
    final snackBarShowing = useState(false);

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
      body: AppLinkHandler(Column(
        children: [
          Expanded(
            child: WillPopScope(
                onWillPop: () {
                  if (currentTab.value == 0 && !snackBarShowing.value) {
                    // show snackbar warning
                    snackBarShowing.value = true;
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                          content: Text('Tap back again to leave'),
                        ))
                        .closed
                        .then((SnackBarClosedReason reason) =>
                            snackBarShowing.value = false);

                    return Future(() => false);
                  }
                  if (currentTab.value != 0) {
                    currentTab.value = 0;
                    return Future(() => false);
                  }

                  return Future(() => true);
                },
                child: IndexedStack(
                  index: currentTab.value,
                  children: pages,
                )),
          ),
          const SizedBox(height: kMinInteractiveDimension / 2),
        ],
      )),
      floatingActionButton: Platform.isAndroid ? const CreatePostFab() : null,
      floatingActionButtonLocation:
          Platform.isAndroid ? FloatingActionButtonLocation.centerDocked : null,
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
              if (Platform.isAndroid) const SizedBox.shrink(),
              if (Platform.isAndroid) const SizedBox.shrink(),
              tabButton(Icons.search),
              tabButton(Icons.person),
            ],
          ),
        ),
      ),
    );
  }
}

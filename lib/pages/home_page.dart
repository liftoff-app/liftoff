import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../app_link_handler.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/stores.dart';
import '../util/extensions/brightness.dart';
import 'communities_tab.dart';
import 'create_post/create_post.dart';
import 'create_post/create_post_fab.dart';
import 'full_post/full_post.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'search_tab.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

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
    final accStore = useAccountsStore();
    final loggedInAction = useAnyLoggedInAction();

    useEffect(() {
      Future.microtask(
        () => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarColor: theme.scaffoldBackgroundColor,
          systemNavigationBarIconBrightness: theme.brightness.reverse,
        )),
      );

      return null;
    }, [theme.scaffoldBackgroundColor]);

    useEffect(() {
      accStore.checkNotifications(accStore.defaultUserData);

      return null;
    }, [accStore.defaultInstanceHost]);

    var tabCounter = 0;

    tabButton(IconData icon) {
      final tabNum = tabCounter++;

      return IconButton(
          icon: Icon(icon),
          color:
              tabNum == currentTab.value ? theme.colorScheme.secondary : null,
          onPressed: () async {
            currentTab.value = tabNum;
            await accStore.checkNotifications(accStore.defaultUserData);
          });
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)]),
        child: BottomAppBar(
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
                if (!Platform.isAndroid) // Replaces FAB
                  IconButton(
                    icon: const Icon(Icons.add_box_outlined),
                    onPressed: loggedInAction((_) async {
                      final postView = await Navigator.of(context).push(
                        CreatePostPage.route(),
                      );

                      if (postView != null && context.mounted) {
                        await Navigator.of(context)
                            .push(FullPostPage.fromPostViewRoute(postView));
                      }
                    }),
                  ),
                if (Platform.isAndroid) const SizedBox.shrink(),
                tabButton(Icons.search),
                tabButton(Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

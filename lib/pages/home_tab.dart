import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/infinite_scroll.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../stores/config_store.dart';
import '../util/extensions/api.dart';
import '../util/goto.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/cached_network_image.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/liftoff_app_bar.dart';
import '../widgets/post/post_store.dart';
import '../widgets/sortable_infinite_list.dart';
import 'instance/instance.dart';
import 'settings/add_account_page.dart';
import 'settings/settings.dart';

/// First thing users sees when opening the app
/// Shows list of posts from all or just specific instances
class HomeTab extends HookWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final defaultListingType =
        useStore((ConfigStore store) => store.defaultListingType);
    final showEverythingFeed =
        useStore((ConfigStore store) => store.showEverythingFeed);

    final selectedList = useState(SelectedList(
        instanceHost: accStore.defaultInstanceHost,
        listingType: accStore.hasNoAccount &&
                defaultListingType == PostListingType.subscribed
            ? PostListingType.all
            : defaultListingType));
    final isc = useInfiniteScrollController();
    final theme = Theme.of(context);
    final instancesIcons = useMemoFuture(() async {
      final sites = await Future.wait(accStore.instances.map((e) =>
          LemmyApiV3(e)
              .run<FullSiteView?>(const GetSite())
              .catchError((e) => null)));

      return {
        for (final site in sites)
          if (site != null) site.instanceHost: site.siteView?.site.icon
      };
    });

    // if the current SelectedList points to something that no longer exists
    // switch it to something else
    // cases include:
    // - listingType == subscribed on an instance that has no longer a logged in account
    // - instanceHost of a removed instance
    useEffect(() {
      if ((selectedList.value.instanceHost == null ||
                  accStore.isAnonymousFor(selectedList.value.instanceHost!)) &&
              selectedList.value.listingType == PostListingType.subscribed ||
          !accStore.instances.contains(selectedList.value.instanceHost)) {
        selectedList.value = SelectedList(
          listingType: accStore.hasNoAccount &&
                  defaultListingType == PostListingType.subscribed
              ? PostListingType.all
              : defaultListingType,
        );
      }

      return null;
    }, [
      selectedList.value.instanceHost == null ||
          accStore.isAnonymousFor(selectedList.value.instanceHost!),
      accStore.hasNoAccount,
      accStore.instances.length,
    ]);

    handleListChange() async {
      final val = await showBottomModal<SelectedList>(
        context: context,
        builder: (context) {
          pop(SelectedList thing) => Navigator.of(context).pop(thing);

          final everythingChoices = [
            const ListTile(
              title: Text('EVERYTHING'),
              dense: true,
              contentPadding: EdgeInsets.zero,
              visualDensity:
                  VisualDensity(vertical: VisualDensity.minimumDensity),
              leading: SizedBox.shrink(),
            ),
            ListTile(
              title: Text(
                L10n.of(context).subscribed,
                style: TextStyle(
                  color: accStore.hasNoAccount
                      ? theme.textTheme.bodyLarge?.color?.withOpacity(0.4)
                      : null,
                ),
              ),
              onTap: accStore.hasNoAccount
                  ? null
                  : () => pop(
                        const SelectedList(
                          listingType: PostListingType.subscribed,
                        ),
                      ),
              leading: const SizedBox(width: 20),
            ),
            for (final listingType in [
              PostListingType.local,
              PostListingType.all,
            ])
              ListTile(
                title: Text(listingType.value),
                leading: const SizedBox(width: 20, height: 20),
                onTap: () => pop(SelectedList(listingType: listingType)),
              ),
          ];
          return Column(
            children: [
              const SizedBox(height: 5),
              if (showEverythingFeed) ...everythingChoices,
              for (final instance in accStore.instances) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(),
                ),
                ListTile(
                  title: Text(
                    instance.toUpperCase(),
                    style: TextStyle(
                        color:
                            theme.textTheme.bodyLarge?.color?.withOpacity(0.7)),
                  ),
                  onTap: () => Navigator.of(context).push(
                    InstancePage.route(instance),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                      vertical: VisualDensity.minimumDensity),
                  leading: (instancesIcons.hasData &&
                          instancesIcons.data![instance] != null)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CachedNetworkImage(
                              imageUrl: instancesIcons.data![instance]!,
                              height: 25,
                              width: 25,
                            ),
                          ),
                        )
                      : const SizedBox(width: 30),
                ),
                ListTile(
                  title: Text(
                    L10n.of(context).subscribed,
                    style: TextStyle(
                        color: accStore.isAnonymousFor(instance)
                            ? theme.textTheme.bodyLarge?.color?.withOpacity(0.4)
                            : null),
                  ),
                  onTap: accStore.isAnonymousFor(instance)
                      ? () => Navigator.of(context)
                          .push(AddAccountPage.route(instance))
                      : () => pop(SelectedList(
                            listingType: PostListingType.subscribed,
                            instanceHost: instance,
                          )),
                  leading: const SizedBox(width: 20),
                ),
                ListTile(
                  title: Text(L10n.of(context).local),
                  onTap: () => pop(SelectedList(
                    listingType: PostListingType.local,
                    instanceHost: instance,
                  )),
                  leading: const SizedBox(width: 20),
                ),
                ListTile(
                  title: Text(L10n.of(context).all),
                  onTap: () => pop(SelectedList(
                    listingType: PostListingType.all,
                    instanceHost: instance,
                  )),
                  leading: const SizedBox(width: 20),
                ),
              ],
            ],
          );
        },
      );
      if (val != null) {
        selectedList.value = val;
        // This will be cleared automatically by the fetcher changing,
        // since we set `refreshOnFetcherUpdate` to true.
        // isc.clear();
      }
    }

    final title = () {
      final first = selectedList.value.listingType.tr(context);

      final last = selectedList.value.instanceHost == null
          ? ''
          : '@${selectedList.value.instanceHost}';
      return '$first$last';
    }();

    if (accStore.instances.isEmpty) {
      return const Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Text('there needs to be at least one instance')),
          ],
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: LiftoffAppBar(
          // titleSpacing: 6,
          // iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
          // backgroundColor: theme.canvasColor,
          // titleTextStyle: theme.textTheme.titleLarge
          //     ?.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          title: TextButton(
            style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero)),
            onPressed: handleListChange,
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    // style: Theme.of(context).textTheme.titleLarge,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    textAlign: TextAlign.left,
                  ),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
          // elevation: 0,
          // automaticallyImplyLeading: false,
          // expandedHeight: 50,
          // floating: true,
          // snap: true,
          actions: [
            // if (!Platform.isAndroid) // Replaces FAB
            //   IconButton(
            //     icon: const Icon(Icons.add_box_outlined),
            //     onPressed: loggedInAction((_) async {
            //       final postView = await Navigator.of(context).push(
            //         CreatePostPage.route(),
            //       );

            //       if (postView != null && context.mounted) {
            //         await Navigator.of(context)
            //             .push(FullPostPage.fromPostViewRoute(postView));
            //       }
            //     }),
            //   ),
            // if (accStore.totalNotificationCount > 0)
            //   Badge(
            //     offset: const Offset(-5, 5),
            //     label: Text(accStore.totalNotificationCount.toString()),
            //     child: IconButton(
            //       icon: const Icon(Icons.notifications),
            //       onPressed: () => goTo(context, (_) => const InboxPage()),
            //     ),
            //   )
            // else
            //   IconButton(
            //     icon: const Icon(Icons.notifications),
            //     onPressed: () => goTo(context, (_) => const InboxPage()),
            //   ),
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    leading: Icon(Icons.keyboard_double_arrow_up),
                    title: Text('Back to top'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Refresh'),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ),
                // PopupMenuItem<int>(
                //   value: 2,
                //   child: Text("Logout"),
                // ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                isc.scrollToTop();
              } else if (value == 1) {
                isc.clear();
              } else if (value == 2) {
                goTo(context, (_) => const SettingsPage());
              }
            }),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [];
          },
          // list of images for scrolling
          body: InfiniteHomeList(
            controller: isc,
            selectedList: selectedList.value,
          ),
        ),
      ),
    );
  }
}

/// Infinite list of posts
class InfiniteHomeList extends HookWidget {
  final InfiniteScrollController controller;
  final SelectedList selectedList;

  const InfiniteHomeList({
    super.key,
    required this.selectedList,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final instanceFilter =
        useStore((ConfigStore store) => store.instanceFilter);

    /// fetches post from many instances at once and combines them into a single
    /// list
    ///
    /// Process of combining them works sort of like zip function in python
    Future<List<PostStore>> generalFetcher(
      int page,
      int limit,
      SortType sort,
      PostListingType listingType,
    ) async {
      final instances = () {
        if (listingType == PostListingType.subscribed) {
          return accStore.loggedInInstances;
        }

        return accStore.instances;
      }();

      final futures = [
        for (final instanceHost in instances)
          LemmyApiV3(instanceHost)
              .run(GetPosts(
                type: listingType,
                sort: sort,
                page: page,
                limit: limit,
                savedOnly: false,
                auth: accStore.defaultUserDataFor(instanceHost)?.jwt.raw,
              ))
              .toPostStores()
      ];
      final instancePosts = await Future.wait(futures);
      final longest = instancePosts.map((e) => e.length).reduce(max);

      final unfilteredPosts = [
        for (var i = 0; i < longest; i++)
          for (final posts in instancePosts)
            if (i < posts.length) posts[i]
      ];
      // We assume here that the total list even filtered will be longer
      // than `limit` posts long. If not then the lists ends here.

      final filtered = unfilteredPosts.where((e) => instanceFilter.every((b) =>
          !e.postView.community.originInstanceHost.toLowerCase().contains(b)));

      return filtered.toList();
    }

    Future<List<PostStore>> fetcherFromInstance(
      int page,
      int limit,
      SortType sort,
      String instanceHost,
      PostListingType listingType,
    ) async {
      // Get twice as many as we need, so we will keep the pipeline full,
      // unless the user has blocked 'lemmy', in which case their
      // feed will end early.
      final limitWithBans = instanceFilter.isEmpty ? limit : 2 * limit;
      final unfilteredPosts = await LemmyApiV3(instanceHost)
          .run(GetPosts(
            type: listingType,
            sort: sort,
            page: page,
            limit: limitWithBans,
            savedOnly: false,
            auth: accStore.defaultUserDataFor(instanceHost)?.jwt.raw,
          ))
          .toPostStores();
      final filtered = unfilteredPosts.where((e) => instanceFilter.every((b) =>
          !e.postView.community.originInstanceHost.toLowerCase().contains(b)));

      return filtered.toList();
    }

    final memoizedFetcher = useMemoized(
      () {
        final selectedInstanceHost = selectedList.instanceHost;
        return selectedInstanceHost == null
            ? (page, limit, sort) =>
                generalFetcher(page, limit, sort, selectedList.listingType)
            : (page, limit, sort) => fetcherFromInstance(page, limit, sort,
                selectedInstanceHost, selectedList.listingType);
      },
      [selectedList],
    );

    return InfinitePostList(
      fetcher: memoizedFetcher,
      refreshOnFetcherUpdate: true,
      controller: controller,
    );
  }
}

class SelectedList {
  /// when null it implies the 'EVERYTHING' mode
  final String? instanceHost;
  final PostListingType listingType;

  const SelectedList({
    required this.listingType,
    this.instanceHost,
  });

  @override
  String toString() =>
      'SelectedList(instanceHost: $instanceHost, listingType: $listingType)';
}

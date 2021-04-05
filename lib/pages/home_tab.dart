import 'dart:math' show max;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/infinite_scroll.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/goto.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/sortable_infinite_list.dart';
import 'add_account.dart';
import 'inbox.dart';

/// First thing users sees when opening the app
/// Shows list of posts from all or just specific instances
class HomeTab extends HookWidget {
  const HomeTab();

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();
    final selectedList = useState(_SelectedList(
        listingType: accStore.hasNoAccount
            ? PostListingType.all
            : PostListingType.subscribed));
    final isc = useInfiniteScrollController();
    final theme = Theme.of(context);
    final instancesIcons = useMemoFuture(() async {
      final instances = accStore.instances.toList(growable: false);
      final sites = await Future.wait(instances.map(
          (e) => LemmyApiV3(e).run(const GetSite()).catchError((e) => null)));

      return {
        for (var i = 0; i < sites.length; i++)
          instances[i]: sites[i].siteView.site.icon
      };
    });

    // if the current SelectedList points to something that no longer exists
    // switch it to something else
    // cases include:
    // - listingType == subscribed on an instance that has no longer a logged in account
    // - instanceHost of a removed instance
    useEffect(() {
      if (accStore.isAnonymousFor(selectedList.value.instanceHost) &&
              selectedList.value.listingType == PostListingType.subscribed ||
          !accStore.instances.contains(selectedList.value.instanceHost)) {
        selectedList.value = _SelectedList(
          listingType: accStore.hasNoAccount
              ? PostListingType.all
              : PostListingType.subscribed,
        );
      }

      return null;
    }, [
      accStore.isAnonymousFor(selectedList.value.instanceHost),
      accStore.hasNoAccount,
      accStore.instances.length,
    ]);

    handleListChange() async {
      final val = await showBottomModal<_SelectedList>(
        context: context,
        builder: (context) {
          pop(_SelectedList thing) => Navigator.of(context).pop(thing);

          return Column(
            children: [
              const SizedBox(height: 5),
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
                        ? theme.textTheme.bodyText1.color.withOpacity(0.4)
                        : null,
                  ),
                ),
                onTap: accStore.hasNoAccount
                    ? null
                    : () => pop(
                          const _SelectedList(
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
                  onTap: () => pop(_SelectedList(listingType: listingType)),
                ),
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
                            theme.textTheme.bodyText1.color.withOpacity(0.7)),
                  ),
                  onTap: () => goToInstance(context, instance),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  visualDensity: const VisualDensity(
                      vertical: VisualDensity.minimumDensity),
                  leading: (instancesIcons.hasData &&
                          instancesIcons.data[instance] != null)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: SizedBox(
                            width: 25,
                            height: 25,
                            child: CachedNetworkImage(
                              imageUrl: instancesIcons.data[instance],
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
                            ? theme.textTheme.bodyText1.color.withOpacity(0.4)
                            : null),
                  ),
                  onTap: accStore.isAnonymousFor(instance)
                      ? () => showCupertinoModalPopup(
                          context: context,
                          builder: (_) =>
                              AddAccountPage(instanceHost: instance))
                      : () => pop(_SelectedList(
                            listingType: PostListingType.subscribed,
                            instanceHost: instance,
                          )),
                  leading: const SizedBox(width: 20),
                ),
                ListTile(
                  title: Text(L10n.of(context).local),
                  onTap: () => pop(_SelectedList(
                    listingType: PostListingType.local,
                    instanceHost: instance,
                  )),
                  leading: const SizedBox(width: 20),
                ),
                ListTile(
                  title: Text(L10n.of(context).all),
                  onTap: () => pop(_SelectedList(
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
        isc.clear();
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
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: Text('there needs to be at least one instance')),
          ],
        ),
      );
    }

    return Scaffold(
      // TODO: make appbar autohide when scrolling down
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => goTo(context, (_) => const InboxPage()),
          )
        ],
        title: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15),
          ),
          onPressed: handleListChange,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: theme.appBarTheme.textTheme.headline6,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      body: InfiniteHomeList(
        controller: isc,
        selectedList: selectedList.value,
      ),
    );
  }
}

/// Infinite list of posts
class InfiniteHomeList extends HookWidget {
  final Function onStyleChange;
  final InfiniteScrollController controller;
  final _SelectedList selectedList;

  const InfiniteHomeList({
    @required this.selectedList,
    this.onStyleChange,
    this.controller,
  }) : assert(selectedList != null);

  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();

    /// fetches post from many instances at once and combines them into a single
    /// list
    ///
    /// Process of combining them works sort of like zip function in python
    Future<List<PostView>> generalFetcher(
      int page,
      int limit,
      SortType sort,
      PostListingType listingType,
    ) async {
      assert(
          listingType != PostListingType.community, 'only subscribed or all');

      final instances = () {
        if (listingType == PostListingType.subscribed) {
          return accStore.loggedInInstances;
        }

        return accStore.instances;
      }();

      final futures = [
        for (final instanceHost in instances)
          LemmyApiV3(instanceHost).run(GetPosts(
            type: listingType,
            sort: sort,
            page: page,
            limit: limit,
            savedOnly: false,
            auth: accStore.defaultTokenFor(instanceHost)?.raw,
          ))
      ];
      final instancePosts = await Future.wait(futures);
      final longest = instancePosts.map((e) => e.length).reduce(max);

      final newPosts = [
        for (var i = 0; i < longest; i++)
          for (final posts in instancePosts)
            if (i < posts.length) posts[i]
      ];

      return newPosts;
    }

    FetcherWithSorting<PostView> fetcherFromInstance(
            String instanceHost, PostListingType listingType) =>
        (page, batchSize, sort) => LemmyApiV3(instanceHost).run(GetPosts(
              type: listingType,
              sort: sort,
              page: page,
              limit: batchSize,
              savedOnly: false,
              auth: accStore.defaultTokenFor(instanceHost)?.raw,
            ));

    return InfinitePostList(
      fetcher: selectedList.instanceHost == null
          ? (page, limit, sort) =>
              generalFetcher(page, limit, sort, selectedList.listingType)
          : fetcherFromInstance(
              selectedList.instanceHost, selectedList.listingType),
      controller: controller,
    );
  }
}

class _SelectedList {
  /// when null it implies the 'EVERYTHING' mode
  final String instanceHost;
  final PostListingType listingType;

  const _SelectedList({
    @required this.listingType,
    this.instanceHost,
  }) : assert(listingType != null);

  String toString() =>
      'SelectedList(instanceHost: $instanceHost, listingType: $listingType)';
}

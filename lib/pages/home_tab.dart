import 'dart:math' show max;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/infinite_scroll.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/infinite_scroll.dart';
import '../widgets/post.dart';
import '../widgets/post_list_options.dart';
import 'add_account.dart';
import 'inbox.dart';

class HomeTab extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedList =
        useState(SelectedList(listingType: PostListingType.subscribed));
    // TODO: needs to be an observer? for accounts changes
    final accStore = useAccountsStore();
    final isc = useInfiniteScrollController();
    final theme = Theme.of(context);
    final instancesIcons = useMemoFuture(() async {
      final map = <String, String>{};
      final instances = accStore.instances.toList(growable: false);
      final sites = await Future.wait(instances
          .map((e) => LemmyApi(e).v1.getSite().catchError((e) => null)));
      for (var i in Iterable.generate(sites.length)) {
        map[instances[i]] = sites[i].site.icon;
      }

      return map;
    });

    handleListChange() async {
      final val = await showModalBottomSheet<SelectedList>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          pop(SelectedList thing) => Navigator.of(context).pop(thing);
          return BottomModal(
              child: Column(
            children: [
              SizedBox(height: 5),
              ListTile(
                title: Text('EVERYTHING'),
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity:
                    VisualDensity(vertical: VisualDensity.minimumDensity),
                leading: SizedBox.shrink(),
              ),
              ListTile(
                title: Text('Subscribed'),
                leading: SizedBox(width: 20, height: 20),
                onTap: () =>
                    pop(SelectedList(listingType: PostListingType.subscribed)),
              ),
              ListTile(
                title: Text('All'),
                leading: SizedBox(width: 20, height: 20),
                onTap: () =>
                    pop(SelectedList(listingType: PostListingType.all)),
              ),
              for (final instance in accStore.instances) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  visualDensity:
                      VisualDensity(vertical: VisualDensity.minimumDensity),
                  leading: (instancesIcons.hasData &&
                          instancesIcons.data[instance] != null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 20),
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: CachedNetworkImage(
                                imageUrl: instancesIcons.data[instance],
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ],
                        )
                      : SizedBox(width: 30),
                ),
                ListTile(
                  title: Text(
                    'Subscribed',
                    style: TextStyle(
                        color: accStore.isAnonymousFor(instance)
                            ? theme.textTheme.bodyText1.color.withOpacity(0.4)
                            : null),
                  ),
                  onTap: accStore.isAnonymousFor(instance)
                      ? () => showCupertinoModalPopup(
                          context: context,
                          builder: (_) => AddAccountPage(instanceUrl: instance))
                      : () => pop(SelectedList(
                            listingType: PostListingType.subscribed,
                            instanceUrl: instance,
                          )),
                  leading: SizedBox(width: 20),
                ),
                ListTile(
                  title: Text('All'),
                  onTap: () => pop(SelectedList(
                    listingType: PostListingType.all,
                    instanceUrl: instance,
                  )),
                  leading: SizedBox(width: 20),
                ),
              ]
            ],
          ));
        },
      );
      if (val != null) {
        print(val);
        selectedList.value = val;
        isc.clear();
      }
    }

    final title = () {
      final first = selectedList.value.listingType == PostListingType.subscribed
          ? 'Subscribed'
          : 'All';
      final last = selectedList.value.instanceUrl == null
          ? ''
          : '@${selectedList.value.instanceUrl}';
      return '$first$last';
    }();

    return Scaffold(
      // TODO: make appbar autohide when scrolling down
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => goTo(context, (_) => InboxPage()),
          )
        ],
        centerTitle: true,
        title: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            padding: EdgeInsets.symmetric(horizontal: 15),
            primary: theme.buttonColor,
            textStyle: theme.primaryTextTheme.headline6,
          ),
          onPressed: handleListChange,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: theme.primaryTextTheme.headline6,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: theme.primaryTextTheme.headline6.color,
              ),
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

class InfiniteHomeList extends HookWidget {
  final Function onStyleChange;
  final InfiniteScrollController controller;
  final SelectedList selectedList;
  InfiniteHomeList({
    @required this.selectedList,
    this.onStyleChange,
    this.controller,
  }) : assert(selectedList != null);
  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();

    final sort = useState(SortType.active);

    void changeSorting(SortType newSort) {
      sort.value = newSort;
      controller.clear();
    }

    Future<List<PostView>> ultimateFetcher(
      int page,
      int limit,
      SortType sort,
      PostListingType listingType,
    ) async {
      assert(
          listingType != PostListingType.community, 'only subscribed or all');

      final instances = () {
        if (listingType == PostListingType.all) {
          return accStore.instances;
        } else {
          return accStore.loggedInInstances;
        }
      }();

      final futures =
          instances.map((instanceUrl) => LemmyApi(instanceUrl).v1.getPosts(
                type: listingType,
                sort: sort,
                page: page,
                limit: limit,
                auth: accStore.defaultTokenFor(instanceUrl)?.raw,
              ));
      final posts = (await Future.wait(futures));
      final newPosts = <PostView>[];
      for (final i
          in Iterable.generate(posts.map((e) => e.length).reduce(max))) {
        for (final el in posts) {
          if (el.elementAt(i) != null) {
            newPosts.add(el[i]);
          }
        }
      }
      return newPosts;
    }

    Future<List<PostView>> Function(int, int) _fetcherFromInstance(
        String instanceUrl, PostListingType listingType, SortType sort) {
      return (page, batchSize) => LemmyApi(instanceUrl).v1.getPosts(
            type: listingType,
            sort: sort,
            page: page,
            limit: batchSize,
            auth: accStore.defaultTokenFor(instanceUrl)?.raw,
          );
    }

    return InfiniteScroll<PostView>(
      prepend: Column(
        children: [
          PostListOptions(
            onChange: changeSorting,
            defaultSort: SortType.active,
            styleButton: onStyleChange != null,
          ),
        ],
      ),
      builder: (post) => Column(
        children: [
          Post(post),
          SizedBox(height: 20),
        ],
      ),
      padding: EdgeInsets.zero,
      fetchMore: selectedList.instanceUrl == null
          ? (page, limit) =>
              ultimateFetcher(page, limit, sort.value, selectedList.listingType)
          : _fetcherFromInstance(
              selectedList.instanceUrl,
              selectedList.listingType,
              sort.value,
            ),
      controller: controller,
      batchSize: 20,
    );
  }
}

class SelectedList {
  final String instanceUrl;
  final PostListingType listingType;
  SelectedList({
    @required this.listingType,
    this.instanceUrl,
  });

  String toString() =>
      'SelectedList({instanceUrl: $instanceUrl, listingType: $listingType})';
}

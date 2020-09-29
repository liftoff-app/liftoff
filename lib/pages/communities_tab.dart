import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../util/extensions/iterators.dart';
import '../util/text_color.dart';

class CommunitiesTab extends HookWidget {
  CommunitiesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterController = useTextEditingController();
    useValueListenable(filterController);
    final accountsStore = useAccountsStore();

    final amountOfDisplayInstances =
        useMemoized(() => accountsStore.loggedInInstances.length);
    final isCollapsed = useState(List.filled(amountOfDisplayInstances, false));

    final instancesSnap = useMemoFuture(() {
      final futures = accountsStore.loggedInInstances
          .map(
            (instanceUrl) =>
                LemmyApi(instanceUrl).v1.getSite().then((e) => e.site),
          )
          .toList();

      return Future.wait(futures);
    });
    final communitiesSnap = useMemoFuture(() {
      final futures = accountsStore.loggedInInstances
          .map(
            (instanceUrl) => LemmyApi(instanceUrl)
                .v1
                .getUserDetails(
                  sort: SortType.active,
                  savedOnly: false,
                  userId: accountsStore.defaultTokenFor(instanceUrl).payload.id,
                )
                .then((e) => e.follows),
          )
          .toList();

      return Future.wait(futures);
    });

    if (communitiesSnap.hasError || instancesSnap.hasError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Row(
            children: [
              Icon(Icons.error),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  communitiesSnap.error?.toString() ??
                      instancesSnap.error?.toString(),
                ),
              )
            ],
          ),
        ),
      );
    } else if (!communitiesSnap.hasData || !instancesSnap.hasData) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final instances = instancesSnap.data;
    final communities = communitiesSnap.data
      ..forEach(
          (e) => e.sort((a, b) => a.communityName.compareTo(b.communityName)));

    final filterIcon = () {
      if (filterController.text.isEmpty) {
        return Icon(Icons.filter_list);
      }

      return IconButton(
        onPressed: () {
          filterController.clear();
          primaryFocus.unfocus();
        },
        icon: Icon(Icons.clear),
      );
    }();

    filterCommunities(List<CommunityFollowerView> comm) {
      final matches = Fuzzy(
        comm.map((e) => e.communityName).toList(),
        options: FuzzyOptions(threshold: 0.5),
      ).search(filterController.text).map((e) => e.item);

      return matches
          .map((match) => comm.firstWhere((e) => e.communityName == match));
    }

    toggleCollapse(int i) => isCollapsed.value =
        isCollapsed.value.mapWithIndex((e, j) => j == i ? !e : e).toList();

    // TODO: add observer
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.style),
            onPressed: () {}, // TODO: change styles?
          ),
        ],
        title: TextField(
          controller: filterController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixIcon: filterIcon,
            isDense: true,
            border: OutlineInputBorder(),
            hintText: 'Filter', // TODO: hint with an filter icon
          ),
        ),
      ),
      body: ListView(
        children: [
          for (final i in Iterable.generate(amountOfDisplayInstances))
            Column(
              children: [
                ListTile(
                  onTap: () {}, // TODO: open instance
                  onLongPress: () => toggleCollapse(i),
                  leading: instances[i].icon != null
                      ? CachedNetworkImage(
                          height: 50,
                          width: 50,
                          imageUrl: instances[i].icon,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: imageProvider),
                            ),
                          ),
                          errorWidget: (_, __, ___) => SizedBox(width: 50),
                        )
                      : SizedBox(width: 50),
                  title: Text(
                    instances[i].name,
                    style: theme.textTheme.headline6,
                  ),
                  trailing: IconButton(
                    icon: Icon(isCollapsed.value[i]
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                    onPressed: () => toggleCollapse(i),
                  ),
                ),
                if (!isCollapsed.value[i])
                  for (final comm in filterCommunities(communities[i]))
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: ListTile(
                        onTap: () {}, // TODO: open community
                        dense: true,
                        leading: VerticalDivider(
                          color: theme.hintColor,
                        ),
                        title: Row(
                          children: [
                            if (comm.communityIcon != null)
                              CachedNetworkImage(
                                height: 30,
                                width: 30,
                                imageUrl: comm.communityIcon,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider),
                                  ),
                                ),
                                errorWidget: (_, __, ___) =>
                                    SizedBox(width: 30),
                              )
                            else
                              SizedBox(width: 30),
                            SizedBox(width: 10),
                            Text('!${comm.communityName}'),
                          ],
                        ),
                        trailing: _CommunitySubscribeToggle(
                          instanceUrl: comm.communityActorId.split('/')[2],
                          communityId: comm.communityId,
                        ),
                      ),
                    )
              ],
            ),
        ],
      ),
    );
  }
}

class _CommunitySubscribeToggle extends HookWidget {
  final int communityId;
  final String instanceUrl;

  _CommunitySubscribeToggle(
      {@required this.instanceUrl, @required this.communityId})
      : assert(instanceUrl != null),
        assert(communityId != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subbed = useState(true);
    final delayed = useDelayedLoading(const Duration(milliseconds: 500));
    final accountsStore = useAccountsStore();

    handleTap() async {
      delayed.start();

      try {
        await LemmyApi(instanceUrl).v1.followCommunity(
              communityId: communityId,
              follow: !subbed.value,
              auth: accountsStore.defaultTokenFor(instanceUrl).raw,
            );
        subbed.value = !subbed.value;
      } on Exception catch (err) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Failed to ${subbed.value ? 'un' : ''}follow: $err'),
        ));
      }

      delayed.cancel();
    }

    return InkWell(
      onTap: delayed.pending ? () {} : handleTap,
      child: Container(
        decoration: delayed.loading
            ? null
            : BoxDecoration(
                color: subbed.value ? theme.accentColor : null,
                border: Border.all(color: theme.accentColor),
                borderRadius: BorderRadius.circular(7),
              ),
        child: delayed.loading
            ? Container(
                width: 20, height: 20, child: CircularProgressIndicator())
            : Icon(
                subbed.value ? Icons.done : Icons.add,
                color: subbed.value
                    ? textColorBasedOnBackground(theme.accentColor)
                    : theme.accentColor,
                size: 20,
              ),
      ),
    );
  }
}

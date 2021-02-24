import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/refreshable.dart';
import '../hooks/stores.dart';
import '../util/extensions/api.dart';
import '../util/extensions/iterators.dart';
import '../util/goto.dart';
import '../util/text_color.dart';
import '../widgets/avatar.dart';

/// List of subscribed communities per instance
class CommunitiesTab extends HookWidget {
  const CommunitiesTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filterController = useListenable(useTextEditingController());
    final accountsStore = useAccountsStore();

    final amountOfDisplayInstances = accountsStore.loggedInInstances.length;
    final isCollapsed = useState(List.filled(amountOfDisplayInstances, false));

    if (amountOfDisplayInstances != isCollapsed.value.length) {
      isCollapsed.value = List.filled(amountOfDisplayInstances, false);
    }

    getInstances() {
      final futures = accountsStore.loggedInInstances
          .map(
            (instanceHost) => LemmyApiV2(instanceHost)
                .run(const GetSite())
                .then((e) => e.siteView.site),
          )
          .toList();

      return Future.wait(futures);
    }

    getCommunities() {
      final futures = accountsStore.loggedInInstances
          .map(
            (instanceHost) => LemmyApiV2(instanceHost)
                .run(GetUserDetails(
                  sort: SortType.active,
                  savedOnly: false,
                  userId:
                      accountsStore.defaultTokenFor(instanceHost).payload.id,
                ))
                .then((e) => e.follows),
          )
          .toList();

      return Future.wait(futures);
    }

    final _loggedInAccounts = accountsStore.loggedInInstances
        .map((instanceHost) =>
            '$instanceHost${accountsStore.defaultUsernameFor(instanceHost)}')
        .toList();

    final instancesRefreshable =
        useRefreshable(getInstances, _loggedInAccounts);
    final communitiesRefreshable =
        useRefreshable(getCommunities, _loggedInAccounts);

    if (communitiesRefreshable.snapshot.hasError ||
        instancesRefreshable.snapshot.hasError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Row(
            children: [
              const Icon(Icons.error),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  communitiesRefreshable.snapshot.error?.toString() ??
                      instancesRefreshable.snapshot.error?.toString(),
                ),
              )
            ],
          ),
        ),
      );
    } else if (!communitiesRefreshable.snapshot.hasData ||
        !instancesRefreshable.snapshot.hasData) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    refresh() async {
      await HapticFeedback.mediumImpact();
      try {
        await Future.wait([
          instancesRefreshable.refresh(),
          communitiesRefreshable.refresh(),
        ]);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }

    final instances = instancesRefreshable.snapshot.data;
    final communities = communitiesRefreshable.snapshot.data
      ..forEach((e) =>
          e.sort((a, b) => a.community.name.compareTo(b.community.name)));

    final filterIcon = () {
      if (filterController.text.isEmpty) {
        return const Icon(Icons.filter_list);
      }

      return IconButton(
        onPressed: () {
          filterController.clear();
          primaryFocus.unfocus();
        },
        icon: const Icon(Icons.clear),
      );
    }();

    filterCommunities(List<CommunityFollowerView> comm) {
      final matches = Fuzzy(
        comm.map((e) => e.community.name).toList(),
        options: FuzzyOptions(threshold: 0.5),
      ).search(filterController.text).map((e) => e.item);

      return matches
          .map((match) => comm.firstWhere((e) => e.community.name == match));
    }

    toggleCollapse(int i) => isCollapsed.value =
        isCollapsed.value.mapWithIndex((e, j) => j == i ? !e : e).toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.style),
            onPressed: () {}, // TODO: change styles?
          ),
        ],
        title: TextField(
          controller: filterController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            suffixIcon: filterIcon,
            hintText: 'Filter', // TODO: hint with an filter icon
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: amountOfDisplayInstances == 0
            ? const Center(
                child: Text('You are not logged in to any instances'),
              )
            : ListView(
                children: [
                  for (var i = 0; i < amountOfDisplayInstances; i++)
                    Column(
                      children: [
                        ListTile(
                          onTap: () => goToInstance(context,
                              accountsStore.loggedInInstances.elementAt(i)),
                          onLongPress: () => toggleCollapse(i),
                          leading: Avatar(url: instances[i].icon),
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
                                onTap: () => goToCommunity.byId(
                                    context,
                                    accountsStore.loggedInInstances
                                        .elementAt(i),
                                    comm.community.id),
                                dense: true,
                                leading: VerticalDivider(
                                  color: theme.hintColor,
                                ),
                                title: Row(
                                  children: [
                                    Avatar(
                                      radius: 15,
                                      url: comm.community.icon,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(comm.community.originDisplayName),
                                  ],
                                ),
                                trailing: _CommunitySubscribeToggle(
                                  key: ValueKey(comm.community.id),
                                  instanceHost: comm.instanceHost,
                                  communityId: comm.community.id,
                                ),
                              ),
                            )
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}

class _CommunitySubscribeToggle extends HookWidget {
  final int communityId;
  final String instanceHost;

  const _CommunitySubscribeToggle(
      {@required this.instanceHost, @required this.communityId, Key key})
      : assert(instanceHost != null),
        assert(communityId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subbed = useState(true);
    final delayed = useDelayedLoading();
    final accountsStore = useAccountsStore();

    handleTap() async {
      delayed.start();

      try {
        await LemmyApiV2(instanceHost).run(FollowCommunity(
          communityId: communityId,
          follow: !subbed.value,
          auth: accountsStore.defaultTokenFor(instanceHost).raw,
        ));
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
            ? const SizedBox(
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

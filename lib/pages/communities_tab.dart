import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';
import '../util/iterators.dart';
import '../util/text_color.dart';

class CommunitiesTab extends HookWidget {
  CommunitiesTab();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var filterController = useTextEditingController();
    useValueListenable(filterController);
    var amountOfDisplayInstances = useMemoized(() {
      var accountsStore = context.watch<AccountsStore>();

      return accountsStore.users.keys
          .where((e) => !accountsStore.isAnonymousFor(e))
          .length;
    });
    var isCollapsed = useState(List.filled(amountOfDisplayInstances, false));

    var instancesFut = useMemoized(() {
      var accountsStore = context.watch<AccountsStore>();

      var futures = accountsStore.users.keys
          .where((e) => !accountsStore.isAnonymousFor(e))
          .map(
            (instanceUrl) =>
                LemmyApi(instanceUrl).v1.getSite().then((e) => e.site),
          )
          .toList();

      return Future.wait(futures);
    });
    var communitiesFut = useMemoized(() {
      var accountsStore = context.watch<AccountsStore>();

      var futures = accountsStore.users.keys
          .where((e) => !accountsStore.isAnonymousFor(e))
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

    var communitiesSnap = useFuture(communitiesFut);
    var instancesSnap = useFuture(instancesFut);

    if (!communitiesSnap.hasData || !instancesSnap.hasData) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var instances = instancesSnap.data;
    var communities = communitiesSnap.data
      ..forEach(
          (e) => e.sort((a, b) => a.communityName.compareTo(b.communityName)));

    var filterIcon = () {
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

    filterCommunities(List<CommunityFollowerView> comm) =>
        comm.where((e) => e.communityName
            .toLowerCase()
            .contains(filterController.text.toLowerCase()));

    toggleCollapse(int i) => isCollapsed.value =
        isCollapsed.value.mapWithIndex((e, j) => j == i ? !e : e).toList();

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
          for (var i in Iterable.generate(amountOfDisplayInstances))
            Column(
              children: [
                ListTile(
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
                  for (var comm in filterCommunities(communities[i]))
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: ListTile(
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
    var theme = Theme.of(context);
    var subed = useState(true);
    var loading = useState(false);

    return InkWell(
      onTap: () async {
        // load animation only after 500ms
        var timerHandle =
            Timer(Duration(milliseconds: 500), () => loading.value = true);

        try {
          await LemmyApi(instanceUrl).v1.followCommunity(
                communityId: communityId,
                follow: !subed.value,
                auth: context
                    .read<AccountsStore>()
                    .defaultTokenFor(instanceUrl)
                    .raw,
              );
          timerHandle.cancel();
          subed.value = !subed.value;
        } on Exception catch (err) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Failed to ${subed.value ? 'un' : ''}follow: $err'),
          ));
        }
        loading.value = false;
      },
      child: Container(
        decoration: loading.value
            ? null
            : BoxDecoration(
                color: subed.value ? theme.accentColor : null,
                border: Border.all(color: theme.accentColor),
                borderRadius: BorderRadius.circular(5),
              ),
        child: loading.value
            ? Container(
                width: 20, height: 20, child: CircularProgressIndicator())
            : Icon(
                subed.value ? Icons.done : Icons.add,
                color: subed.value
                    ? textColorBasedOnBackground(theme.accentColor)
                    : theme.accentColor,
                size: 20,
              ),
      ),
    );
  }
}

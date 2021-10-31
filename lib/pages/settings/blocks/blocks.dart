import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../hooks/stores.dart';
import '../../../l10n/l10n_from_string.dart';
import '../../../stores/accounts_store.dart';
import '../../../util/async_store_listener.dart';
import '../../../util/observer_consumers.dart';
import 'block_tile.dart';
import 'blocks_store.dart';

class BlocksPage extends HookWidget {
  const BlocksPage._();
  @override
  Widget build(BuildContext context) {
    final accStore = useAccountsStore();

    return DefaultTabController(
      length: accStore.loggedInInstances.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blocks'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final instance in accStore.loggedInInstances)
                Tab(
                  child: Text(
                      '${accStore.defaultUsernameFor(instance)!}@$instance'),
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final instance in accStore.loggedInInstances)
              _UserBlocksWrapper(
                instanceHost: instance,
                username: accStore.defaultUsernameFor(instance)!,
              )
          ],
        ),
      ),
    );
  }

  static Route route() =>
      MaterialPageRoute(builder: (context) => const BlocksPage._());
}

class _UserBlocksWrapper extends StatelessWidget {
  final String instanceHost;
  final String username;

  const _UserBlocksWrapper(
      {required this.instanceHost, required this.username});

  @override
  Widget build(BuildContext context) {
    return Provider<BlocksStore>(
      create: (context) => BlocksStore(
        instanceHost: instanceHost,
        token: context
            .read<AccountsStore>()
            .userDataFor(instanceHost, username)!
            .jwt,
      )..refresh(),
      child: const _UserBlocks(),
    );
  }
}

class _UserBlocks extends StatelessWidget {
  const _UserBlocks();

  @override
  Widget build(BuildContext context) {
    return AsyncStoreListener(
      asyncStore: context.read<BlocksStore>().blocksState,
      child: ObserverBuilder<BlocksStore>(
        builder: (context, store) {
          return RefreshIndicator(
            onRefresh: store.refresh,
            child: ListView(
              children: [
                if (!store.isUsable) ...[
                  if (store.blocksState.isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 64),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  else if (store.blocksState.errorTerm != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 64),
                      child: Center(
                        child: Text(
                          store.blocksState.errorTerm!.tr(context),
                        ),
                      ),
                    )
                ] else ...[
                  for (final user in store.blockedUsers!)
                    Provider(
                      create: (context) => user,
                      key: ValueKey(user),
                      child: const BlockPersonTile(),
                    ),
                  if (store.blockedUsers!.isEmpty)
                    const ListTile(
                      title: Center(
                        child: Text('No users blocked'),
                      ),
                    ),
                  // TODO: add user search & block
                  // ListTile(
                  //   leading: const Padding(
                  //     padding: EdgeInsets.only(left: 16, right: 10),
                  //     child: Icon(Icons.add),
                  //   ),
                  //   onTap: () {},
                  //   title: const Text('Block User'),
                  // ),
                  const Divider(),
                  for (final community in store.blockedCommunities!)
                    Provider(
                      create: (context) => community,
                      key: ValueKey(community),
                      child: const BlockCommunityTile(),
                    ),
                  if (store.blockedCommunities!.isEmpty)
                    const ListTile(
                      title: Center(
                        child: Text('No communities blocked'),
                      ),
                    ),
                  // TODO: add community search & block
                  // const ListTile(
                  //   leading: Padding(
                  //     padding: EdgeInsets.only(left: 16, right: 10),
                  //     child: Icon(Icons.add),
                  //   ),
                  //   onTap: () {},
                  //   title: Text('Block Community'),
                  // ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../hooks/debounce.dart';
import '../../hooks/stores.dart';
import '../../stores/accounts_store.dart';
import '../../util/extensions/api.dart';
import '../../util/goto.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/avatar.dart';
import 'blocks_store.dart';

class BlocksPage extends HookWidget {
  const BlocksPage();
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
              UserBlocksWrapper(
                instanceHost: instance,
                username: accStore.defaultUsernameFor(instance)!,
              )
          ],
        ),
      ),
    );
  }
}

class UserBlocksWrapper extends StatelessWidget {
  final String instanceHost;
  final String username;

  const UserBlocksWrapper({required this.instanceHost, required this.username});

  @override
  Widget build(BuildContext context) {
    return Provider<BlocksStore>(
      create: (context) => BlocksStore(
        instanceHost: instanceHost,
        token: context
            .read<AccountsStore>()
            .userDataFor(instanceHost, username)!
            .jwt,
      ),
      child: const _UserBlocks(),
    );
  }
}

class _UserBlocks extends HookWidget {
  const _UserBlocks();

  @override
  Widget build(BuildContext context) {
    useMemoized(() => context.read<BlocksStore>().refresh(), []);

    return ObserverBuilder<BlocksStore>(
      builder: (context, store) {
        return RefreshIndicator(
          onRefresh: store.refresh,
          child: ListView(
            children: [
              if (store.blocksState.isLoading &&
                  store.blockedCommunities.isEmpty &&
                  store.blockedUsers.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              else if (store.blocksState.errorTerm != null)
                const Padding(
                  padding: EdgeInsets.only(top: 64),
                  child: Center(child: Text('error UwU')),
                )
              else ...[
                for (final user in store.blockedUsers)
                  _BlockPersonTile(user, key: ValueKey(user)),
                if (store.blockedUsers.isEmpty)
                  const ListTile(
                      title: Center(child: Text('No users blocked'))),
                ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 16, right: 10),
                    child: Icon(Icons.add),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            BlockUserPopup(store.instanceHost));
                  },
                  title: const Text('Block User'),
                ),
                const Divider(),
                for (final community in store.blockedCommunities)
                  _BlockCommunityTile(community, key: ValueKey(community)),
                if (store.blockedCommunities.isEmpty)
                  const ListTile(
                      title: Center(child: Text('No communities blocked'))),
                const ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(left: 16, right: 10),
                    child: Icon(Icons.add),
                  ),
                  title: Text('Block Community'),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

class _BlockPersonTile extends HookWidget {
  final PersonSafe person;
  const _BlockPersonTile(this.person, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final token = useAccountsStoreSelect(
        (store) => store.defaultUserDataFor(person.instanceHost)!.jwt);

    void showSnackBar(String e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
    }

    final pending = useState(false);

    unblock() async {
      if (pending.value) return;
      pending.value = true;
      try {
        await LemmyApiV3(person.instanceHost).run(
            BlockPerson(auth: token.raw, block: false, personId: person.id));
        context.read<BlocksStore>().userUnblocked(person.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${person.preferredName} unblocked'),
          ),
        );
      } on SocketException {
        showSnackBar('Network error');
        // ignore: avoid_catches_without_on_clauses
      } on LemmyApiException catch (e) {
        showSnackBar(e.message);
      } catch (e) {
        showSnackBar(e.toString());
      } finally {
        pending.value = false;
      }
    }

    return ListTile(
      leading: Avatar(url: person.avatar),
      title: Text(person.preferredName),
      trailing: IconButton(
        icon: pending.value
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.cancel),
        tooltip: 'unblock',
        onPressed: unblock,
      ),
      onTap: () {
        goToUser.byId(context, person.instanceHost, person.id);
      },
    );
  }
}

class _BlockCommunityTile extends HookWidget {
  final CommunitySafe community;

  const _BlockCommunityTile(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final token = useAccountsStoreSelect(
        (store) => store.defaultUserDataFor(community.instanceHost)!.jwt);

    void showSnackBar(String e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e)));
    }

    final pending = useState(false);

    unblock() async {
      if (pending.value) return;
      pending.value = true;
      try {
        await LemmyApiV3(community.instanceHost).run(BlockCommunity(
            auth: token.raw, block: false, communityId: community.id));
        context.read<BlocksStore>().communityUnblocked(community.id);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Community unblocked'),
        ));
      } on SocketException {
        showSnackBar('Network error');
      } on LemmyApiException catch (e) {
        showSnackBar(e.message);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        showSnackBar(e.toString());
      } finally {
        pending.value = false;
      }
    }

    return ListTile(
      leading: Avatar(url: community.icon),
      title: Text(community.originPreferredName),
      trailing: IconButton(
        icon: pending.value
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.cancel),
        tooltip: 'unblock',
        onPressed: unblock,
      ),
      onTap: () {
        goToCommunity.byId(context, community.instanceHost, community.id);
      },
    );
  }
}

class BlockUserPopup extends HookWidget {
  final String instanceHost;

  const BlockUserPopup(this.instanceHost);

  @override
  Widget build(BuildContext context) {
    final query = useState('');
    final results = useState(<PersonViewSafe>[]);

    final debounce = useDebounce(() async {
      final res = await LemmyApiV3(instanceHost).run(Search(q: query.value));
      results.value = res.users;
    });

    return Dialog(
      child: Autocomplete<PersonViewSafe>(
        optionsBuilder: (textEditingValue) {
          debounce();
          return results.value;
        },
        displayStringForOption: (person) => person.person.originPreferredName,
      ),
    );
  }
}

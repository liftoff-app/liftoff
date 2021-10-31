import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../util/async_store_listener.dart';
import '../../../util/extensions/api.dart';
import '../../../util/goto.dart';
import '../../../util/observer_consumers.dart';
import '../../../widgets/avatar.dart';
import 'community_block_store.dart';
import 'user_block_store.dart';

class BlockPersonTile extends StatelessWidget {
  const BlockPersonTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncStoreListener(
      asyncStore: context.read<UserBlockStore>().unblockingState,
      child: ObserverBuilder<UserBlockStore>(
        builder: (context, store) {
          return ListTile(
            leading: Avatar(url: store.person.avatar),
            title: Text(store.person.originPreferredName),
            trailing: IconButton(
              icon: store.unblockingState.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Icons.cancel),
              tooltip: 'unblock',
              onPressed: store.unblock,
            ),
            onTap: () {
              goToUser.byId(
                  context, store.person.instanceHost, store.person.id);
            },
          );
        },
      ),
    );
  }
}

class BlockCommunityTile extends HookWidget {
  const BlockCommunityTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AsyncStoreListener(
      asyncStore: context.read<CommunityBlockStore>().unblockingState,
      child: ObserverBuilder<CommunityBlockStore>(
        builder: (context, store) {
          return ListTile(
            leading: Avatar(url: store.community.icon),
            title: Text(store.community.originPreferredName),
            trailing: IconButton(
              icon: store.unblockingState.isLoading
                  ? const CircularProgressIndicator.adaptive()
                  : const Icon(Icons.cancel),
              tooltip: 'unblock',
              onPressed: store.unblock,
            ),
            onTap: () {
              goToCommunity.byId(
                  context, store.community.instanceHost, store.community.id);
            },
          );
        },
      ),
    );
  }
}

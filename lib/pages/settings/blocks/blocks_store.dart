import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../../util/async_store.dart';
import 'community_block_store.dart';
import 'user_block_store.dart';

part 'blocks_store.g.dart';

class BlocksStore = _BlocksStore with _$BlocksStore;

abstract class _BlocksStore with Store {
  final String instanceHost;
  final Jwt token;

  _BlocksStore({required this.instanceHost, required this.token});

  @observable
  List<UserBlockStore>? _blockedUsers;

  @observable
  List<CommunityBlockStore>? _blockedCommunities;

  final blockCommunityState = AsyncStore<BlockedCommunity>();
  final blockUserState = AsyncStore<BlockedPerson>();

  final blocksState = AsyncStore<FullSiteView>();

  @computed
  Iterable<UserBlockStore>? get blockedUsers =>
      _blockedUsers?.where((u) => u.blocked);

  @computed
  Iterable<CommunityBlockStore>? get blockedCommunities =>
      _blockedCommunities?.where((c) => c.blocked);

  @computed
  bool get isUsable => blockedUsers != null && blockedCommunities != null;

  @action
  Future<void> refresh() async {
    final result =
        await blocksState.runLemmy(instanceHost, GetSite(auth: token.raw));

    if (result != null) {
      _blockedUsers = result.myUser!.personBlocks
          .map((e) => UserBlockStore(
              instanceHost: instanceHost, token: token, person: e.target))
          .toList();
      _blockedCommunities = result.myUser!.communityBlocks
          .map((e) => CommunityBlockStore(
              instanceHost: instanceHost, token: token, community: e.community))
          .toList();
    }
  }
}

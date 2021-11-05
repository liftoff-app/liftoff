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
  ObservableList<UserBlockStore>? _blockedUsers;

  @observable
  ObservableList<CommunityBlockStore>? _blockedCommunities;

  final blocksState = AsyncStore<FullSiteView>();

  final userBlockingState = AsyncStore<BlockedPerson>();
  final communityBlockingState = AsyncStore<BlockedCommunity>();

  @computed
  Iterable<UserBlockStore>? get blockedUsers =>
      _blockedUsers?.where((u) => u.blocked);

  @computed
  Iterable<CommunityBlockStore>? get blockedCommunities =>
      _blockedCommunities?.where((c) => c.blocked);

  @computed
  bool get isUsable => blockedUsers != null && blockedCommunities != null;

  @action
  Future<void> blockUser(Jwt token, int id) async {
    if (_blockedUsers == null) {
      throw StateError("_blockedUsers can't be null at this moment");
    }
    final res = await userBlockingState.runLemmy(
      instanceHost,
      BlockPerson(
        personId: id,
        block: true,
        auth: token.raw,
      ),
    );

    if (res != null &&
        _blockedUsers!.indexWhere((element) => element.person.id == id) == -1) {
      _blockedUsers!.add(
        UserBlockStore(
          instanceHost: instanceHost,
          person: res.personView.person,
          token: token,
        ),
      );
    }
  }

  @action
  Future<void> blockCommunity(Jwt token, int id) async {
    if (_blockedCommunities == null) {
      throw StateError("_blockedCommunities can't be null at this moment");
    }
    final res = await communityBlockingState.runLemmy(
      instanceHost,
      BlockCommunity(
        communityId: id,
        block: true,
        auth: token.raw,
      ),
    );

    if (res != null &&
        _blockedCommunities!
                .indexWhere((element) => element.community.id == id) ==
            -1) {
      _blockedCommunities!.add(
        CommunityBlockStore(
          instanceHost: instanceHost,
          community: res.communityView.community,
          token: token,
        ),
      );
    }
  }

  @action
  Future<void> refresh() async {
    final result =
        await blocksState.runLemmy(instanceHost, GetSite(auth: token.raw));

    if (result != null) {
      _blockedUsers = result.myUser!.personBlocks
          .map((e) => UserBlockStore(
              instanceHost: instanceHost, token: token, person: e.target))
          .toList()
          .asObservable();
      _blockedCommunities = result.myUser!.communityBlocks
          .map((e) => CommunityBlockStore(
              instanceHost: instanceHost, token: token, community: e.community))
          .toList()
          .asObservable();
    }
  }
}

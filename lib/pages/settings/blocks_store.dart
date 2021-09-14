import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';

part 'blocks_store.g.dart';

class BlocksStore = _BlocksStore with _$BlocksStore;

abstract class _BlocksStore with Store {
  final String instanceHost;
  final Jwt token;

  ObservableList<PersonSafe> blockedUsers;

  ObservableList<CommunitySafe> blockedCommunities;

  final blockCommunityState = AsyncStore<BlockedCommunity>();
  final blockUserState = AsyncStore<BlockedPerson>();

  final blocksState = AsyncStore<FullSiteView>();

  @action
  void userUnblocked(int id) =>
      blockedUsers.removeWhere((element) => element.id == id);
  @action
  void communityUnblocked(int id) =>
      blockedCommunities.removeWhere((element) => element.id == id);

  @action
  Future<void> blockUser(int id) async {
    final result = await blockUserState.runLemmy(
      instanceHost,
      BlockPerson(personId: id, block: true, auth: token.raw),
    );

    if (result != null) blockedUsers.add(result.personView.person);
  }

  @action
  Future<void> blockCommunity(int id) async {
    final result = await blockCommunityState.runLemmy(
      instanceHost,
      BlockCommunity(communityId: id, block: true, auth: token.raw),
    );

    if (result != null) blockedCommunities.add(result.communityView.community);
  }

  @action
  Future<void> refresh() async {
    final result =
        await blocksState.runLemmy(instanceHost, GetSite(auth: token.raw));

    if (result != null) {
      blockedUsers = result.myUser!.personBlocks
          .map((e) => e.target)
          .toList()
          .asObservable();
      blockedCommunities = result.myUser!.communityBlocks
          .map((e) => e.community)
          .toList()
          .asObservable();
    }
  }

  _BlocksStore({required this.instanceHost, required this.token})
      : blockedUsers = <PersonSafe>[].asObservable(),
        blockedCommunities = <CommunitySafe>[].asObservable();
}

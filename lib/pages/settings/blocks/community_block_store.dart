import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../../util/async_store.dart';

part 'community_block_store.g.dart';

class CommunityBlockStore extends _CommunityBlockStore
    with _$CommunityBlockStore {
  CommunityBlockStore(
      {required super.instanceHost,
      required super.token,
      required super.community});
}

abstract class _CommunityBlockStore with Store {
  final String instanceHost;
  final Jwt token;
  final CommunitySafe community;

  _CommunityBlockStore({
    required this.instanceHost,
    required this.token,
    required this.community,
  });

  final unblockingState = AsyncStore<BlockedCommunity>();

  @observable
  bool blocked = true;

  Future<void> unblock() async {
    final result = await unblockingState.runLemmy(
        instanceHost,
        BlockCommunity(
          communityId: community.id,
          block: false,
          auth: token.raw,
        ));
    if (result != null) {
      blocked = result.blocked;
    }
  }
}

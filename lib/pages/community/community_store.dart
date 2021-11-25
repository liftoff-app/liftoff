import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';

part 'community_store.g.dart';

class CommunityStore = _CommunityStore with _$CommunityStore;

abstract class _CommunityStore with Store {
  final String instanceHost;
  final String? communityName;
  final int? id;

  // ignore: unused_element
  _CommunityStore.fromName({
    required String this.communityName,
    required this.instanceHost,
  }) : id = null;
  // ignore: unused_element
  _CommunityStore.fromId({required this.id, required this.instanceHost})
      : communityName = null;

  final communityState = AsyncStore<FullCommunityView>();
  final subscribingState = AsyncStore<CommunityView>();
  final blockingState = AsyncStore<BlockedCommunity>();

  @action
  Future<void> refresh(Jwt? token) async {
    await communityState.runLemmy(
      instanceHost,
      GetCommunity(
        auth: token?.raw,
        id: id,
        name: communityName,
      ),
      refresh: true,
    );
  }

  Future<void> block(Jwt token) async {
    final state = communityState.asyncState;
    if (state is! AsyncStateData<FullCommunityView>) {
      throw StateError('communityState should be ready at this point');
    }

    final res = await blockingState.runLemmy(
      instanceHost,
      BlockCommunity(
        communityId: state.data.communityView.community.id,
        block: !state.data.communityView.blocked,
        auth: token.raw,
      ),
    );

    if (res != null) {
      communityState
          .setData(state.data.copyWith(communityView: res.communityView));
    }
  }

  @action
  Future<void> subscribe(Jwt token) async {
    final state = communityState.asyncState;

    if (state is! AsyncStateData<FullCommunityView>) {
      throw StateError('FullCommunityView should be not null at this point');
    }
    final communityView = state.data.communityView;

    final res = await subscribingState.runLemmy(
      instanceHost,
      FollowCommunity(
        communityId: communityView.community.id,
        follow: !communityView.subscribed,
        auth: token.raw,
      ),
    );

    if (res != null) {
      communityState.setData(state.data.copyWith(communityView: res));
    }
  }
}

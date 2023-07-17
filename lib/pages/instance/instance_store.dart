import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../stores/accounts_store.dart';
import '../../util/async_store.dart';

part 'instance_store.g.dart';

class InstanceStore = _InstanceStore with _$InstanceStore;

abstract class _InstanceStore with Store {
  final String instanceHost;

  _InstanceStore(this.instanceHost);

  final siteState = AsyncStore<FullSiteView>();
  final communitiesState = AsyncStore<List<CommunityView>>();

  @action
  Future<void> fetch(UserData? userData, {bool refresh = false}) async {
    await Future.wait([
      siteState.runLemmy(
        instanceHost,
        GetSite(auth: userData?.jwt.raw),
        refresh: refresh,
      ),
      fetchCommunites(userData, refresh: refresh),
    ]);
  }

  @action
  Future<void> fetchCommunites(UserData? userData,
      {bool refresh = false}) async {
    await communitiesState.runLemmy(
      instanceHost,
      ListCommunities(
        type: PostListingType.local,
        sort: SortType.hot,
        limit: 6,
        auth: userData?.jwt.raw,
      ),
      refresh: refresh,
    );
  }
}

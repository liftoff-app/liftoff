import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';

part 'instance_store.g.dart';

class InstanceStore = _InstanceStore with _$InstanceStore;

abstract class _InstanceStore with Store {
  final String instanceHost;

  _InstanceStore(this.instanceHost);

  final siteState = AsyncStore<FullSiteView>();
  final communitiesState = AsyncStore<List<CommunityView>>();

  @action
  Future<void> fetch(Jwt? token, {bool refresh = false}) async {
    await Future.wait([
      siteState.runLemmy(
        instanceHost,
        GetSite(auth: token?.raw),
        refresh: refresh,
      ),
      fetchCommunites(token, refresh: refresh),
    ]);
  }

  @action
  Future<void> fetchCommunites(Jwt? token, {bool refresh = false}) async {
    await communitiesState.runLemmy(
      instanceHost,
      ListCommunities(
        type: PostListingType.local,
        sort: SortType.hot,
        limit: 6,
        auth: token?.raw,
      ),
      refresh: refresh,
    );
  }
}

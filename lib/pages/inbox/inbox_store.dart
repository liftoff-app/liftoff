import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../stores/accounts_store.dart';
import '../../util/async_store.dart';

part 'inbox_store.g.dart';

class InboxStore = _InboxStore with _$InboxStore;

abstract class _InboxStore with Store {
  final String instanceHost;

  _InboxStore(this.instanceHost);
  final unreadCounts = AsyncStore<UnreadCount>();

  @observable
  int? notificationCount;

  @action
  Future<void> refresh(UserData? userData) async {
    notificationCount = await LemmyApiV3(userData!.instanceHost)
        .run(GetUnreadCount(
          auth: userData.jwt.raw,
        ))
        .then((e) => e.mentions + e.replies + e.privateMessages);
  }

  @action
  Future<void> fetchNotifications(UserData? userData) async {
    await LemmyApiV3(userData!.instanceHost).run(GetUnreadCount(
      auth: userData.jwt.raw,
    ));
  }
}

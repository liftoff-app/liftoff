import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../util/async_store.dart';

part 'inbox_store.g.dart';

class InboxStore = _InboxStore with _$InboxStore;

abstract class _InboxStore with Store {
  final String instanceHost;

  _InboxStore(this.instanceHost);

  final unreadCounts = AsyncStore<UnreadCount>();

  // Future<void> fetchNotifications() {
  //     return Future.wait(
  //       accStore.instances.map(
  //         (e) => LemmyApiV3(e)
  //             .run<UnreadCount?>(GetUnreadCount(
  //               auth: accStore
  //                   .defaultUserDataFor(accStore.defaultInstanceHost!)!
  //                   .jwt
  //                   .raw,
  //             ))
  //             .then((value) => value != null
  //                 ? value.mentions + value.replies + value.privateMessages
  //                 : 0)
  //             .catchError((e) => 0),
  //       ),
  //     ).then((value) => value.reduce((value, element) => value + element));
  //   }

  @action
  Future<void> fetchNotifications(Jwt token, {bool refresh = false}) async {
    await unreadCounts.runLemmy(
      instanceHost,
      GetUnreadCount(auth: token.raw),
      refresh: refresh,
    );
  }
}

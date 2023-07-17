import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

import '../../../util/async_store.dart';

part 'user_block_store.g.dart';

class UserBlockStore = _UserBlockStore with _$UserBlockStore;

abstract class _UserBlockStore with Store {
  final String instanceHost;
  final Jwt token;
  final PersonSafe person;

  _UserBlockStore({
    required this.instanceHost,
    required this.token,
    required this.person,
  });

  final unblockingState = AsyncStore<BlockedPerson>();

  @observable
  bool blocked = true;

  Future<void> unblock() async {
    final result = await unblockingState.runLemmy(
        instanceHost,
        BlockPerson(
          personId: person.id,
          block: false,
          auth: token.raw,
        ));
    if (result != null) {
      blocked = result.blocked;
    }
  }
}

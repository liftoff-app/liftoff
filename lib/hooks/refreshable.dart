import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'memo_future.dart';

class Refreshable<T> {
  const Refreshable({required this.snapshot, required this.refresh});

  final AsyncSnapshot<T> snapshot;
  final AsyncCallback refresh;
}

/// Similar to [useMemoFuture] but adds a `.refresh` method which
/// allows to re-run the fetcher. Calling `.refresh` will not
/// turn AsyncSnapshot into a loading state. Instead it will
/// replace the ready state with the new data when available
///
/// `keys` will re-run the initial fetching thus yielding a
/// loading state in the AsyncSnapshot
Refreshable<T> useRefreshable<T extends Object>(
  AsyncValueGetter<T> fetcher, [
  List<Object> keys = const <Object>[],
]) {
  final newData = useState<T?>(null);
  final snapshot = useMemoFuture(() async {
    newData.value = null;
    return fetcher();
  }, keys);

  final outSnapshot = () {
    if (newData.value != null) {
      return AsyncSnapshot.withData(ConnectionState.done, newData.value!);
    }
    return snapshot;
  }();

  return Refreshable(
    snapshot: outSnapshot,
    refresh: () async {
      newData.value = await fetcher();
    },
  );
}

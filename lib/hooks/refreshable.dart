import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'memo_future.dart';

class Refreshable<T> {
  const Refreshable({@required this.snapshot, @required this.refresh})
      : assert(snapshot != null),
        assert(refresh != null);

  final AsyncSnapshot<T> snapshot;
  final AsyncCallback refresh;
}

Refreshable<T> useRefreshable<T>(AsyncValueGetter<T> fetcher,
    [List<Object> keys = const <dynamic>[]]) {
  final newData = useState<T>(null);
  final snapshot = useMemoFuture(() async {
    newData.value = null;
    return fetcher();
  }, keys);

  final outSnapshot = () {
    if (newData.value != null) {
      return AsyncSnapshot.withData(ConnectionState.done, newData.value);
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

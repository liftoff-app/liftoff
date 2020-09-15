import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ref.dart';

class DelayedLoading {
  final bool pending;
  final bool loading;
  final void Function() start;
  final void Function() cancel;

  const DelayedLoading({
    @required this.pending,
    @required this.loading,
    @required this.start,
    @required this.cancel,
  });
}

/// When loading is [.start()]ed, it goes into a pending state
/// and loading is triggered after [delayDuration].
/// Everything can be reset with [.cancel()]
DelayedLoading useDelayedLoading(Duration delayDuration) {
  var loading = useState(false);
  var pending = useState(false);
  var timerHandle = useRef<Timer>(null);

  return DelayedLoading(
    loading: loading.value,
    pending: pending.value,
    start: () {
      timerHandle.current = Timer(delayDuration, () => loading.value = true);
      pending.value = true;
    },
    cancel: () {
      timerHandle.current?.cancel();
      pending.value = false;
      loading.value = false;
    },
  );
}

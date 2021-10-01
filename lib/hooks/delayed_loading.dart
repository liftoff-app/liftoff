import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DelayedLoading {
  final bool pending;
  final bool loading;
  final VoidCallback start;
  final VoidCallback cancel;

  const DelayedLoading({
    required this.pending,
    required this.loading,
    required this.start,
    required this.cancel,
  });
}

/// When loading is [.start()]ed, it goes into a pending state
/// and loading is triggered after [delayDuration].
/// Everything can be reset with [.cancel()]
DelayedLoading useDelayedLoading(
    [Duration delayDuration = const Duration(milliseconds: 500)]) {
  final loading = useState(false);
  final pending = useState(false);
  final timerHandle = useRef<Timer?>(null);

  return DelayedLoading(
    loading: loading.value,
    pending: pending.value,
    start: () {
      timerHandle.value = Timer(delayDuration, () => loading.value = true);
      pending.value = true;
    },
    cancel: () {
      timerHandle.value?.cancel();
      pending.value = false;
      loading.value = false;
    },
  );
}

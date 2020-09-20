import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ref.dart';

class Debounce {
  final bool pending;
  final bool loading;
  final void Function() start;
  final void Function() cancel;
  final void Function() reset;

  const Debounce({
    @required this.pending,
    @required this.loading,
    @required this.start,
    @required this.cancel,
    @required this.reset,
  });
}

/// When loading is [.start()]ed, it goes into a pending state
/// and loading is triggered after [delayDuration].
/// Everything can be reset with [.cancel()]
Debounce useDebounce(
  Function(Function cancel) onDebounce, [
  Duration delayDuration = const Duration(milliseconds: 500),
]) {
  final loading = useState(false);
  final pending = useState(false);
  final timerHandle = useRef<Timer>(null);

  cancel() {
    timerHandle.current?.cancel();
    pending.value = false;
    loading.value = false;
  }

  start() {
    timerHandle.current = Timer(delayDuration, () {
      loading.value = true;
      onDebounce(cancel);
    });
    pending.value = true;
  }

  return Debounce(
      loading: loading.value,
      pending: pending.value,
      start: start,
      cancel: cancel,
      reset: () {
        cancel();
        start();
      });
}

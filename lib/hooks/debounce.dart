import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ref.dart';

class Debounce {
  final bool loading;
  final void Function() callback;

  void call() => callback();

  const Debounce({
    @required this.loading,
    @required this.callback,
  });
}

/// When loading is [.start()]ed, it goes into a pending state
/// and loading is triggered after [delayDuration].
/// Everything can be reset with [.cancel()]
Debounce useDebounce(
  Future<Null> Function() callback, [
  Duration delayDuration = const Duration(milliseconds: 500),
]) {
  final loading = useState(false);
  final timerHandle = useRef<Timer>(null);

  cancel() {
    timerHandle.current?.cancel();
    loading.value = false;
  }

  start() {
    timerHandle.current = Timer(delayDuration, () async {
      loading.value = true;
      await callback();
      cancel();
    });
  }

  return Debounce(
      loading: loading.value,
      callback: () {
        cancel();
        start();
      });
}

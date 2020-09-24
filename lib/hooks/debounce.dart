import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ref.dart';

class Debounce {
  final bool loading;
  final void Function() callback;
  final void Function() dispose;

  void call() => callback();

  // void dispose() {}

  const Debounce({
    @required this.loading,
    @required this.callback,
    @required this.dispose,
  });
}

/// will run `callback()` after debounce hook hasn't been called for the
/// specified `delayDuration`
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
    },
    dispose: cancel,
  );
}

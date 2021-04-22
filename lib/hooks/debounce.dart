import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'ref.dart';

class Debounce {
  final bool loading;
  final VoidCallback callback;

  const Debounce({
    required this.loading,
    required this.callback,
  });

  void call() => callback();
}

/// will run `callback()` after debounce hook hasn't been called for the
/// specified `delayDuration`
Debounce useDebounce(
  Future<void> Function() callback, [
  Duration delayDuration = const Duration(seconds: 1),
]) {
  final loading = useState(false);
  final timerHandle = useRef<Timer?>(null);

  cancel() {
    timerHandle.current?.cancel();
    loading.value = false;
  }

  useEffect(() => () => timerHandle.current?.cancel(), []);

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
  );
}

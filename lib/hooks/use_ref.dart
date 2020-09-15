import 'package:flutter_hooks/flutter_hooks.dart';

class Ref<T> {
  final T current;
  const Ref(this.current);
}

Ref<T> useRef<T>(T initialValue) => useMemoized(() => Ref(initialValue));

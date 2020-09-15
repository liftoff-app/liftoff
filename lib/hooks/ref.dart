import 'package:flutter_hooks/flutter_hooks.dart';

class Ref<T> {
  T current;
  Ref(this.current);
}

/// see React's useRef
Ref<T> useRef<T>(T initialValue) => useMemoized(() => Ref(initialValue));

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

/// Observes MobX observables in [fn] and returns the built value.
/// When observable inside have changed, the hook rebuilds the value.
/// The returned value can be ignored for a `useEffect(() { autorun(fn); }, [])`
/// effect.
T useObserved<T>(T Function() fn) {
  final returnValue = useState(useMemoized(fn));

  useEffect(() {
    final disposer = autorun((_) {
      returnValue.value = fn();
    });

    return disposer;
  }, []);

  return returnValue.value;
}

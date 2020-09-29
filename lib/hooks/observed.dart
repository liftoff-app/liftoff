import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';

/// Observes MobX observables in [fn] and returns the built value.
/// Behaves like a [useMemoized] with observables as a list of dependencies.
/// The returned value can be ignored for a `useEffect(() { autorun(fn); }, [])`
/// clone.
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

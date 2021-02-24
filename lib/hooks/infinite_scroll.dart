import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/infinite_scroll.dart';

InfiniteScrollController useInfiniteScrollController() {
  final controller = useMemoized(() => InfiniteScrollController());

  useEffect(() => controller.dispose, []);

  return controller;
}

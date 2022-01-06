import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/infinite_scroll.dart';

InfiniteScrollController useInfiniteScrollController() =>
    useMemoized(InfiniteScrollController.new);

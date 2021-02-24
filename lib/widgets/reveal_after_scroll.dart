import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Makes the child reveal itself after given distance
class RevealAfterScroll extends HookWidget {
  final Widget child;

  /// distance after which [child] should appear
  final int after;
  final int transition;
  final ScrollController scrollController;
  final bool fade;

  const RevealAfterScroll({
    @required this.scrollController,
    @required this.child,
    @required this.after,
    this.transition = 15,
    this.fade = false,
  })  : assert(scrollController != null),
        assert(child != null),
        assert(after != null);

  @override
  Widget build(BuildContext context) {
    useListenable(scrollController);

    final scroll = scrollController.position.pixels;

    return Opacity(
      opacity:
          fade ? max(0, min(transition, scroll - after + 20)) / transition : 1,
      child: Transform.translate(
        offset: Offset(0, max(0, after - scroll)),
        child: child,
      ),
    );
  }
}

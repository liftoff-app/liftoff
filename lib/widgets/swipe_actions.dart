import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:logging/logging.dart';

import '../actions/abstract_action.dart';
import '../hooks/logged_in_action.dart';
import '../util/observer_consumers.dart';
import 'post/post.dart';
import 'post/post_store.dart';

final _logger = Logger('SwipeActions');

class WithSwipeActions extends HookWidget {
  final Widget child;
  final List<LiftoffAction> actions;
  final void Function(LiftoffAction) onTrigger;

  const WithSwipeActions(
      {super.key,
      required this.child,
      required this.actions,
      required this.onTrigger});

  @override
  Widget build(BuildContext context) {
    final animationController =
        useAnimationController(duration: const Duration(milliseconds: 300));
    final slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(animationController);
    final activeActionIndex = useState(-1);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final newPosition = animationController.value -
            details.primaryDelta! / MediaQuery.of(context).size.width;

        // each action is 1/10 of the screen
        final newActiveActionIndex = newPosition ~/ 0.1;
        if (newActiveActionIndex <= actions.length) {
          animationController.value = newPosition;
        }

        if (newActiveActionIndex != activeActionIndex.value) {
          activeActionIndex.value = newActiveActionIndex;
        }
      },
      onHorizontalDragEnd: (details) {
        animationController.reverse();
        if (activeActionIndex.value > 0) {
          onTrigger(actions[activeActionIndex.value - 1]);
        }
        activeActionIndex.value = -1;
      },
      child: Stack(children: [
        if (activeActionIndex.value > 0)
          Positioned(
            right: 0,
            top: PostTile.rounding,
            bottom: PostTile.rounding,
            left: 0,
            child: ColoredBox(
                color: actions[min(activeActionIndex.value, actions.length) - 1]
                    .activeColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 10),
                    child: Icon(actions[
                            min(activeActionIndex.value, actions.length) - 1]
                        .icon),
                  ),
                )),
          ),
        SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      ]),
    );
  }
}

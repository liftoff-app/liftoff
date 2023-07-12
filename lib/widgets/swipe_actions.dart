import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../liftoff_action.dart';
import 'post/post.dart';

/// Widget that wraps [child] and allows for swipe actions to be performed on it.
/// [actions] are the actions that can be performed, and [onTrigger] is called
/// when the user triggers an action.
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

    // This starts at -1, and must be dragged to > 0 (at least 2 spaces) to
    // trigger an action That way, the user has a chance to see the action
    // without triggering it
    final activeActionIndex = useState(-1);
    final activeAction = activeActionIndex.value > 0
        ? actions[min(activeActionIndex.value, actions.length) - 1]
        : null;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final newPosition = animationController.value -
            details.primaryDelta! / MediaQuery.of(context).size.width;

        // each action is 1/5 of the screen
        final newActiveActionIndex = newPosition ~/ 0.2;
        if (newActiveActionIndex <= actions.length) {
          animationController.value = newPosition;
          activeActionIndex.value = newActiveActionIndex;
        }
      },
      onHorizontalDragEnd: (details) {
        // only trigger if the user has dragged far enough
        if (activeAction != null) {
          onTrigger(activeAction);
        }

        // reset and put the widget back to normal
        activeActionIndex.value = -1;
        animationController.reverse();
      },
      child: Stack(children: [
        if (activeAction != null)
          Positioned(
            right: 0,
            top: PostTile.rounding,
            bottom: PostTile.rounding,
            left: 0,
            child: ColoredBox(
                color: activeAction.activeColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 10),
                    child: Icon(activeAction.icon),
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

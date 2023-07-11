import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../actions/abstract_action.dart';
import '../hooks/logged_in_action.dart';
import '../util/observer_consumers.dart';
import 'post/post.dart';
import 'post/post_store.dart';

final _logger = Logger('SwipeActions');

class WithSwipeActions extends StatefulWidget {
  final Widget child;
  final List<LiftoffAction> actions;
  final instanceHost;

  const WithSwipeActions({
    super.key,
    required this.child,
    required this.actions,
    required this.instanceHost,
  });

  @override
  _SwipeActionState createState() => _SwipeActionState();
}

class _SwipeActionState extends State<WithSwipeActions>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late int _activeActionIndex;

  _SwipeActionState();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1, 0),
    ).animate(_animationController);
    _activeActionIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    // final loggedInAction = useLoggedInAction(context
    //     .select<PostStore, String>((store) => store.postView.instanceHost));
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final newPosition = _animationController.value -
            details.primaryDelta! / MediaQuery.of(context).size.width;

        // each action is 1/10 of the screen
        final newActiveActionIndex = newPosition ~/ 0.1;
        if (newActiveActionIndex <= widget.actions.length) {
          _animationController.value = newPosition;
        }

        if (newActiveActionIndex != _activeActionIndex) {
          setState(() {
            _activeActionIndex = newActiveActionIndex;
          });
        }
      },
      onHorizontalDragEnd: (details) {
        _animationController.reverse();
        if (_activeActionIndex > 0) {
          // loggedInAction(widget.actions[_activeActionIndex - 1].invoke);
        }
      },
      child: Stack(children: [
        if (_activeActionIndex > 0)
          Positioned(
            right: 0,
            top: PostTile.rounding,
            bottom: PostTile.rounding,
            left: 0,
            child: ColoredBox(
                color: widget
                    .actions[min(_activeActionIndex, widget.actions.length) - 1]
                    .activeColor,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 10),
                    child: Icon(widget
                        .actions[
                            min(_activeActionIndex, widget.actions.length) - 1]
                        .icon),
                  ),
                )),
          ),
        SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ]),
    );
  }
}

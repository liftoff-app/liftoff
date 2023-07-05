import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final _logger = Logger('ScrollChainer');

// Need to keep track of whether the user is scrolling or not, otherwise
// the scroll animation will be overridden by the user's scroll.
// Not using a stateful widget because it would cause an unnecessary rebuild
// of the widget tree.
// ignore: must_be_immutable
class ScrollChainer extends StatelessWidget {
  bool _scrolling = false;
  final Widget child;
  final Axis? axis;

  ScrollChainer({required this.child, this.axis});

  _getMinMaxPosition(double tryScrollTo, ScrollController controller) {
    return tryScrollTo < controller.position.minScrollExtent
        ? controller.position.minScrollExtent
        : tryScrollTo > controller.position.maxScrollExtent
            ? controller.position.maxScrollExtent
            : tryScrollTo;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      child: child,
      onNotification: (ScrollNotification notification) {
        // log axis and notification axis
        _logger.info(
            'axis: $axis, notification.metrics.axis: ${notification.metrics.axis}');
        if (axis != null && notification.metrics.axis != axis) {
          return false;
        }

        final controller = PrimaryScrollController.of(context);

        //users finger is still on the screen
        if (notification is OverscrollNotification &&
            notification.velocity == 0) {
          final scrollTo = _getMinMaxPosition(
              controller.position.pixels + (notification.overscroll),
              controller);
          controller.jumpTo(scrollTo);
        }
        //users finger left screen before limit of the listview was reached, but momentum takes it to the limit and beoyond
        else if (notification is OverscrollNotification) {
          final yVelocity = notification.velocity;
          _scrolling =
              true; //stops other notifiations overriding this scroll animation
          final scrollTo = _getMinMaxPosition(
              controller.position.pixels + (yVelocity / 5), controller);
          controller
              .animateTo(scrollTo,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.linearToEaseOut)
              .then((value) => _scrolling = false);
        }
        //users finger left screen after the limit of teh list view was reached
        else if (notification is ScrollEndNotification &&
            notification.depth > 0 &&
            !_scrolling) {
          final yVelocity =
              notification.dragDetails?.velocity.pixelsPerSecond.dy ?? 0;
          final scrollTo = _getMinMaxPosition(
              controller.position.pixels - (yVelocity / 5), controller);
          final scrollToPractical =
              scrollTo < controller.position.minScrollExtent
                  ? controller.position.minScrollExtent
                  : scrollTo > controller.position.maxScrollExtent
                      ? controller.position.maxScrollExtent
                      : scrollTo;
          controller.animateTo(scrollToPractical,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.linearToEaseOut);
        }

        return false;
      },
    );
  }
}

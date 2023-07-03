import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../pages/media_view.dart';
import '../util/goto.dart';
import 'clipped_image.dart';

/// If the media is pressed, it opens itself in a [MediaViewPage]
class FullscreenableImage extends StatelessWidget {
  final String url;
  final Widget child;
  final String heroTag = const Uuid().v4();

  FullscreenableImage({
    super.key,
    required this.url,
    required this.child,
  });

  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }

  static Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    final toHero = toHeroContext.widget as Hero;

    final toMediaQueryData = MediaQuery.maybeOf(toHeroContext);
    final fromMediaQueryData = MediaQuery.maybeOf(fromHeroContext);

    if (toMediaQueryData == null || fromMediaQueryData == null) {
      return toHero.child;
    }

    final fromHeroPadding = fromMediaQueryData.padding;
    final toHeroPadding = toMediaQueryData.padding;

    Widget widget = AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: toMediaQueryData.copyWith(
            padding: (flightDirection == HeroFlightDirection.push)
                ? EdgeInsetsTween(
                    begin: fromHeroPadding,
                    end: toHeroPadding,
                  ).evaluate(animation)
                : EdgeInsetsTween(
                    begin: toHeroPadding,
                    end: fromHeroPadding,
                  ).evaluate(animation),
          ),
          child: toHero.child,
        );
      },
    );

    /// We construct a custom flightShuttleBuilder primarily for this reason;
    /// the "pushed" direction, or tree that includes `MediaViewPage` uses
    /// a `PhotoView` widget. We're unable to safely apply `FitClippedWidget`
    /// as a destination.
    ///
    /// Therefore, only apply the FitClippedWidget while we're in flight. Once
    /// this hero animation is over, the underlying `PhotoView` is utiilized
    /// instead.
    if (flightDirection == HeroFlightDirection.push) {
      widget = FitClippedWidget(child: widget);
    }
    return widget;
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => goToMedia(context, url, heroTag),
        child: Hero(
          tag: heroTag,
          createRectTween: _createRectTween,
          flightShuttleBuilder: _flightShuttleBuilder,
          child: child,
        ),
      );
}

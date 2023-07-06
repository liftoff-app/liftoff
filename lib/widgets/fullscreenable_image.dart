import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../pages/media_view.dart';
import '../util/goto.dart';

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

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => goToMedia(context, url, heroTag),
        child: Hero(
          tag: heroTag,
          child: child,
        ),
      );
}

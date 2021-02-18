import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// User's avatar.
/// If passed url is null, a blank box is displayed to prevent weird indents
/// Can be disabled with `noBlank`
class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required this.url,
    this.radius = 25,
    this.noBlank = false,
  }) : super(key: key);

  final String url;
  final double radius;
  final bool noBlank;

  @override
  Widget build(BuildContext context) {
    final blankWidget = () {
      if (noBlank) return const SizedBox.shrink();

      return SizedBox(
        width: radius * 2,
        height: radius * 2,
      );
    }();

    if (url == null) {
      return blankWidget;
    }

    return ClipOval(
      child: CachedNetworkImage(
        height: radius * 2,
        width: radius * 2,
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => blankWidget,
      ),
    );
  }
}

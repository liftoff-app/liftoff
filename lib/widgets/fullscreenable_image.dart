import 'package:flutter/material.dart';

import '../pages/media_view.dart';

class FullscreenableImage extends StatelessWidget {
  final String url;
  final Widget child;

  const FullscreenableImage({
    Key key,
    @required this.url,
    @required this.child,
  }) : super(key: key);

  _onTap(BuildContext c) {
    Navigator.of(c).push(MaterialPageRoute(
      builder: (context) => MediaViewPage(url),
    ));
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => _onTap(context),
        child: Hero(
          tag: url,
          child: child,
        ),
      );
}

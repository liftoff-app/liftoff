import 'package:flutter/material.dart';

import '../pages/media_view.dart';

class FullscreenableImage extends StatelessWidget {
  final String url;
  final Widget child;

  const FullscreenableImage({Key key, this.url, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MediaViewPage(url),
        ));
      },
      child: Hero(
        tag: url,
        child: child,
      ),
    );
  }
}

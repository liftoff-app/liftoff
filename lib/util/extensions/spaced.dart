import 'package:flutter/material.dart';

/// Creates gaps between given widgets
extension SpaceWidgets on List<Widget> {
  List<Widget> spaced(double gap) => expand((item) sync* {
        yield SizedBox(width: gap, height: gap);
        yield item;
      }).skip(1).toList();
}

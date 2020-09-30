import 'package:flutter/cupertino.dart';

/// Creates gaps between given widgets
List<Widget> spaced(double gap, Iterable<Widget> children) => children
    .expand((item) sync* {
      yield SizedBox(width: gap, height: gap);
      yield item;
    })
    .skip(1)
    .toList();

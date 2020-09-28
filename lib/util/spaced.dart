import 'package:flutter/cupertino.dart';

List<Widget> spaced(double gap, Iterable<Widget> children) => children
    .expand((item) sync* {
      yield SizedBox(width: gap, height: gap);
      yield item;
    })
    .skip(1)
    .toList();

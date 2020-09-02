import 'package:flutter/material.dart';

Color textColorBasedOnBackground(Color color) {
  if (color.computeLuminance() > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

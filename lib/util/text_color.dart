import 'package:flutter/material.dart';

/// Given the background color, returns a text color
/// with a good contrast ratio
Color textColorBasedOnBackground(Color color) {
  if (color.computeLuminance() > 0.5) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}

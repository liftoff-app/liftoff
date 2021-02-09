import 'package:flutter/material.dart';

extension ReverseBrightness on Brightness {
  Brightness get reverse =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}

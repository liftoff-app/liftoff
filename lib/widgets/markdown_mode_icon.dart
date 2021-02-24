import 'package:flutter/material.dart';

/// shows either brush icon if fancy is true, or build icon if it's false
/// used mostly for pages where markdown editor is used
///
/// brush icon is rotated to look similarly to build icon
Widget markdownModeIcon({bool fancy}) => fancy
    ? const Icon(Icons.build)
    : const RotatedBox(
        quarterTurns: 1,
        child: Icon(Icons.brush),
      );

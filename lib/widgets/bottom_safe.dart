import 'package:flutter/material.dart';

class BottomSafe extends StatelessWidget {
  final double additionalPadding;
  const BottomSafe([this.additionalPadding = 0]);

  @override
  Widget build(BuildContext context) => SizedBox(
      height: MediaQuery.of(context).padding.bottom + additionalPadding);
}

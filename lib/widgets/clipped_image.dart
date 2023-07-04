import 'package:flutter/material.dart';

class FitClippedWidget extends StatelessWidget {
  const FitClippedWidget({
    super.key,
    required this.child,
    this.height = 300,
    this.fit = BoxFit.fitWidth,
  });

  final Widget child;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: height),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FittedBox(
          fit: fit,
          child: child,
        ),
      ),
    );
  }
}

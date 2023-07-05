import 'package:flutter/material.dart';

class FitScaledWidget extends StatelessWidget {
  const FitScaledWidget({
    super.key,
    required this.child,
    this.height = 300,
    this.fit = BoxFit.contain,
  });

  final Widget child;
  final double height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size.fromHeight(height)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: FittedBox(
          fit: fit,
          child: child,
        ),
      ),
    );
  }
}

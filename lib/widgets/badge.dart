import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;

  Badge({
    @required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: theme.accentColor,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: child,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;

  Badge({@required this.child});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      height: 25,
      decoration: BoxDecoration(
        color: theme.accentColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: child,
      ),
    );
  }
}

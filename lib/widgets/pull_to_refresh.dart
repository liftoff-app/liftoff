import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PullToRefresh extends StatelessWidget {
  final RefreshCallback onRefresh;
  final Widget child;

  const PullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await HapticFeedback.mediumImpact();
        await onRefresh();
      },
      child: child,
    );
  }
}

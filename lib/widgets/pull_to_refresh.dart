import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PullToRefresh extends StatelessWidget {
  final RefreshCallback onRefresh;
  final Widget child;

  const PullToRefresh({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

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

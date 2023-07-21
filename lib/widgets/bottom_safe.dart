import 'package:flutter/material.dart';

class BottomSafe extends StatelessWidget {
  final double additionalPadding;

  static const fabPadding =
      // FAB size + FAB margin, 56 is as per https://material.io/components/buttons-floating-action-button#anatomy
      56 + kFloatingActionButtonMargin;

  const BottomSafe({this.additionalPadding = 0, super.key});
  const BottomSafe.fab({key}) : this(additionalPadding: fabPadding, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.bottom + additionalPadding,
    );
  }
}

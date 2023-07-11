import 'package:flutter/widgets.dart';

import '../stores/accounts_store.dart';

@immutable
abstract class LiftoffAction {
  String get name;
  String get tooltip;
  IconData get icon;
  Color get activeColor;
  bool get isActivated;

  Future<void> Function(UserData userData) get invoke;
}

import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../stores/accounts_store.dart';
import '../observer_consumers.dart';

extension BuildContextExtensions on BuildContext {
  /// Get default [Jwt] for an instance
  Jwt? defaultJwt(String instanceHost) =>
      read<AccountsStore>().defaultUserDataFor(instanceHost)?.jwt;
}

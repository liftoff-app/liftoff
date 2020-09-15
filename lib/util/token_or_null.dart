import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';

/// returns either raw token for default user of `instanceUrl`
/// or null if this instance is not added or doesn't
/// have any user logged in
String tokenOrNull(BuildContext context, String instanceUrl) {
  final store = context.watch<AccountsStore>();

  if (!store.users.containsKey(instanceUrl) ||
      store.isAnonymousFor(instanceUrl)) {
    return null;
  }
  return store.defaultTokenFor(instanceUrl).raw;
}

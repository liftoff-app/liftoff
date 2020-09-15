import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../stores/accounts_store.dart';

/// returns either raw token for default user of `instanceUrl`
/// or null if this instance is not added or doesn't
/// have any user logged in
String tokenOrNull(BuildContext context, String instanceUrl) {
  if (context
      // ignore: avoid_types_on_closure_parameters
      .select((AccountsStore store) => store.isAnonymousFor(instanceUrl))) {
    return null;
  }
  return context
      // ignore: avoid_types_on_closure_parameters
      .select((AccountsStore store) => store.defaultTokenFor(instanceUrl).raw);
}

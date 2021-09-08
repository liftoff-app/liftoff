import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_from_string.dart';
import 'async_store.dart';
import 'observer_consumers.dart';

class AsyncStoreListener extends StatelessWidget {
  final AsyncStore asyncStore;
  final String? successMessage;
  final Widget child;

  const AsyncStoreListener({
    Key? key,
    required this.asyncStore,
    this.successMessage,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObserverListener<AsyncStore>(
      store: asyncStore,
      listener: (context, store) {
        final errorTerm = store.errorTerm;

        if (errorTerm != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(errorTerm.tr(context))));
        } else if (store.asyncState is AsyncStateData &&
            successMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(successMessage!)));
        }
      },
      child: child,
    );
  }
}

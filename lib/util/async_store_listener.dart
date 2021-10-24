import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../l10n/l10n_from_string.dart';
import 'async_store.dart';
import 'observer_consumers.dart';

class AsyncStoreListener<T> extends StatelessWidget {
  final AsyncStore<T> asyncStore;
  final String Function(
    BuildContext context,
    T data,
  )? successMessageBuilder;
  final Widget child;

  const AsyncStoreListener({
    Key? key,
    required this.asyncStore,
    this.successMessageBuilder,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObserverListener<AsyncStore<T>>(
      store: asyncStore,
      listener: (context, store) {
        final errorTerm = store.errorTerm;

        if (errorTerm != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(errorTerm.tr(context))));
        } else if (store.asyncState is AsyncStateData &&
            (successMessageBuilder != null)) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text(successMessageBuilder!(
                    context, (store.asyncState as AsyncStateData).data))));
        }
      },
      child: child,
    );
  }
}

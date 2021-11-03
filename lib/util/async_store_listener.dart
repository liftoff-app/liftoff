import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/single_child_widget.dart';

import '../l10n/l10n_from_string.dart';
import 'async_store.dart';
import 'observer_consumers.dart';

class AsyncStoreListener<T> extends SingleChildStatelessWidget {
  final AsyncStore<T> asyncStore;
  final String Function(
    BuildContext context,
    T data,
  )? successMessageBuilder;

  const AsyncStoreListener({
    Key? key,
    required this.asyncStore,
    this.successMessageBuilder,
    Widget? child,
  }) : super(key: key, child: child);

  Widget buildWithChild(BuildContext context, Widget? child) {
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
      child: child ?? const SizedBox(),
    );
  }
}

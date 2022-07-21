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

  final void Function(
    BuildContext context,
    T data,
  )? onSuccess;

  const AsyncStoreListener({
    super.key,
    required this.asyncStore,
    this.successMessageBuilder,
    this.onSuccess,
    super.child,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ObserverListener<AsyncStore<T>>(
      store: asyncStore,
      listener: (context, store) {
        store.map(
          loading: () {},
          error: (errorTerm) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(errorTerm.tr(context))));
          },
          data: (data) {
            onSuccess?.call(context, data);

            if (successMessageBuilder != null) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(successMessageBuilder!(context, data)),
                  ),
                );
            }
          },
        );
      },
      child: child ?? const SizedBox(),
    );
  }
}

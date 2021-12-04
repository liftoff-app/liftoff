import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'observer_consumers.dart';

/// Provides a mobx store and disposes it if it implements [DisposableStore]
///
/// Important: this will not make [context.watch] react to changes
class MobxProvider<T extends Store> extends Provider<T> {
  MobxProvider({
    Key? key,
    required Create<T> create,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          dispose: (context, store) {
            if (store is DisposableStore) store.dispose();
          },
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// will not dispose the store
  MobxProvider.value({
    Key? key,
    required T value,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          key: key,
          builder: builder,
          value: value,
          child: child,
        );
}

/// tracks reactions and disposes them in [DisposableStore.dispose]
mixin DisposableStore on Store {
  final List<ReactionDisposer> _disposers = [];

  @protected
  void addReaction(ReactionDisposer reaction) => _disposers.add(reaction);

  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }
}

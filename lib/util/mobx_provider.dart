import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'observer_consumers.dart';

/// Provides a mobx store and disposes it if it implements [DisposableStore]
///
/// Important: this will not make [context.watch] react to changes
class MobxProvider<T extends Store> extends Provider<T> {
  MobxProvider({
    super.key,
    required super.create,
    super.lazy,
    super.builder,
    super.child,
  }) : super(
          dispose: (context, store) {
            if (store is DisposableStore) store.dispose();
          },
        );

  /// will not dispose the store
  MobxProvider.value({
    super.key,
    required super.value,
    super.builder,
    super.child,
  }) : super.value();
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

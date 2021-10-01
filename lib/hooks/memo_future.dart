import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// creates an [AsyncSnapshot] from the Future returned from the valueBuilder.
/// [keys] can be used to rebuild the Future
AsyncSnapshot<T> useMemoFuture<T>(
  Future<T> Function() valueBuilder, [
  List<Object?> keys = const <Object>[],
]) =>
    useFuture(
      useMemoized<Future<T>>(valueBuilder, keys),
      preserveState: false,
      initialData: null,
    );

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

AsyncSnapshot<T> useMemoFuture<T>(Future<T> Function() valueBuilder,
        [List<Object> keys = const <dynamic>[]]) =>
    useFuture(useMemoized<Future<T>>(valueBuilder, keys));

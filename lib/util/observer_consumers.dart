import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Store;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

export 'package:provider/provider.dart';

typedef MobxBuilder<T extends Store> = Widget Function(BuildContext, T);
typedef MobxListener<T extends Store> = void Function(BuildContext, T);

class ObserverBuilder<T extends Store> extends StatelessWidget {
  final T? store;
  final MobxBuilder<T> builder;

  const ObserverBuilder({
    super.key,
    this.store,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return builder(
          context,
          store ?? context.read<T>(),
        );
      },
    );
  }
}

class ObserverListener<T extends Store> extends HookWidget {
  final T? store;
  final MobxListener<T> listener;
  final Widget child;

  const ObserverListener({
    super.key,
    this.store,
    required this.listener,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final disposer = autorun(
        (_) => listener(context, store ?? context.read<T>()),
      );

      return disposer;
    }, []);

    return child;
  }
}

class ObserverConsumer<T extends Store> extends HookWidget {
  final T? store;
  final MobxListener<T> listener;
  final MobxBuilder<T> builder;

  const ObserverConsumer({
    super.key,
    this.store,
    required this.listener,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ObserverListener(
      listener: listener,
      child: ObserverBuilder(store: store, builder: builder),
    );
  }
}

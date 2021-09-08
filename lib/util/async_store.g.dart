// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AsyncStore<T> on _AsyncStore<T>, Store {
  Computed<bool>? _$isLoadingComputed;

  @override
  bool get isLoading => (_$isLoadingComputed ??=
          Computed<bool>(() => super.isLoading, name: '_AsyncStore.isLoading'))
      .value;
  Computed<String?>? _$errorTermComputed;

  @override
  String? get errorTerm =>
      (_$errorTermComputed ??= Computed<String?>(() => super.errorTerm,
              name: '_AsyncStore.errorTerm'))
          .value;

  final _$asyncStateAtom = Atom(name: '_AsyncStore.asyncState');

  @override
  AsyncState<T> get asyncState {
    _$asyncStateAtom.reportRead();
    return super.asyncState;
  }

  @override
  set asyncState(AsyncState<T> value) {
    _$asyncStateAtom.reportWrite(value, super.asyncState, () {
      super.asyncState = value;
    });
  }

  final _$runAsyncAction = AsyncAction('_AsyncStore.run');

  @override
  Future<T?> run(AsyncValueGetter<T> callback) {
    return _$runAsyncAction.run(() => super.run(callback));
  }

  final _$runLemmyAsyncAction = AsyncAction('_AsyncStore.runLemmy');

  @override
  Future<T?> runLemmy(String instanceHost, LemmyApiQuery<T> query) {
    return _$runLemmyAsyncAction.run(() => super.runLemmy(instanceHost, query));
  }

  @override
  String toString() {
    return '''
asyncState: ${asyncState},
isLoading: ${isLoading},
errorTerm: ${errorTerm}
    ''';
  }
}

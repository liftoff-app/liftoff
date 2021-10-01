import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:mobx/mobx.dart';

part 'async_store.freezed.dart';
part 'async_store.g.dart';

/// [AsyncState] but observable with helper methods/getters
class AsyncStore<T> = _AsyncStore<T> with _$AsyncStore<T>;

abstract class _AsyncStore<T> with Store {
  @observable
  AsyncState<T> asyncState = const AsyncState.initial();

  @computed
  bool get isLoading => asyncState is AsyncStateLoading;

  @computed
  String? get errorTerm =>
      asyncState.whenOrNull(error: (errorTerm) => errorTerm);

  /// runs some async action and reflects the progress in [asyncState].
  /// If successful, the result is returned, otherwise null is returned.
  /// If this [AsyncStore] is already running some action, it will exit immediately and do nothing
  @action
  Future<T?> run(AsyncValueGetter<T> callback) async {
    if (isLoading) return null;

    asyncState = const AsyncState.loading();

    try {
      final result = await callback();

      asyncState = AsyncState.data(result);

      return result;
    } on SocketException {
      // TODO: use an existing l10n key
      asyncState = const AsyncState.error('network_error');
    } catch (err) {
      asyncState = AsyncState.error(err.toString());
      rethrow;
    }
  }

  /// [run] but specialized for a [LemmyApiQuery].
  /// Will catch [LemmyApiException] and map to its error term.
  @action
  Future<T?> runLemmy(String instanceHost, LemmyApiQuery<T> query) async {
    try {
      return await run(() => LemmyApiV3(instanceHost).run(query));
    } on LemmyApiException catch (err) {
      asyncState = AsyncState.error(err.message);
    }
  }
}

/// State in which an async action can be
@freezed
class AsyncState<T> with _$AsyncState {
  /// async action has not yet begun
  const factory AsyncState.initial() = AsyncStateInitial;

  /// async action completed successfully with [T]
  const factory AsyncState.data(T data) = AsyncStateData;

  /// async action is running at the moment
  const factory AsyncState.loading() = AsyncStateLoading;

  /// async action failed with a translatable error term
  const factory AsyncState.error(String errorTerm) = AsyncStateError;
}

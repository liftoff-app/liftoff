// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'async_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AsyncStateTearOff {
  const _$AsyncStateTearOff();

  AsyncStateInitial<T> initial<T>() {
    return AsyncStateInitial<T>();
  }

  AsyncStateData<T> data<T>(T data) {
    return AsyncStateData<T>(
      data,
    );
  }

  AsyncStateLoading<T> loading<T>() {
    return AsyncStateLoading<T>();
  }

  AsyncStateError<T> error<T>(String errorTerm) {
    return AsyncStateError<T>(
      errorTerm,
    );
  }
}

/// @nodoc
const $AsyncState = _$AsyncStateTearOff();

/// @nodoc
mixin _$AsyncState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T data) data,
    required TResult Function() loading,
    required TResult Function(String errorTerm) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncStateInitial<T> value) initial,
    required TResult Function(AsyncStateData<T> value) data,
    required TResult Function(AsyncStateLoading<T> value) loading,
    required TResult Function(AsyncStateError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsyncStateCopyWith<T, $Res> {
  factory $AsyncStateCopyWith(
          AsyncState<T> value, $Res Function(AsyncState<T>) then) =
      _$AsyncStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$AsyncStateCopyWithImpl<T, $Res>
    implements $AsyncStateCopyWith<T, $Res> {
  _$AsyncStateCopyWithImpl(this._value, this._then);

  final AsyncState<T> _value;
  // ignore: unused_field
  final $Res Function(AsyncState<T>) _then;
}

/// @nodoc
abstract class $AsyncStateInitialCopyWith<T, $Res> {
  factory $AsyncStateInitialCopyWith(AsyncStateInitial<T> value,
          $Res Function(AsyncStateInitial<T>) then) =
      _$AsyncStateInitialCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$AsyncStateInitialCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res>
    implements $AsyncStateInitialCopyWith<T, $Res> {
  _$AsyncStateInitialCopyWithImpl(
      AsyncStateInitial<T> _value, $Res Function(AsyncStateInitial<T>) _then)
      : super(_value, (v) => _then(v as AsyncStateInitial<T>));

  @override
  AsyncStateInitial<T> get _value => super._value as AsyncStateInitial<T>;
}

/// @nodoc

class _$AsyncStateInitial<T>
    with DiagnosticableTreeMixin
    implements AsyncStateInitial<T> {
  const _$AsyncStateInitial();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AsyncState<$T>.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'AsyncState<$T>.initial'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is AsyncStateInitial<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T data) data,
    required TResult Function() loading,
    required TResult Function(String errorTerm) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncStateInitial<T> value) initial,
    required TResult Function(AsyncStateData<T> value) data,
    required TResult Function(AsyncStateLoading<T> value) loading,
    required TResult Function(AsyncStateError<T> value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AsyncStateInitial<T> implements AsyncState<T> {
  const factory AsyncStateInitial() = _$AsyncStateInitial<T>;
}

/// @nodoc
abstract class $AsyncStateDataCopyWith<T, $Res> {
  factory $AsyncStateDataCopyWith(
          AsyncStateData<T> value, $Res Function(AsyncStateData<T>) then) =
      _$AsyncStateDataCopyWithImpl<T, $Res>;
  $Res call({T data});
}

/// @nodoc
class _$AsyncStateDataCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res>
    implements $AsyncStateDataCopyWith<T, $Res> {
  _$AsyncStateDataCopyWithImpl(
      AsyncStateData<T> _value, $Res Function(AsyncStateData<T>) _then)
      : super(_value, (v) => _then(v as AsyncStateData<T>));

  @override
  AsyncStateData<T> get _value => super._value as AsyncStateData<T>;

  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(AsyncStateData<T>(
      data == freezed
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$AsyncStateData<T>
    with DiagnosticableTreeMixin
    implements AsyncStateData<T> {
  const _$AsyncStateData(this.data);

  @override
  final T data;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AsyncState<$T>.data(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AsyncState<$T>.data'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AsyncStateData<T> &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(data);

  @JsonKey(ignore: true)
  @override
  $AsyncStateDataCopyWith<T, AsyncStateData<T>> get copyWith =>
      _$AsyncStateDataCopyWithImpl<T, AsyncStateData<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T data) data,
    required TResult Function() loading,
    required TResult Function(String errorTerm) error,
  }) {
    return data(this.data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
  }) {
    return data?.call(this.data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this.data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncStateInitial<T> value) initial,
    required TResult Function(AsyncStateData<T> value) data,
    required TResult Function(AsyncStateLoading<T> value) loading,
    required TResult Function(AsyncStateError<T> value) error,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class AsyncStateData<T> implements AsyncState<T> {
  const factory AsyncStateData(T data) = _$AsyncStateData<T>;

  T get data => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AsyncStateDataCopyWith<T, AsyncStateData<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AsyncStateLoadingCopyWith<T, $Res> {
  factory $AsyncStateLoadingCopyWith(AsyncStateLoading<T> value,
          $Res Function(AsyncStateLoading<T>) then) =
      _$AsyncStateLoadingCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$AsyncStateLoadingCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res>
    implements $AsyncStateLoadingCopyWith<T, $Res> {
  _$AsyncStateLoadingCopyWithImpl(
      AsyncStateLoading<T> _value, $Res Function(AsyncStateLoading<T>) _then)
      : super(_value, (v) => _then(v as AsyncStateLoading<T>));

  @override
  AsyncStateLoading<T> get _value => super._value as AsyncStateLoading<T>;
}

/// @nodoc

class _$AsyncStateLoading<T>
    with DiagnosticableTreeMixin
    implements AsyncStateLoading<T> {
  const _$AsyncStateLoading();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AsyncState<$T>.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'AsyncState<$T>.loading'));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is AsyncStateLoading<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T data) data,
    required TResult Function() loading,
    required TResult Function(String errorTerm) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncStateInitial<T> value) initial,
    required TResult Function(AsyncStateData<T> value) data,
    required TResult Function(AsyncStateLoading<T> value) loading,
    required TResult Function(AsyncStateError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AsyncStateLoading<T> implements AsyncState<T> {
  const factory AsyncStateLoading() = _$AsyncStateLoading<T>;
}

/// @nodoc
abstract class $AsyncStateErrorCopyWith<T, $Res> {
  factory $AsyncStateErrorCopyWith(
          AsyncStateError<T> value, $Res Function(AsyncStateError<T>) then) =
      _$AsyncStateErrorCopyWithImpl<T, $Res>;
  $Res call({String errorTerm});
}

/// @nodoc
class _$AsyncStateErrorCopyWithImpl<T, $Res>
    extends _$AsyncStateCopyWithImpl<T, $Res>
    implements $AsyncStateErrorCopyWith<T, $Res> {
  _$AsyncStateErrorCopyWithImpl(
      AsyncStateError<T> _value, $Res Function(AsyncStateError<T>) _then)
      : super(_value, (v) => _then(v as AsyncStateError<T>));

  @override
  AsyncStateError<T> get _value => super._value as AsyncStateError<T>;

  @override
  $Res call({
    Object? errorTerm = freezed,
  }) {
    return _then(AsyncStateError<T>(
      errorTerm == freezed
          ? _value.errorTerm
          : errorTerm // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AsyncStateError<T>
    with DiagnosticableTreeMixin
    implements AsyncStateError<T> {
  const _$AsyncStateError(this.errorTerm);

  @override
  final String errorTerm;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AsyncState<$T>.error(errorTerm: $errorTerm)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AsyncState<$T>.error'))
      ..add(DiagnosticsProperty('errorTerm', errorTerm));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is AsyncStateError<T> &&
            (identical(other.errorTerm, errorTerm) ||
                const DeepCollectionEquality()
                    .equals(other.errorTerm, errorTerm)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(errorTerm);

  @JsonKey(ignore: true)
  @override
  $AsyncStateErrorCopyWith<T, AsyncStateError<T>> get copyWith =>
      _$AsyncStateErrorCopyWithImpl<T, AsyncStateError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(T data) data,
    required TResult Function() loading,
    required TResult Function(String errorTerm) error,
  }) {
    return error(errorTerm);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
  }) {
    return error?.call(errorTerm);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(T data)? data,
    TResult Function()? loading,
    TResult Function(String errorTerm)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(errorTerm);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AsyncStateInitial<T> value) initial,
    required TResult Function(AsyncStateData<T> value) data,
    required TResult Function(AsyncStateLoading<T> value) loading,
    required TResult Function(AsyncStateError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AsyncStateInitial<T> value)? initial,
    TResult Function(AsyncStateData<T> value)? data,
    TResult Function(AsyncStateLoading<T> value)? loading,
    TResult Function(AsyncStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AsyncStateError<T> implements AsyncState<T> {
  const factory AsyncStateError(String errorTerm) = _$AsyncStateError<T>;

  String get errorTerm => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AsyncStateErrorCopyWith<T, AsyncStateError<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

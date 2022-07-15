// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_block_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserBlockStore on _UserBlockStore, Store {
  late final _$blockedAtom =
      Atom(name: '_UserBlockStore.blocked', context: context);

  @override
  bool get blocked {
    _$blockedAtom.reportRead();
    return super.blocked;
  }

  @override
  set blocked(bool value) {
    _$blockedAtom.reportWrite(value, super.blocked, () {
      super.blocked = value;
    });
  }

  @override
  String toString() {
    return '''
blocked: ${blocked}
    ''';
  }
}

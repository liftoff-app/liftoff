/// creates a file with l10n translations from string
import 'dart:convert';
import 'dart:io';

const baseFile = 'intl_en.arb';
const autoGenHeader = '// FILE GENERATED AUTOMATICALLY, TO NOT EDIT BY HAND';

Future<void> main(List<String> args) async {
  final strings = jsonDecode(await File('lib/l10n/$baseFile').readAsString())
      as Map<String, dynamic>;

  final keys = strings.keys.where((key) => !key.startsWith('@')).toSet();
  final keysWithoutVariables = keys.where((key) {
    final metadata = strings['@$key'] as Map<String, dynamic>;
    final placeholders = metadata['placeholders'] as Map<String, dynamic>?;

    return placeholders?.isEmpty ?? true;
  }).toSet();

  await File('lib/l10n/l10n_from_string.dart').writeAsString('''$autoGenHeader
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

abstract class L10nStrings {
${keys.map((key) => "  static const $key = '$key';").join('\n')}
}

extension L10nFromString on String {
  String tr(BuildContext context) {
    switch (this) {
${keysWithoutVariables.map((key) => "      case L10nStrings.$key:\n        return L10n.of(context)!.$key;").join('\n')}

      default:
        return this;
    }
  }
}
''');

  await Process.run('flutter', ['format', '.']);
}

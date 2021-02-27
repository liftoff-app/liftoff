import 'package:flutter/material.dart';

export 'package:flutter_gen/gen_l10n/l10n.dart';

abstract class LocaleSerde {
  static Locale fromJson(String json) {
    if (json == null) return null;

    final lang = json.split('-');

    return Locale(lang[0], lang.length > 1 ? lang[1] : null);
  }

  static String toJson(Locale locale) => locale.toLanguageTag();
}

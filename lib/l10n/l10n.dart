import 'package:flutter/material.dart';

export 'package:flutter_gen/gen_l10n/l10n.dart';

export 'l10n_api.dart';
export 'l10n_from_string.dart';

abstract class LocaleSerde {
  static Locale? fromJson(String? json) {
    if (json == null) return null;

    final lang = json.split('-');

    return Locale(lang[0], lang.length > 1 ? lang[1] : null);
  }

  static String toJson(Locale locale) => locale.toLanguageTag();
}

const _languageNames = {
  'ca': 'Català',
  'ar': 'عربي',
  'en': 'English',
  'el': 'Ελληνικά',
  'eu': 'Euskara',
  'eo': 'Esperanto',
  'es': 'Español',
  'da': 'Dansk',
  'de': 'Deutsch',
  'ga': 'Gaeilge',
  'gl': 'Galego',
  'hr': 'hrvatski',
  'hu': 'Magyar Nyelv',
  'ka': 'ქართული ენა',
  'ko': '한국어',
  'km': 'ភាសាខ្មែរ',
  'hi': 'मानक हिन्दी',
  'fa': 'فارسی',
  'ja': '日本語',
  'oc': 'Occitan',
  'pl': 'Polski',
  'pt': 'Português',
  'pt_BR': 'Português Brasileiro',
  'zh': '中文',
  'fi': 'Suomi',
  'fr': 'Français',
  'sv': 'Svenska',
  'sq': 'Shqip',
  'sr_Latn': 'srpski',
  'th': 'ภาษาไทย',
  'tr': 'Türkçe',
  'uk': 'Українська Mова',
  'ru': 'Русский',
  'nl': 'Nederlands',
  'it': 'Italiano',
};

extension LanguageName on Locale {
  /// returns the name of the language in the given language
  String get languageName => _languageNames[toString()] ?? toString();
}

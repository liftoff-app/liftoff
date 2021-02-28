/// migrates chosen strings from lemmy-translations into flutter's i18n solution
import 'dart:convert';
import 'dart:io';

import 'common.dart';

/// Map<key, renamedKey>, if `renamedKey` is null then no rename is performed
const toExtract = {
  'settings': null,
};

const repoName = 'lemmy-translations';
const baseLanguage = 'en';
const flutterIntlPrefix = 'intl_';

Future<void> main(List<String> args) async {
  final force = args.contains('-f') || args.contains('--force');

  final repoCleanup = await cloneLemmyTranslations();

  final lemmyTranslations = await loadLemmyStrings();
  final lemmurTranslations = await loadLemmurStrings();
  portStrings(lemmyTranslations, lemmurTranslations, force: force);

  await save(lemmurTranslations);

  await Process.run('flutter', ['gen-l10n']);

  await repoCleanup();

  print("Don't forget to format the arb files!");
}

/// returns a cleanup function
Future<Future<void> Function()> cloneLemmyTranslations() async {
  await Process.run('git', ['clone', 'https://github.com/LemmyNet/$repoName']);

  return () => Directory(repoName).delete(recursive: true);
}

/// Map<languageTag, Map<stringKey, stringValue>>
Future<Map<String, Map<String, String>>> loadLemmyStrings() async {
  final translationsDir = Directory('$repoName/translations');
  final translations = <String, Map<String, String>>{};

  await for (final file in translationsDir.list()) {
    final transFile = File.fromUri(file.uri);
    final trans = Map<String, String>.from(
      jsonDecode(await transFile.readAsString()) as Map<String, dynamic>,
    );

    final localeName = file.uri.pathSegments.last.split('.json').first;
    translations[localeName] = trans;
  }

  return translations;
}

/// Map<languageTag, Map<stringKey, stringValue>> + some metadata
Future<Map<String, Map<String, dynamic>>> loadLemmurStrings() async {
  final translationsDir = Directory('lib/l10n');
  final translations = <String, Map<String, dynamic>>{};

  await for (final file in translationsDir.list()) {
    if (!file.path.endsWith('.arb')) continue;

    final transFile = File.fromUri(file.uri);
    final trans =
        jsonDecode(await transFile.readAsString()) as Map<String, dynamic>;

    final localeName = file.uri.pathSegments.last
        .split('.arb')
        .first
        .split(flutterIntlPrefix)
        .last;
    translations[localeName] = trans;
  }

  return translations;
}

/// will port them into `lemmurTranslations`
void portStrings(
  Map<String, Map<String, String>> lemmyTranslations,
  Map<String, Map<String, dynamic>> lemmurTranslations, {
  bool force = false,
}) {
  // port all languages
  for (final language in lemmyTranslations.keys) {
    if (!lemmurTranslations.containsKey(language)) {
      lemmurTranslations[language] = {};
      lemmurTranslations[language]['@@locale'] = language;
    }
  }

  for (final extract in toExtract.entries) {
    final key = extract.key;
    final renamedKey = extract.value ?? key;

    if (!lemmyTranslations[baseLanguage].containsKey(key)) {
      printError(
        '"$key" does not exist in $repoName',
        shouldExit: true,
      );
    }

    if (lemmurTranslations[baseLanguage].containsKey(key) && !force) {
      confirm('"$key" already exists in lemmur, overwrite?');
    }

    for (final trans in lemmyTranslations.entries) {
      final language = trans.key;
      final strings = trans.value;

      lemmurTranslations[language][renamedKey] = strings[key];
    }
    lemmurTranslations[baseLanguage]['@$renamedKey'] = {};
  }
}

Future<void> save(Map<String, Map<String, dynamic>> lemmurTranslations) async {
  // remove null fields
  // Vec<(language, key)>
  final toRemove = <List<String>>[];
  for (final translations in lemmurTranslations.entries) {
    final language = translations.key;

    for (final strings in translations.value.entries) {
      if (strings.value == null) {
        toRemove.add([language, strings.key]);
      }
    }
  }
  for (final rem in toRemove) {
    lemmurTranslations[rem[0]].remove(rem[1]);
  }

  for (final language in lemmurTranslations.keys) {
    await File('lib/l10n/$flutterIntlPrefix$language.arb')
        .writeAsString(jsonEncode(lemmurTranslations[language]));
  }
}

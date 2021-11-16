/// migrates chosen strings from lemmy-translations into flutter's i18n solution
/// uses prettier to format the files
import 'dart:convert';
import 'dart:io';

import 'common.dart';
import 'gen_l10n_from_string.dart' as gen;

// config for migration of a single key
// ignore: camel_case_types
class _ {
  final String key;
  final String? rename;

  /// make all letters except the first one lower case
  final bool decapitalize;
  final bool toLowerCase;

  /// arb format for the placeholder
  final String? format;

  /// arb type for the placeholder
  final String? type;

  const _(
    this.key, {
    this.rename,
    this.decapitalize = false,
    this.toLowerCase = false,
    this.format,
    this.type,
  });

  String get renamedKey => rename ?? key;

  // will transform a value of a translation of the base language
  String transform(String input) {
    if (toLowerCase) return input.toLowerCase();

    if (decapitalize) return '${input[0]}${input.substring(1).toLowerCase()}';

    return input;
  }
}

const toMigrate = <_>[
  _('settings'),
  _('password'),
  _('email_or_username'),
  _('posts'),
  _('comments'),
  _('modlog'),
  _('community'),
  _('url'),
  _('title'),
  _('body'),
  _('nsfw'),
  _('post'),
  _('save'),
  _('subscribed'),
  _('local'),
  _('all'),
  _('replies'),
  _('mentions'),
  _('from'),
  _('to'),
  _('deleted', rename: 'deleted_by_creator'),
  _('more'),
  _('mark_as_read'),
  _('mark_as_unread'),
  _('reply'),
  _('edit'),
  _('delete'),
  _('restore'),
  _('yes'),
  _('no'),
  _('avatar'),
  _('banner'),
  _('display_name'),
  _('bio'),
  _('email'),
  _('matrix_user_id', rename: 'matrix_user'),
  _('sort_type'),
  _('type'),
  _('show_nsfw'),
  _('send_notifications_to_email'),
  _('delete_account', decapitalize: true),
  _('saved'),
  _('communities'),
  _('users'),
  _('theme'),
  _('language'),
  _('hot'),
  _('new', rename: 'new_'),
  _('old'),
  _('top'),
  _('chat'),
  _('admin'),
  _('by'),
  _('not_a_mod_or_admin'),
  _('not_an_admin'),
  _('couldnt_find_post'),
  _('not_logged_in'),
  _('site_ban'),
  _('community_ban'),
  _('downvotes_disabled'),
  _('invalid_url'),
  _('locked'),
  _('couldnt_create_comment'),
  _('couldnt_like_comment'),
  _('couldnt_update_comment'),
  _('no_comment_edit_allowed'),
  _('couldnt_save_comment'),
  _('couldnt_get_comments'),
  _('report_reason_required'),
  _('report_too_long'),
  _('couldnt_create_report'),
  _('couldnt_resolve_report'),
  _('invalid_post_title'),
  _('couldnt_create_post'),
  _('couldnt_like_post'),
  _('couldnt_find_community'),
  _('couldnt_get_posts'),
  _('no_post_edit_allowed'),
  _('couldnt_save_post'),
  _('site_already_exists'),
  _('couldnt_update_site'),
  _('invalid_community_name'),
  _('community_already_exists'),
  _('community_moderator_already_exists'),
  _('community_follower_already_exists'),
  _('not_a_moderator'),
  _('couldnt_update_community'),
  _('no_community_edit_allowed'),
  _('system_err_login'),
  _('community_user_already_banned'),
  _('couldnt_find_that_username_or_email'),
  _('password_incorrect'),
  _('registration_closed'),
  _('invalid_password'),
  _('passwords_dont_match'),
  _('captcha_incorrect'),
  _('invalid_username'),
  _('bio_length_overflow'),
  _('couldnt_update_user'),
  _('couldnt_update_private_message'),
  _('couldnt_update_post'),
  _('couldnt_create_private_message'),
  _('no_private_message_edit_allowed'),
  _('post_title_too_long'),
  _('email_already_exists'),
  _('user_already_exists'),
  _('number_online', rename: 'number_of_users_online'),
  _('number_of_comments', type: 'int', format: 'compact', toLowerCase: true),
  _('number_of_posts', type: 'int', format: 'compact', toLowerCase: true),
  _('number_of_subscribers'),
  _('number_of_users'),
  _('unsubscribe', toLowerCase: true),
  _('subscribe', toLowerCase: true),
  _('messages'),
  _('banned_users', decapitalize: true),
  _('delete_account_confirm'),
  _('new_password', decapitalize: true),
  _('verify_password', decapitalize: true),
  _('old_password', decapitalize: true),
  _('show_avatars', decapitalize: true),
  _('search', toLowerCase: true),
  _('send_message', decapitalize: true),
  _('top_day'),
  _('top_week'),
  _('top_month'),
  _('top_year'),
  _('top_all'),
  _('most_comments'),
  _('new_comments'),
  _('active'),
  _('bot_account'),
  _('show_bot_accounts'),
  _('show_read_posts'),
];

const repoName = 'lemmy-translations';
const baseLanguage = 'en';
const flutterIntlPrefix = 'intl_';
final outDir = RegExp('^arb-dir: (.+)')
    .firstMatch(File('l10n.yaml').readAsStringSync())!
    .group(1)!;

Future<void> main(List<String> args) async {
  final force = args.contains('-f') || args.contains('--force');

  checkDuplicateKeys();

  final repoCleanup = await cloneLemmyTranslations();

  final lemmyTranslations = await loadLemmyStrings();
  final lemmurTranslations = await loadLemmurStrings();
  portStrings(lemmyTranslations, lemmurTranslations, force: force);

  await save(lemmurTranslations);

  await repoCleanup();

  await Process.run('npx', [
    'prettier',
    '$outDir/*.arb',
    '--parser',
    'json',
    '--write',
    '--print-width',
    '1',
  ]);

  await gen.main(args);
}

/// check if `toMigrate` has duplicate keys
void checkDuplicateKeys() {
  final seen = <String>{};
  for (final renamedKey in toMigrate.map((e) => e.renamedKey)) {
    if (seen.contains(renamedKey)) {
      printError(
          'The renamedKey "$renamedKey" appears more than once in "toMigrate"');
    }
    seen.add(renamedKey);
  }
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
  final translationsDir = Directory(outDir);
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
      lemmurTranslations[language] = {'@@locale': language};
    }
  }

  final baseTranslations = lemmyTranslations[baseLanguage]!;

  for (final migrate in toMigrate) {
    if (!baseTranslations.containsKey(migrate.key)) {
      printError('"${migrate.key}" does not exist in $repoName');
    }

    if (lemmurTranslations[baseLanguage]!.containsKey(migrate.renamedKey) &&
        !force) {
      confirm('"${migrate.key}" already exists in lemmur, overwrite?');
    }

    final variableName = RegExp(r'{{([\w_]+)}|')
        .firstMatch(baseTranslations[migrate.key]!)
        ?.group(1);

    final metadata = <String, dynamic>{
      if (variableName != null)
        'placeholders': {
          variableName: {
            if (migrate.type != null) 'type': migrate.type,
            if (migrate.format != null) 'format': migrate.format,
          },
        },
    };
    // ignore: omit_local_variable_types
    String? Function(Map<String, String> translations) transformer =
        (translations) => translations[migrate.key];

    // check if it has a plural form
    if (baseTranslations.containsKey('${migrate.key}_plural')) {
      transformer = (translations) {
        if (translations[migrate.key] == null) return null;

        final fixedVariables = translations[migrate.key]!
            .replaceAll('{{$variableName}}', '{$variableName}');

        final pluralForm = () {
          if (translations.containsKey('${migrate.key}_plural')) {
            return translations['${migrate.key}_plural']!
                .replaceAll('{{$variableName}}', '{$variableName}');
          }

          return null;
        }();

        if (pluralForm == null) {
          return '{$variableName,plural, other{$fixedVariables}}';
        }

        return '{$variableName,plural, =1{$fixedVariables} other{$pluralForm}}';
      };
    }

    for (final trans in lemmyTranslations.entries) {
      final language = trans.key;
      final strings = trans.value;

      lemmurTranslations[language]![migrate.renamedKey] = transformer(strings);
    }
    final transformed = transformer(baseTranslations);
    if (transformed != null) {
      lemmurTranslations[baseLanguage]![migrate.renamedKey] =
          migrate.transform(transformed);
    }
    lemmurTranslations[baseLanguage]!['@${migrate.renamedKey}'] = metadata;
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
    lemmurTranslations[rem[0]]?.remove(rem[1]);
  }

  for (final language in lemmurTranslations.keys) {
    await File('$outDir/$flutterIntlPrefix$language.arb')
        .writeAsString(jsonEncode(lemmurTranslations[language]));
  }
}

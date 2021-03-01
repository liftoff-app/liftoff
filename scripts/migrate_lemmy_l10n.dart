/// migrates chosen strings from lemmy-translations into flutter's i18n solution
/// uses prettier to format the files
import 'dart:convert';
import 'dart:io';

import 'common.dart';

/// Map<key, renamedKey>, if `renamedKey` is null then no rename is performed
const toExtract = {
  'settings': null,
  'password': null,
  'email_or_username': null,
  'posts': null,
  'comments': null,
  'modlog': null,
  'community': null,
  'url': null,
  'title': null,
  'body': null,
  'nsfw': null,
  'post': null,
  'save': null,
  'send_message': null,
  'subscribed': null,
  'local': null,
  'all': null,
  'replies': null,
  'mentions': null,
  'from': null,
  'to': null,
  'deleted': 'deleted_by_creator',
  'more': null,
  'mark_as_read': null,
  'mark_as_unread': null,
  'reply': null,
  'edit': null,
  'delete': null,
  'restore': null,
  'yes': null,
  'no': null,
  'avatar': null,
  'banner': null,
  'display_name': null,
  'bio': null,
  'email': null,
  'matrix_user_id': 'matrix_user',
  'sort_type': null,
  'type': null,
  'show_nsfw': null,
  'send_notifications_to_email': null,
  'delete_account': null,
  'saved': null,
  'communities': null,
  'users': null,
  'theme': null,
  'language': null,
  'hot': null,
  'new': null,
  'old': null,
  'top': null,
  'chat': null,
  'admin': null,
  'by': null,
  'not_a_mod_or_admin': null,
  'not_an_admin': null,
  'couldnt_find_post': null,
  'not_logged_in': null,
  'site_ban': null,
  'community_ban': null,
  'downvotes_disabled': null,
  'invalid_url': null,
  'locked': null,
  'couldnt_create_comment': null,
  'couldnt_like_comment': null,
  'couldnt_update_comment': null,
  'no_comment_edit_allowed': null,
  'couldnt_save_comment': null,
  'couldnt_get_comments': null,
  'report_reason_required': null,
  'report_too_long': null,
  'couldnt_create_report': null,
  'couldnt_resolve_report': null,
  'invalid_post_title': null,
  'couldnt_create_post': null,
  'couldnt_like_post': null,
  'couldnt_find_community': null,
  'couldnt_get_posts': null,
  'no_post_edit_allowed': null,
  'couldnt_save_post': null,
  'site_already_exists': null,
  'couldnt_update_site': null,
  'invalid_community_name': null,
  'community_already_exists': null,
  'community_moderator_already_exists': null,
  'community_follower_already_exists': null,
  'not_a_moderator': null,
  'couldnt_update_community': null,
  'no_community_edit_allowed': null,
  'system_err_login': null,
  'community_user_already_banned': null,
  'couldnt_find_that_username_or_email': null,
  'password_incorrect': null,
  'registration_closed': null,
  'invalid_password': null,
  'passwords_dont_match': null,
  'captcha_incorrect': null,
  'invalid_username': null,
  'bio_length_overflow': null,
  'couldnt_update_user': null,
  'couldnt_update_private_message': null,
  'couldnt_update_post': null,
  'couldnt_create_private_message': null,
  'no_private_message_edit_allowed': null,
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

  await repoCleanup();

  await Process.run(
      'npx', ['prettier', 'lib/l10n/*.arb', '--parser', 'json', '--write']);
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
      printError('"$key" does not exist in $repoName');
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

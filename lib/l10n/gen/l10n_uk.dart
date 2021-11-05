import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Ukrainian (`uk`).
class L10nUk extends L10n {
  L10nUk([String locale = 'uk']) : super(locale);

  @override
  String get settings => 'Налаштування';

  @override
  String get password => 'Пароль';

  @override
  String get email_or_username => 'email або ім\'я користувача';

  @override
  String get posts => 'Записи';

  @override
  String get comments => 'Коментарі';

  @override
  String get modlog => 'Модлог';

  @override
  String get community => 'Спільнота';

  @override
  String get url => 'URL';

  @override
  String get title => 'Назва';

  @override
  String get body => 'Тіло';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'Запис';

  @override
  String get save => 'зберегти';

  @override
  String get subscribed => 'Підписані';

  @override
  String get local => 'Local';

  @override
  String get all => 'Все';

  @override
  String get replies => 'Відповіді';

  @override
  String get mentions => 'Згадування';

  @override
  String get from => 'від';

  @override
  String get to => 'в';

  @override
  String get deleted_by_creator => 'видалено автором';

  @override
  String get more => 'більше';

  @override
  String get mark_as_read => 'позначити як прочитані';

  @override
  String get mark_as_unread => 'позначити як непрочитані';

  @override
  String get reply => 'відповісти';

  @override
  String get edit => 'редагувати';

  @override
  String get delete => 'видалити';

  @override
  String get restore => 'відновити';

  @override
  String get yes => 'так';

  @override
  String get no => 'ні';

  @override
  String get avatar => 'Аватар';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Display name';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'email';

  @override
  String get matrix_user => 'Matrix айді користувача';

  @override
  String get sort_type => 'Тип сортування';

  @override
  String get type => 'Тип';

  @override
  String get show_nsfw => 'Показувати NSFW-контент';

  @override
  String get send_notifications_to_email =>
      'Посилати повідомлення на e-mail адресу';

  @override
  String get delete_account => 'Видалити акаунт';

  @override
  String get saved => 'Збережено';

  @override
  String get communities => 'Спільноти';

  @override
  String get users => 'Користувачі';

  @override
  String get theme => 'Візуальна тема';

  @override
  String get language => 'Мова';

  @override
  String get hot => 'Популярне';

  @override
  String get new_ => 'Нове';

  @override
  String get old => 'Старе';

  @override
  String get top => 'Найкраще';

  @override
  String get chat => 'Чат';

  @override
  String get admin => 'адміністратор';

  @override
  String get by => 'від';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Не адміністратор.';

  @override
  String get couldnt_find_post => 'Не вдалося знайти запис.';

  @override
  String get not_logged_in => 'Не авторизовані.';

  @override
  String get site_ban => 'Ви були заблоковані на данному сайті';

  @override
  String get community_ban => 'Ви були заблоковані в цій спільноті.';

  @override
  String get downvotes_disabled => 'Від\'ємне голосування вимкненно.';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => 'заблоковоано';

  @override
  String get couldnt_create_comment => 'Не вдалося створити коментар.';

  @override
  String get couldnt_like_comment => 'Не вдалося лайкнути коментар.';

  @override
  String get couldnt_update_comment => 'Не вдалося обновити коментар.';

  @override
  String get no_comment_edit_allowed => 'Неможливо відредагувати коментар.';

  @override
  String get couldnt_save_comment => 'Не вдалося зберегти коментар.';

  @override
  String get couldnt_get_comments => 'Не вдалося отримати коментар.';

  @override
  String get report_reason_required => 'Report reason required.';

  @override
  String get report_too_long => 'Report too long.';

  @override
  String get couldnt_create_report => 'Couldn\'t create report.';

  @override
  String get couldnt_resolve_report => 'Couldn\'t resolve report.';

  @override
  String get invalid_post_title => 'Invalid post title';

  @override
  String get couldnt_create_post => 'Не вдалося створити запис.';

  @override
  String get couldnt_like_post => 'Не вдалося лайкнути запис.';

  @override
  String get couldnt_find_community => 'Не вдалося знайти спільноту.';

  @override
  String get couldnt_get_posts => 'Не вдалося знайти записи';

  @override
  String get no_post_edit_allowed => 'Неможливо відредагувати запис.';

  @override
  String get couldnt_save_post => 'Не вдалося зберегти запис.';

  @override
  String get site_already_exists => 'Сайт вже існує.';

  @override
  String get couldnt_update_site => 'Не вдалося оновити сайт.';

  @override
  String get invalid_community_name => 'Неправильне ім\'я користувача.';

  @override
  String get community_already_exists => 'Спільнота вже існує.';

  @override
  String get community_moderator_already_exists =>
      'Модератор спільноти вже існує.';

  @override
  String get community_follower_already_exists =>
      'Підписник спільноти вже існує.';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community => 'Не вдалося обновити спільноту.';

  @override
  String get no_community_edit_allowed => 'Неможливо відредагувати спільноту.';

  @override
  String get system_err_login =>
      'Системна помилка. Спробуйте вийти та зайти назад.';

  @override
  String get community_user_already_banned => 'Член спільноти вже забаниний..';

  @override
  String get couldnt_find_that_username_or_email =>
      'Не вдалося знайти ім\'я користувача чи email.';

  @override
  String get password_incorrect => 'Неправильний пароль.';

  @override
  String get registration_closed => 'Реєстрацію закрито';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'Паролі не співпадають.';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Неправильне ім\'я користувача.';

  @override
  String get bio_length_overflow => 'User bio cannot exceed 300 characters.';

  @override
  String get couldnt_update_user => 'Не вдалося оновити користувача.';

  @override
  String get couldnt_update_private_message =>
      'Не вдалося оновити особисте повідомлення.';

  @override
  String get couldnt_update_post => 'Не вдалося обновити запис';

  @override
  String get couldnt_create_private_message =>
      'Не вдалося отримати особисте повідомлення.';

  @override
  String get no_private_message_edit_allowed =>
      'Не можна редагувати особисті повідомлення.';

  @override
  String get post_title_too_long =>
      'Довжина назви перебільшує допустимий ліміт.';

  @override
  String get email_already_exists => 'E-mail вже існує.';

  @override
  String get user_already_exists => 'Користувач вже існує.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count user online',
      other: '$count users online',
    );
  }

  @override
  String number_of_comments(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$countString comment',
      other: '$countString comments',
    );
  }

  @override
  String number_of_posts(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$countString post',
      other: '$countString posts',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count subscriber',
      other: '$count subscribers',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count user',
      other: '$count users',
    );
  }

  @override
  String get unsubscribe => 'Відписатися';

  @override
  String get subscribe => 'Підписатися';

  @override
  String get messages => 'Повідомлення';

  @override
  String get banned_users => 'Забанані користувачі';

  @override
  String get delete_account_confirm =>
      'Попередження: ця дія повністю знищить всі данні вашего акаунта. Введіть свій пароль для підтвердження.';

  @override
  String get new_password => 'Новий пароль';

  @override
  String get verify_password => 'Повторіть пароль';

  @override
  String get old_password => 'Діючий пароль';

  @override
  String get show_avatars => 'Показувати аватари';

  @override
  String get search => 'Пошук';

  @override
  String get send_message => 'Послати повідомлення';

  @override
  String get top_day => 'Найкраще за день';

  @override
  String get top_week => 'Top Week';

  @override
  String get top_month => 'Top Month';

  @override
  String get top_year => 'Top Year';

  @override
  String get top_all => 'Top All Time';

  @override
  String get most_comments => 'Most Comments';

  @override
  String get new_comments => 'New Comments';

  @override
  String get active => 'Active';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

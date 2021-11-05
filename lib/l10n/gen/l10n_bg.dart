import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Bulgarian (`bg`).
class L10nBg extends L10n {
  L10nBg([String locale = 'bg']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get password => 'Парола';

  @override
  String get email_or_username => 'Имейл или Потребителско име';

  @override
  String get posts => 'Постове';

  @override
  String get comments => 'Коментари';

  @override
  String get modlog => 'Мод-журнал';

  @override
  String get community => 'Общност';

  @override
  String get url => 'URL';

  @override
  String get title => 'Заглавие';

  @override
  String get body => 'Съдържание';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'пост';

  @override
  String get save => 'запази';

  @override
  String get subscribed => 'Абониран';

  @override
  String get local => 'Местни';

  @override
  String get all => 'Всички';

  @override
  String get replies => 'Отговори';

  @override
  String get mentions => 'Споменавания';

  @override
  String get from => 'от';

  @override
  String get to => 'към';

  @override
  String get deleted_by_creator => 'изтрито от създателя';

  @override
  String get more => 'още';

  @override
  String get mark_as_read => 'маркирай прочетено';

  @override
  String get mark_as_unread => 'маркирай непрочетено';

  @override
  String get reply => 'отговори';

  @override
  String get edit => 'редактирай';

  @override
  String get delete => 'изтрий';

  @override
  String get restore => 'възстанови';

  @override
  String get yes => 'да';

  @override
  String get no => 'не';

  @override
  String get avatar => 'Профилна Снимка';

  @override
  String get banner => 'Тапет';

  @override
  String get display_name => 'Заглавие';

  @override
  String get bio => 'Био';

  @override
  String get email => 'Имейл';

  @override
  String get matrix_user => 'Matrix Потребител';

  @override
  String get sort_type => 'Тип сортиране';

  @override
  String get type => 'Тип';

  @override
  String get show_nsfw => 'Покажи NSFW съдържание';

  @override
  String get send_notifications_to_email => 'Нотификации чрез Имейл';

  @override
  String get delete_account => 'Изтрий Профила';

  @override
  String get saved => 'Запазено';

  @override
  String get communities => 'Общности';

  @override
  String get users => 'Потребители';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Език';

  @override
  String get hot => 'Популярни';

  @override
  String get new_ => 'Нови';

  @override
  String get old => 'Стари';

  @override
  String get top => 'Топ';

  @override
  String get chat => 'Чат';

  @override
  String get admin => 'администратор';

  @override
  String get by => 'от';

  @override
  String get not_a_mod_or_admin => 'Не сте модератор или администратор.';

  @override
  String get not_an_admin => 'Не сте администратор.';

  @override
  String get couldnt_find_post => 'Постът не беше намерен.';

  @override
  String get not_logged_in => 'Не сте влезли.';

  @override
  String get site_ban => 'Блокирани сте от този сайт';

  @override
  String get community_ban => 'Блокирани сте от тази общност.';

  @override
  String get downvotes_disabled => 'Изключване на негативните гласове';

  @override
  String get invalid_url => 'Навалиден URL.';

  @override
  String get locked => 'заключено';

  @override
  String get couldnt_create_comment => 'Коментарът не може да бъде създаден.';

  @override
  String get couldnt_like_comment => 'Неуспешно одобрение на коментара.';

  @override
  String get couldnt_update_comment => 'Неуспешна актуализация на коментара.';

  @override
  String get no_comment_edit_allowed =>
      'Нямате право да редактирате този коментар.';

  @override
  String get couldnt_save_comment => 'Неуспешно запазване на коментар.';

  @override
  String get couldnt_get_comments => 'Неуспешна доставка на коментарите.';

  @override
  String get report_reason_required => 'Причина за оплакването е задължителна.';

  @override
  String get report_too_long => 'Оплакването е твърде дълго.';

  @override
  String get couldnt_create_report => 'Оплакването не можа да бъде създадено.';

  @override
  String get couldnt_resolve_report => 'Оплакването не можа да бъде уредено.';

  @override
  String get invalid_post_title => 'Невалидно заглавие на пост';

  @override
  String get couldnt_create_post => 'Постът не можа да бъде създаден.';

  @override
  String get couldnt_like_post => 'Постът не можа да бъде харесан.';

  @override
  String get couldnt_find_community => 'Не можахме да намерим тази общност.';

  @override
  String get couldnt_get_posts => 'Неуспешна доставка на постовете';

  @override
  String get no_post_edit_allowed => 'Нямате право да редактирате този пост.';

  @override
  String get couldnt_save_post => 'Постът не можа да бъде запазен.';

  @override
  String get site_already_exists => 'Сайтът вече съществува.';

  @override
  String get couldnt_update_site => 'Сайтът не можа да бъде обновен.';

  @override
  String get invalid_community_name => 'Невалидно име.';

  @override
  String get community_already_exists => 'Общността вече съществува.';

  @override
  String get community_moderator_already_exists =>
      'Модератор на общността вече съществува.';

  @override
  String get community_follower_already_exists =>
      'Абонат на общността вече съществува.';

  @override
  String get not_a_moderator => 'Не сте модератор.';

  @override
  String get couldnt_update_community => 'Не можахме да обновим тази общност.';

  @override
  String get no_community_edit_allowed =>
      'Нямате право да редактирате тази общност.';

  @override
  String get system_err_login =>
      'Системна грешка. Опитайте се да се отпишете и впишете наново.';

  @override
  String get community_user_already_banned => 'Потребителят вече е баннат.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Потребителското име или имейла не съществуват.';

  @override
  String get password_incorrect => 'Грешна парола.';

  @override
  String get registration_closed => 'Регистрация затворена';

  @override
  String get invalid_password =>
      'Невалидна парола. Паролата не може да е по-дълга от 60 символа.';

  @override
  String get passwords_dont_match => 'Паролите не съвпадат.';

  @override
  String get captcha_incorrect => 'Грешна Captcha.';

  @override
  String get invalid_username => 'Грешно потребителско име.';

  @override
  String get bio_length_overflow =>
      'Потребителската Биография не може да надхвърля 300 символа.';

  @override
  String get couldnt_update_user => 'Неуспешен ъпдейт на потребителя.';

  @override
  String get couldnt_update_private_message =>
      'Неуспешен ъпдейт на лично съобщение.';

  @override
  String get couldnt_update_post => 'Неуспешен ъпдейт на поста';

  @override
  String get couldnt_create_private_message =>
      'Личното съобщение не можа да бъде създадено.';

  @override
  String get no_private_message_edit_allowed =>
      'Нямате право да редактирате лично съобщение.';

  @override
  String get post_title_too_long => 'Заглавието на поста е твърде дълго.';

  @override
  String get email_already_exists => 'Имейлът вече съществува.';

  @override
  String get user_already_exists => 'Потребителят вече съществува.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count потребител онлайн',
      other: '$count потребители онлайн',
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
      one: '$countString Коментар',
      other: '$countString Коментари',
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
      one: '$countString Пост',
      other: '$countString Постове',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count абонат',
      other: '$count абонати',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count потребител',
      other: '$count потребители',
    );
  }

  @override
  String get unsubscribe => 'Премахни абонамент';

  @override
  String get subscribe => 'Абонирай';

  @override
  String get messages => 'Съобщения';

  @override
  String get banned_users => 'Блокирани Потребители';

  @override
  String get delete_account_confirm =>
      'Внимание: това трайно ще изтрие всичките Ви данни. Въведете своята парола за потвърждение.';

  @override
  String get new_password => 'Нова Парола';

  @override
  String get verify_password => 'Потвърди парола';

  @override
  String get old_password => 'Стара парола';

  @override
  String get show_avatars => 'Покажи Профилни Снимки';

  @override
  String get search => 'Търсене';

  @override
  String get send_message => 'Изпрати Съобщение';

  @override
  String get top_day => 'Топ Ден';

  @override
  String get top_week => 'Топ Седмица';

  @override
  String get top_month => 'Топ Месец';

  @override
  String get top_year => 'Топ Година';

  @override
  String get top_all => 'Топ на Всички Времена';

  @override
  String get most_comments => 'Най-много Коментари';

  @override
  String get new_comments => 'Нови Коментари';

  @override
  String get active => 'Активни';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get settings => 'Настройки';

  @override
  String get password => 'Пароль';

  @override
  String get email_or_username => 'Электронная почта или Имя пользователя';

  @override
  String get posts => 'Посты';

  @override
  String get comments => 'Комментарии';

  @override
  String get modlog => 'Модерация';

  @override
  String get community => 'Сообщество';

  @override
  String get url => 'URL';

  @override
  String get title => 'Название';

  @override
  String get body => 'Тело';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'запостить';

  @override
  String get save => 'сохранить';

  @override
  String get subscribed => 'Подписаны';

  @override
  String get local => 'Локальные';

  @override
  String get all => 'Все';

  @override
  String get replies => 'Ответы';

  @override
  String get mentions => 'Упоминания';

  @override
  String get from => 'от';

  @override
  String get to => 'в';

  @override
  String get deleted_by_creator => 'удалено автором';

  @override
  String get more => 'больше';

  @override
  String get mark_as_read => 'пометить как прочитанное';

  @override
  String get mark_as_unread => 'пометить как непрочитанное';

  @override
  String get reply => 'ответить';

  @override
  String get edit => 'редактировать';

  @override
  String get delete => 'удалить';

  @override
  String get restore => 'восстановить';

  @override
  String get yes => 'да';

  @override
  String get no => 'нет';

  @override
  String get avatar => 'Аватар';

  @override
  String get banner => 'Баннер';

  @override
  String get display_name => 'Отображаемое имя';

  @override
  String get bio => 'БИО';

  @override
  String get email => 'Эл. почта';

  @override
  String get matrix_user => 'Пользователь Matrix';

  @override
  String get sort_type => 'Тип сортировки';

  @override
  String get type => 'Тип';

  @override
  String get show_nsfw => 'Показывать NSFW контент';

  @override
  String get send_notifications_to_email => 'Посылать уведомления на Эл. почту';

  @override
  String get delete_account => 'Удалить Аккаунт';

  @override
  String get saved => 'Сохранено';

  @override
  String get communities => 'Сообщества';

  @override
  String get users => 'Пользователи';

  @override
  String get theme => 'Тема';

  @override
  String get language => 'Язык';

  @override
  String get hot => 'Популярные';

  @override
  String get new_ => 'Новые';

  @override
  String get old => 'Старые';

  @override
  String get top => 'Лучшие';

  @override
  String get chat => 'Чат';

  @override
  String get admin => 'администратор';

  @override
  String get by => 'от';

  @override
  String get not_a_mod_or_admin => 'Не модератор и не админинстратор.';

  @override
  String get not_an_admin => 'Не администратор.';

  @override
  String get couldnt_find_post => 'Не удалось найти пост.';

  @override
  String get not_logged_in => 'Не авторизованы.';

  @override
  String get site_ban => 'Вы были заблокированы на данном сайте';

  @override
  String get community_ban => 'Вы были заблокированы в данном сообществе.';

  @override
  String get downvotes_disabled => 'Голосование не понравилось отключено';

  @override
  String get invalid_url => 'Недопустимый URL.';

  @override
  String get locked => 'заблокировано';

  @override
  String get couldnt_create_comment => 'Не удалось создать комментарий.';

  @override
  String get couldnt_like_comment => 'Не удалось лайкнуть комментарий.';

  @override
  String get couldnt_update_comment => 'Не удалось обновить комментарий.';

  @override
  String get no_comment_edit_allowed => 'Комментарий редактировать запрещено.';

  @override
  String get couldnt_save_comment => 'Не удалось сохранить комментарий.';

  @override
  String get couldnt_get_comments => 'Не удалось получить комментарии.';

  @override
  String get report_reason_required => 'Укажите причину жалобы.';

  @override
  String get report_too_long => 'Жалоба слишком длинная.';

  @override
  String get couldnt_create_report => 'Невозможно создать жалобу.';

  @override
  String get couldnt_resolve_report => 'Невозможно разрешить жалобу.';

  @override
  String get invalid_post_title => 'Недопустимый заголовок записи';

  @override
  String get couldnt_create_post => 'Не удалось создать пост.';

  @override
  String get couldnt_like_post => 'Не удалось лайкнуть пост.';

  @override
  String get couldnt_find_community => 'Сообщество не найдено.';

  @override
  String get couldnt_get_posts => 'Не удалось найти посты';

  @override
  String get no_post_edit_allowed => 'Запрещено комментировать пост.';

  @override
  String get couldnt_save_post => 'Не удалось сохранить пост.';

  @override
  String get site_already_exists => 'Сайт уже существует.';

  @override
  String get couldnt_update_site => 'Не удалось обновить сайт.';

  @override
  String get invalid_community_name => 'Неверное имя.';

  @override
  String get community_already_exists => 'Сообщество уже существует.';

  @override
  String get community_moderator_already_exists =>
      'Модератор сообщества уже существует.';

  @override
  String get community_follower_already_exists =>
      'Подписчик сообщества уже существует.';

  @override
  String get not_a_moderator => 'Не модератор.';

  @override
  String get couldnt_update_community => 'Не удалось обновить Сообщество.';

  @override
  String get no_community_edit_allowed =>
      'Редактирование сообщества запрещено.';

  @override
  String get system_err_login =>
      'Системная ошибка. Попробуйте выйти из системы и вернуться обратно.';

  @override
  String get community_user_already_banned =>
      'Пользователь сообщества уже забанен.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Указанные имя пользователя или электронную почту найти не удалось.';

  @override
  String get password_incorrect => 'Неверный пароль.';

  @override
  String get registration_closed => 'Регистрация закрыта';

  @override
  String get invalid_password =>
      'Неверный пароль. Пароль должен быть не длиннее 60 символов.';

  @override
  String get passwords_dont_match => 'Пароли не совпадают.';

  @override
  String get captcha_incorrect => 'Некорректная капча.';

  @override
  String get invalid_username => 'Неверное имя пользователя.';

  @override
  String get bio_length_overflow =>
      'БИО пользователя не может быть длиннее 300 символов.';

  @override
  String get couldnt_update_user => 'Не удалось обновить пользователя.';

  @override
  String get couldnt_update_private_message =>
      'Не удалось обновить личное сообщение.';

  @override
  String get couldnt_update_post => 'Не удалось обновить посты';

  @override
  String get couldnt_create_private_message =>
      'Не удалось создать личное сообщение.';

  @override
  String get no_private_message_edit_allowed =>
      'Не разрешено редактировать личное сообщение.';

  @override
  String get post_title_too_long => 'Название поста слишком длинное.';

  @override
  String get email_already_exists => 'Эл. почта уже существует.';

  @override
  String get user_already_exists => 'Пользователь уже существует.';

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
  String get unsubscribe => 'Отписаться';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get messages => 'Сообщения';

  @override
  String get banned_users => 'Забаненные Пользователи';

  @override
  String get delete_account_confirm =>
      'Предупреждение: это действие полностью уничтожит все данные вашего аккаунта. Введите свой пароль для подтверждения.';

  @override
  String get new_password => 'Новый Пароль';

  @override
  String get verify_password => 'Подтвердите Пароль';

  @override
  String get old_password => 'Старый Пароль';

  @override
  String get show_avatars => 'Показывать Аватары';

  @override
  String get search => 'Поиск';

  @override
  String get send_message => 'Послать Сообщение';

  @override
  String get top_day => 'Лучшие за День';

  @override
  String get top_week => 'Лучшие за Неделю';

  @override
  String get top_month => 'Лучшие за Месяц';

  @override
  String get top_year => 'Лучшие за Год';

  @override
  String get top_all => 'Лучшие за Всё Время';

  @override
  String get most_comments => 'Наиболее Комментируемые';

  @override
  String get new_comments => 'Новые Комментарии';

  @override
  String get active => 'Активные';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

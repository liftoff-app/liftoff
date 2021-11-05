import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Polish (`pl`).
class L10nPl extends L10n {
  L10nPl([String locale = 'pl']) : super(locale);

  @override
  String get settings => 'Ustawienia';

  @override
  String get password => 'Hasło';

  @override
  String get email_or_username => 'Email lub Login';

  @override
  String get posts => 'Posty';

  @override
  String get comments => 'Komentarze';

  @override
  String get modlog => 'Log moderatorski';

  @override
  String get community => 'Społeczność';

  @override
  String get url => 'URL';

  @override
  String get title => 'Tytuł';

  @override
  String get body => 'Treść';

  @override
  String get nsfw => 'NSFW (18+)';

  @override
  String get post => 'post';

  @override
  String get save => 'zapisz';

  @override
  String get subscribed => 'Subskrybowane';

  @override
  String get local => 'Lokalne';

  @override
  String get all => 'Wszystko';

  @override
  String get replies => 'Odpowiedzi';

  @override
  String get mentions => 'Wzmianki';

  @override
  String get from => 'od';

  @override
  String get to => 'do';

  @override
  String get deleted_by_creator => 'usunięte przez autora';

  @override
  String get more => 'więcej';

  @override
  String get mark_as_read => 'zaznacz jako przeczytane';

  @override
  String get mark_as_unread => 'zaznacz jako nieprzeczytane';

  @override
  String get reply => 'odpowiedz';

  @override
  String get edit => 'edytuj';

  @override
  String get delete => 'usuń';

  @override
  String get restore => 'przywróć';

  @override
  String get yes => 'tak';

  @override
  String get no => 'nie';

  @override
  String get avatar => 'Awatar';

  @override
  String get banner => 'Baner';

  @override
  String get display_name => 'Nazwa wyświetlana';

  @override
  String get bio => 'Opis';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Login na Matrixie';

  @override
  String get sort_type => 'Sortuj typ';

  @override
  String get type => 'Rodzaj';

  @override
  String get show_nsfw => 'Pokaż treści NSFW (18+)';

  @override
  String get send_notifications_to_email => 'Wysyłaj powiadomienia na Email';

  @override
  String get delete_account => 'Usuń Konto';

  @override
  String get saved => 'Zapisane';

  @override
  String get communities => 'Społeczności';

  @override
  String get users => 'Osoby zalogowane';

  @override
  String get theme => 'Motyw';

  @override
  String get language => 'Język';

  @override
  String get hot => 'Popularne';

  @override
  String get new_ => 'Nowe';

  @override
  String get old => 'Stare';

  @override
  String get top => 'Najpopularniejsze';

  @override
  String get chat => 'Dyskusja';

  @override
  String get admin => 'admin';

  @override
  String get by => 'przez';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Nie jest administratorem.';

  @override
  String get couldnt_find_post => 'Nie udało się znaleźć posta.';

  @override
  String get not_logged_in => 'Nie jesteś zalogowana/y.';

  @override
  String get site_ban => 'Zostałaś/eś zbanowana/y z tej witryny';

  @override
  String get community_ban => 'Zostałaś/eś zbanowana/y z tej społeczności.';

  @override
  String get downvotes_disabled => 'Wdółgłosy wyłączone';

  @override
  String get invalid_url => 'Nieprawidłowy URL.';

  @override
  String get locked => 'zablokowane';

  @override
  String get couldnt_create_comment => 'Nie udało się stworzyć komentarza.';

  @override
  String get couldnt_like_comment => 'Polubienie komentarza nie powiodło się.';

  @override
  String get couldnt_update_comment =>
      'Zaktualizowanie komentarza nie powiodło się.';

  @override
  String get no_comment_edit_allowed =>
      'Nie masz uprawnień do edycji komentarza.';

  @override
  String get couldnt_save_comment => 'Zapisanie komentarza nie powiodło się.';

  @override
  String get couldnt_get_comments => 'Pobranie komentarzy nie powiodło się.';

  @override
  String get report_reason_required => 'Wymagane jest uzasadnienie zgłoszenia.';

  @override
  String get report_too_long => 'Zgłoszenie jest zbyt długie.';

  @override
  String get couldnt_create_report => 'Nie udało się stworzyć zgłoszenia.';

  @override
  String get couldnt_resolve_report => 'Nie udało się rozwiązać zgłoszenia.';

  @override
  String get invalid_post_title => 'Nieprawidłowy tytuł posta';

  @override
  String get couldnt_create_post => 'Nie udało się stworzyć posta.';

  @override
  String get couldnt_like_post => 'Nie udało się polubić posta.';

  @override
  String get couldnt_find_community => 'Nie udało się znaleźć społeczności.';

  @override
  String get couldnt_get_posts => 'Nie udało się pobrać postów';

  @override
  String get no_post_edit_allowed => 'Nie masz uprawnień do edycji posta.';

  @override
  String get couldnt_save_post => 'Nie udało się zapisać posta.';

  @override
  String get site_already_exists => 'Witryna już istnieje.';

  @override
  String get couldnt_update_site => 'Nie udało się zaktualizować witryny.';

  @override
  String get invalid_community_name => 'Niepoprawna nazwa.';

  @override
  String get community_already_exists => 'Społeczność już istnieje.';

  @override
  String get community_moderator_already_exists =>
      'Moderator społeczności już istnieje.';

  @override
  String get community_follower_already_exists =>
      'Osoba obserwująca społeczność już istnieje.';

  @override
  String get not_a_moderator => 'Nie jest moderatorem.';

  @override
  String get couldnt_update_community =>
      'Nie udało się zaktualizować Społeczności.';

  @override
  String get no_community_edit_allowed =>
      'Nie masz uprawnień do edycji społeczności.';

  @override
  String get system_err_login =>
      'Błąd systemu. Spróbuj wylogować się i następnie zalogować ponownie.';

  @override
  String get community_user_already_banned =>
      'Login już zablokowany w tej społeczności.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Nie udało się znaleźć takiego loginu lub adresu email.';

  @override
  String get password_incorrect => 'Hasło niepoprawne.';

  @override
  String get registration_closed => 'Rejestracja Zamknięta';

  @override
  String get invalid_password =>
      'Nieprawidłowe hasło. Hasło musi mieć mniej niż 60 znaków.';

  @override
  String get passwords_dont_match => 'Hasła nie pasują do siebie.';

  @override
  String get captcha_incorrect => 'Captcha niepoprawna.';

  @override
  String get invalid_username => 'Nieprawidłowy login.';

  @override
  String get bio_length_overflow => 'To pole nie może przekraczać 300 znaków.';

  @override
  String get couldnt_update_user => 'Nie udało się zaktualizować.';

  @override
  String get couldnt_update_private_message =>
      'Nie udało się zaktualizować prywatnej wiadomości.';

  @override
  String get couldnt_update_post => 'Nie udało się zaktualizować postów';

  @override
  String get couldnt_create_private_message =>
      'Nie udało się stworzyć prywatnej wiadomości.';

  @override
  String get no_private_message_edit_allowed =>
      'Brak uprawnień do edycji prywatnej wiadomości.';

  @override
  String get post_title_too_long => 'Tytuł posta zbyt długi.';

  @override
  String get email_already_exists => 'Email już istnieje.';

  @override
  String get user_already_exists => 'Login już istnieje.';

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
  String get unsubscribe => 'Odsubskrybuj';

  @override
  String get subscribe => 'Subskrybuj';

  @override
  String get messages => 'Wiadomości';

  @override
  String get banned_users => 'Zbanowani Użytkownicy';

  @override
  String get delete_account_confirm =>
      'Ostrzeżenie: twoje dane zostaną bezpowrotnie usunięte. Wpisz swoje hasło aby potwierdzić.';

  @override
  String get new_password => 'Nowe Hasło';

  @override
  String get verify_password => 'Zweryfikuj Hasło';

  @override
  String get old_password => 'Stare Hasło';

  @override
  String get show_avatars => 'Pokaż Awatary';

  @override
  String get search => 'Szukaj';

  @override
  String get send_message => 'Wyślij Wiadomość';

  @override
  String get top_day => 'Najpopularniejsze dziś';

  @override
  String get top_week => 'Najpopularniejsze tydzień';

  @override
  String get top_month => 'Najpopularniejsze miesiąc';

  @override
  String get top_year => 'Najpopularniejsze rok';

  @override
  String get top_all => 'Najpopularniejsze kiedykolwiek';

  @override
  String get most_comments => 'Najwięcej komentarzy';

  @override
  String get new_comments => 'New Comments';

  @override
  String get active => 'Aktywne';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

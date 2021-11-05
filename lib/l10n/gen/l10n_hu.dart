import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Hungarian (`hu`).
class L10nHu extends L10n {
  L10nHu([String locale = 'hu']) : super(locale);

  @override
  String get settings => 'Beállítások';

  @override
  String get password => 'Jelszó';

  @override
  String get email_or_username => 'Email vagy felhasználónév';

  @override
  String get posts => 'Bejegyzések';

  @override
  String get comments => 'Hozzászólások';

  @override
  String get modlog => 'Moderációs napló';

  @override
  String get community => 'Közösség';

  @override
  String get url => 'URL';

  @override
  String get title => 'Cím';

  @override
  String get body => 'Törzs';

  @override
  String get nsfw => 'Korhatáros tartalom';

  @override
  String get post => 'Elküld';

  @override
  String get save => 'mentés';

  @override
  String get subscribed => 'Feliratkozva';

  @override
  String get local => 'Local';

  @override
  String get all => 'Mind';

  @override
  String get replies => 'Válaszok';

  @override
  String get mentions => 'Említések';

  @override
  String get from => 'küldő';

  @override
  String get to => 'címzett';

  @override
  String get deleted_by_creator => 'eltávolítva a szerző által';

  @override
  String get more => 'több';

  @override
  String get mark_as_read => 'megjelölés olvasottnak';

  @override
  String get mark_as_unread => 'megjelölés olvasatlannak';

  @override
  String get reply => 'válasz';

  @override
  String get edit => 'szerkesztés';

  @override
  String get delete => 'törlés';

  @override
  String get restore => 'visszaállítás';

  @override
  String get yes => 'igen';

  @override
  String get no => 'nem';

  @override
  String get avatar => 'Avatár';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Display name';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Matrix felhasználó';

  @override
  String get sort_type => 'Rendezési mód';

  @override
  String get type => 'Típus';

  @override
  String get show_nsfw => 'Korhatáros tartalom megjelenítése';

  @override
  String get send_notifications_to_email =>
      'Értesítések küldése emailen keresztül';

  @override
  String get delete_account => 'FIók törlése';

  @override
  String get saved => 'Mentve';

  @override
  String get communities => 'Közösségek';

  @override
  String get users => 'Felhasználók';

  @override
  String get theme => 'Téma';

  @override
  String get language => 'Nyelv';

  @override
  String get hot => 'Népszerű';

  @override
  String get new_ => 'Új';

  @override
  String get old => 'Régi';

  @override
  String get top => 'Legjobb';

  @override
  String get chat => 'Csevegés';

  @override
  String get admin => 'admin';

  @override
  String get by => 'szerző';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Nem egy admin.';

  @override
  String get couldnt_find_post => 'A bejegyzés nem található.';

  @override
  String get not_logged_in => 'Nem vagy bejelentkezve.';

  @override
  String get site_ban => 'Ki lettél tiltva az oldalról';

  @override
  String get community_ban => 'Ki lettél tiltva ebből a közösségből.';

  @override
  String get downvotes_disabled => 'Negatív szavazatok letiltva';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => 'zárolva';

  @override
  String get couldnt_create_comment =>
      'Nem lehetett létrehozni a hozzászólást.';

  @override
  String get couldnt_like_comment => 'Nem lehetett kedvelni a hozzászólást.';

  @override
  String get couldnt_update_comment =>
      'Nem lehetett frissíteni a hozzászólást.';

  @override
  String get no_comment_edit_allowed =>
      'A hozzászólás szerkesztése nem engedélyezett.';

  @override
  String get couldnt_save_comment => 'Nem lehetett menteni a hozzászólást.';

  @override
  String get couldnt_get_comments => 'Nem lehetett lekérdezni a hozzászólást.';

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
  String get couldnt_create_post => 'Nem lehetett létrehozni a bejegyzést.';

  @override
  String get couldnt_like_post => 'Nem lehetett kedvelni a bejegyzést.';

  @override
  String get couldnt_find_community => 'A közösség nem található.';

  @override
  String get couldnt_get_posts => 'Nem lehetett lekérdezni a bejegyzéseket';

  @override
  String get no_post_edit_allowed =>
      'A bejegyzés szerkesztése nem engedélyezett.';

  @override
  String get couldnt_save_post => 'Nem lehetett menteni a bejegyzést.';

  @override
  String get site_already_exists => 'Az oldal már létezik.';

  @override
  String get couldnt_update_site => 'Nem lehetett frissíteni az oldalt.';

  @override
  String get invalid_community_name => 'Érvénytelen név.';

  @override
  String get community_already_exists => 'A közösség már létezik.';

  @override
  String get community_moderator_already_exists =>
      'Már létezik a közösségi moderátor.';

  @override
  String get community_follower_already_exists =>
      'Már létezik a közösségi követő.';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community =>
      'Nem lehetett frissíteni a közösséget.';

  @override
  String get no_community_edit_allowed =>
      'A közösség szerkesztése nem engedélyezett.';

  @override
  String get system_err_login =>
      'Rendszerhiba. Próbálj meg ki- és bejelentkezni!';

  @override
  String get community_user_already_banned =>
      'A közösségi felhasználó már ki lett tiltva.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Az a felhasználónév vagy email nem található.';

  @override
  String get password_incorrect => 'Rossz jelszó.';

  @override
  String get registration_closed => 'Regisztráció lezárva';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'A jelszavak nem egyeznek.';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Érvénytelen felhasználónév.';

  @override
  String get bio_length_overflow => 'User bio cannot exceed 300 characters.';

  @override
  String get couldnt_update_user => 'Nem lehetett frissíteni a felhasználót.';

  @override
  String get couldnt_update_private_message =>
      'Nem lehetett frissíteni a privát üzenetet.';

  @override
  String get couldnt_update_post => 'Nem lehetett frissíteni a bejegyzést';

  @override
  String get couldnt_create_private_message =>
      'Nem lehetett létrehozni a privát üzenetet.';

  @override
  String get no_private_message_edit_allowed =>
      'A privát üzenet szerkesztése nem engedélyezett.';

  @override
  String get post_title_too_long => 'A bejegyzés címe túl hosszú.';

  @override
  String get email_already_exists => 'Az email már létezik.';

  @override
  String get user_already_exists => 'A felhasználó már létezik.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count online felhasználó',
      other: '$count online felhasználó',
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
      one: '$countString hozzászólás',
      other: '$countString hozzászólás',
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
      one: '$countString bejegyzés',
      other: '$countString bejegyzés',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count feliratkozó',
      other: '$count feliratkozó',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count felhasználó',
      other: '$count felhasználó',
    );
  }

  @override
  String get unsubscribe => 'Leiratkozás';

  @override
  String get subscribe => 'Feliratkozás';

  @override
  String get messages => 'Üzenetek';

  @override
  String get banned_users => 'Kitiltott felhasználók';

  @override
  String get delete_account_confirm =>
      'Figyelmeztetés: ez véglegesen törölni fogja az összes adatodat. A megerősítéshez írd be a jelszavad!';

  @override
  String get new_password => 'Új jelszó';

  @override
  String get verify_password => 'Jelszó megerősítése';

  @override
  String get old_password => 'Régi jelszó';

  @override
  String get show_avatars => 'Avatárok mutatása';

  @override
  String get search => 'Keresés';

  @override
  String get send_message => 'Üzenet küldése';

  @override
  String get top_day => 'A nap bejegyzése';

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

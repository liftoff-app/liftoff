import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Finnish (`fi`).
class L10nFi extends L10n {
  L10nFi([String locale = 'fi']) : super(locale);

  @override
  String get settings => 'Asetukset';

  @override
  String get password => 'Salasana';

  @override
  String get email_or_username => 'Sähköposti tai käyttäjätunnus';

  @override
  String get posts => 'Viestit';

  @override
  String get comments => 'Kommentit';

  @override
  String get modlog => 'Moderoinnin loki';

  @override
  String get community => 'Yhteisö';

  @override
  String get url => 'URL';

  @override
  String get title => 'Otsikko';

  @override
  String get body => 'Sisältö';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'viesti';

  @override
  String get save => 'tallenna';

  @override
  String get subscribed => 'Tilattu';

  @override
  String get local => 'Paikallinen';

  @override
  String get all => 'Kaikki';

  @override
  String get replies => 'Vastaukset';

  @override
  String get mentions => 'Maininnat';

  @override
  String get from => 'paikasta';

  @override
  String get to => 'yhteisössä';

  @override
  String get deleted_by_creator => 'poistettu';

  @override
  String get more => 'lisää';

  @override
  String get mark_as_read => 'merkitse luetuksi';

  @override
  String get mark_as_unread => 'merkitse lukemattomaksi';

  @override
  String get reply => 'vastaa';

  @override
  String get edit => 'muokkaa';

  @override
  String get delete => 'poista';

  @override
  String get restore => 'palauta';

  @override
  String get yes => 'kyllä';

  @override
  String get no => 'ei';

  @override
  String get avatar => 'avatar';

  @override
  String get banner => 'Banneri';

  @override
  String get display_name => 'Näyttönimi';

  @override
  String get bio => 'Kuvaus';

  @override
  String get email => 'Sähköposti';

  @override
  String get matrix_user => 'Matrix-käyttäjä';

  @override
  String get sort_type => 'Lajittele tyypin mukaan';

  @override
  String get type => 'Tyyppi';

  @override
  String get show_nsfw => 'Näytä NSFW-sisältö';

  @override
  String get send_notifications_to_email => 'Lähetä ilmoitukset sähköpostiin';

  @override
  String get delete_account => 'Poista tili';

  @override
  String get saved => 'Tallennettu';

  @override
  String get communities => 'Yhteisöt';

  @override
  String get users => 'Käyttäjät';

  @override
  String get theme => 'Teema';

  @override
  String get language => 'Kieli';

  @override
  String get hot => 'Kuumat';

  @override
  String get new_ => 'Uudet';

  @override
  String get old => 'Vanhat';

  @override
  String get top => 'Parhaimmat';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'ylläpitäjä';

  @override
  String get by => 'käyttäjältä';

  @override
  String get not_a_mod_or_admin => 'Et ole moderaattori tai ylläpitäjä.';

  @override
  String get not_an_admin => 'Ei ole ylläpitäjä.';

  @override
  String get couldnt_find_post => 'Viestiä ei löytynyt.';

  @override
  String get not_logged_in => 'Ei kirjautunut sisään.';

  @override
  String get site_ban => 'Sinut on asetettu porttikieltoon tällä sivustolla';

  @override
  String get community_ban =>
      'Sinulle on asetettu porttikielto tähän yhteisöön.';

  @override
  String get downvotes_disabled => 'Alaäänet otettu pois päältä';

  @override
  String get invalid_url => 'Viallinen URL.';

  @override
  String get locked => 'lukittu';

  @override
  String get couldnt_create_comment => 'Kommenttia ei pystytty luomaan.';

  @override
  String get couldnt_like_comment => 'Kommentista ei voitu tykätä.';

  @override
  String get couldnt_update_comment => 'Kommenttia ei voitu päivittää.';

  @override
  String get no_comment_edit_allowed =>
      'Sinulla ei ole oikeutta muokata kommenttia.';

  @override
  String get couldnt_save_comment => 'Kommenttia ei voitu tallentaa.';

  @override
  String get couldnt_get_comments => 'Kommentteja ei voitu hakea.';

  @override
  String get report_reason_required => 'Ilmiannolle tarvitaan selitys.';

  @override
  String get report_too_long => 'Ilmianto on turhan pitkä.';

  @override
  String get couldnt_create_report => 'Ilmiantoa ei pystytty luomaan.';

  @override
  String get couldnt_resolve_report => 'Ilmiantoa ei pystytty selvittämään.';

  @override
  String get invalid_post_title => 'Väärä viestin otsikko';

  @override
  String get couldnt_create_post => 'Ei voitu luoda viestiä.';

  @override
  String get couldnt_like_post => 'Viestistä ei voitu tykätä.';

  @override
  String get couldnt_find_community => 'Yhteisöä ei voitu löytää.';

  @override
  String get couldnt_get_posts => 'Viestejä ei saatu';

  @override
  String get no_post_edit_allowed => 'Sinulla ei ole oikeutta muokata viestiä.';

  @override
  String get couldnt_save_post => 'Viestiä ei voitu tallentaa.';

  @override
  String get site_already_exists => 'Sivusto on jo olemassa.';

  @override
  String get couldnt_update_site => 'Sivustoa ei voitu päivittää.';

  @override
  String get invalid_community_name => 'Viallinen yhteisön nimi.';

  @override
  String get community_already_exists => 'Yhteisö on jo olemassa.';

  @override
  String get community_moderator_already_exists =>
      'Yhteisön moderaattori on jo olemassa.';

  @override
  String get community_follower_already_exists =>
      'Yhteisön seuraaja on jo olemassa.';

  @override
  String get not_a_moderator => 'Ei moderaattori.';

  @override
  String get couldnt_update_community => 'Yhteisöä ei voitu päivittää.';

  @override
  String get no_community_edit_allowed =>
      'Sinulla ei ole oikeutta muokata yhteisöä.';

  @override
  String get system_err_login =>
      'Järjestelmävirhe. Yritä kirjautua ulos ja kirjautua uudestaan sisään.';

  @override
  String get community_user_already_banned =>
      'Yhteisön käyttäjä on jo porttikiellossa.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Käyttäjänimeä tai sähköpostia ei onnistuttu löytämään.';

  @override
  String get password_incorrect => 'Salasana on väärin.';

  @override
  String get registration_closed => 'Rekisteröityminen suljettu';

  @override
  String get invalid_password =>
      'Virheellinen salasana. Salasanan on oltava <= 60 merkkiä.';

  @override
  String get passwords_dont_match => 'Salasanat eivät täsmää.';

  @override
  String get captcha_incorrect => 'Captcha on väärin.';

  @override
  String get invalid_username => 'Viallinen käyttäjänimi.';

  @override
  String get bio_length_overflow =>
      'Käyttäjän kuvaus ei voi olla pidempi kuin 300 merkkiä.';

  @override
  String get couldnt_update_user => 'Käyttäjää ei voitu päivittää.';

  @override
  String get couldnt_update_private_message =>
      'Yksityisviestiä ei voitu päivittää.';

  @override
  String get couldnt_update_post => 'Viestiä ei voitu päivittää';

  @override
  String get couldnt_create_private_message =>
      'Yksityisviestiä ei voitu luoda.';

  @override
  String get no_private_message_edit_allowed =>
      'Sinulla ei ole oikeutta muokata yksityisviestiä.';

  @override
  String get post_title_too_long => 'Viestin otsikko on liian pitkä.';

  @override
  String get email_already_exists => 'Sähköposti on jo olemassa.';

  @override
  String get user_already_exists => 'Käyttäjä on jo olemassa.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count käyttäjä aktiivisena',
      other: '$count käyttäjää aktiivisena',
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
      one: '$countString kommentti',
      other: '$countString kommenttia',
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
      one: '$countString viesti',
      other: '$countString viestiä',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count tilaaja',
      other: '$count tilaajaa',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count käyttäjä',
      other: '$count käyttäjää',
    );
  }

  @override
  String get unsubscribe => 'Poista tilaus';

  @override
  String get subscribe => 'Tilaa';

  @override
  String get messages => 'Viestit';

  @override
  String get banned_users => 'Porttikieltoon asetetut käyttäjät';

  @override
  String get delete_account_confirm =>
      'Varoitus: tämä poistaa pysyvästi kaiken datasi. Anna salasanasi varmistukseksi.';

  @override
  String get new_password => 'Uusi salasana';

  @override
  String get verify_password => 'Vahvista salasana';

  @override
  String get old_password => 'Vanha salasana';

  @override
  String get show_avatars => 'Näytä avatarit';

  @override
  String get search => 'Etsi';

  @override
  String get send_message => 'Lähetä viesti';

  @override
  String get top_day => 'Päivän parhaimmat';

  @override
  String get top_week => 'Viikon parhaimmat';

  @override
  String get top_month => 'Kuukauden parhaimmat';

  @override
  String get top_year => 'Vuoden parhaimmat';

  @override
  String get top_all => 'Kaikkien aikojen parhaimmat';

  @override
  String get most_comments => 'Eniten kommentteja';

  @override
  String get new_comments => 'Uudet kommentit';

  @override
  String get active => 'Aktiivinen';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

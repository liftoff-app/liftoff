import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Basque (`eu`).
class L10nEu extends L10n {
  L10nEu([String locale = 'eu']) : super(locale);

  @override
  String get settings => 'Ezarpenak';

  @override
  String get password => 'Pasahitza';

  @override
  String get email_or_username => 'Eposta edo erabiltzaile-izena';

  @override
  String get posts => 'Bidalketak';

  @override
  String get comments => 'Iruzkinak';

  @override
  String get modlog => 'Moderazio loga';

  @override
  String get community => 'Komunitatea';

  @override
  String get url => 'URL';

  @override
  String get title => 'Izenburua';

  @override
  String get body => 'Gorputza';

  @override
  String get nsfw => 'Eduki hunkigarriak (NSFW)';

  @override
  String get post => 'bidali';

  @override
  String get save => 'gorde';

  @override
  String get subscribed => 'Harpidetuta';

  @override
  String get local => 'Lokala';

  @override
  String get all => 'Guztiak';

  @override
  String get replies => 'Erantzunak';

  @override
  String get mentions => 'Aipamenak';

  @override
  String get from => 'nork';

  @override
  String get to => 'non:';

  @override
  String get deleted_by_creator => 'sortzaileak ezabatu du';

  @override
  String get more => 'gehiago';

  @override
  String get mark_as_read => 'markatu irakurritako gisa';

  @override
  String get mark_as_unread => 'markatu ez irakurrita';

  @override
  String get reply => 'erantzun';

  @override
  String get edit => 'editatu';

  @override
  String get delete => 'ezabatu';

  @override
  String get restore => 'leheneratu';

  @override
  String get yes => 'bai';

  @override
  String get no => 'ez';

  @override
  String get avatar => 'Avatarra';

  @override
  String get banner => 'Banerra';

  @override
  String get display_name => 'Bistaratzeko izena';

  @override
  String get bio => 'Biografia';

  @override
  String get email => 'Eposta';

  @override
  String get matrix_user => 'Matrix erabiltzailea';

  @override
  String get sort_type => 'Ordena-mota';

  @override
  String get type => 'Mota';

  @override
  String get show_nsfw => 'Erakutsi eduki hunkigarriak (NSFW)';

  @override
  String get send_notifications_to_email => 'Bidali jakinarazpenak epostara';

  @override
  String get delete_account => 'Ezabatu kontua';

  @override
  String get saved => 'Gordeta';

  @override
  String get communities => 'Komunitateak';

  @override
  String get users => 'Erabiltzaileak';

  @override
  String get theme => 'Itxura';

  @override
  String get language => 'Hizkuntza';

  @override
  String get hot => 'Pil-pilean';

  @override
  String get new_ => 'Berriak';

  @override
  String get old => 'Zaharrak';

  @override
  String get top => 'Bozkatuenak';

  @override
  String get chat => 'Txata';

  @override
  String get admin => 'administratzailea';

  @override
  String get by => 'egilea:';

  @override
  String get not_a_mod_or_admin =>
      'Ez zara moderatzaile bat, ezta administratzaile bat ere.';

  @override
  String get not_an_admin => 'Ez zara administratzailea.';

  @override
  String get couldnt_find_post => 'Ezin izan da bidalketarik aurkitu.';

  @override
  String get not_logged_in => 'Ez duzu saiorik hasi.';

  @override
  String get site_ban => 'Gune honetan sartzea debekatu dizute';

  @override
  String get community_ban => 'Komunitate honetan sartzea debekatu dizute.';

  @override
  String get downvotes_disabled => 'Kontrako bozkak desgaituta';

  @override
  String get invalid_url => 'URL baliogabea.';

  @override
  String get locked => 'blokeatuta';

  @override
  String get couldnt_create_comment => 'Ezin izan da iruzkina sortu.';

  @override
  String get couldnt_like_comment => 'Ezin izan da iruzkinari datsegit eman.';

  @override
  String get couldnt_update_comment => 'Ezin izan da iruzkina eguneratu.';

  @override
  String get no_comment_edit_allowed => 'Ezin duzu iruzkina editatu.';

  @override
  String get couldnt_save_comment => 'Ezin izan da iruzkina gorde.';

  @override
  String get couldnt_get_comments => 'Ezin izan da iruzkinik lortu.';

  @override
  String get report_reason_required => 'Salaketaren arrazoia ezinbestekoa da.';

  @override
  String get report_too_long => 'Salaketa luzeegia.';

  @override
  String get couldnt_create_report => 'Ezin izan da salaketa sortu.';

  @override
  String get couldnt_resolve_report => 'Ezin izan da salaketa itxi.';

  @override
  String get invalid_post_title => 'Bidalketa izenburu baliogabea';

  @override
  String get couldnt_create_post => 'Ezin izan da bidalketa sortu.';

  @override
  String get couldnt_like_post => 'Ezin izan da bidalketari datsegit eman.';

  @override
  String get couldnt_find_community => 'Ezin izan da komunitaterik aurkitu.';

  @override
  String get couldnt_get_posts => 'Ezin izan da bidalketa lortu';

  @override
  String get no_post_edit_allowed => 'Ezin duzu bidalketa editatu.';

  @override
  String get couldnt_save_post => 'Ezin izan da bidalketa gorde.';

  @override
  String get site_already_exists => 'Gunea dagoeneko existitzen da.';

  @override
  String get couldnt_update_site => 'Ezin izan da gunea eguneratu.';

  @override
  String get invalid_community_name => 'Izen baliogabea.';

  @override
  String get community_already_exists =>
      'Komunitate hori dagoeneko existitzen da.';

  @override
  String get community_moderator_already_exists =>
      'Komunitateko moderatzaile hori dagoeneko existitzen da.';

  @override
  String get community_follower_already_exists =>
      'Komunitateko jarraitzaile hori dagoeneko existitzen da.';

  @override
  String get not_a_moderator => 'Ez zara moderatzailea.';

  @override
  String get couldnt_update_community => 'Ezin izan da komunitatea eguneratu.';

  @override
  String get no_community_edit_allowed => 'Ezin duzu komunitatea editatu.';

  @override
  String get system_err_login =>
      'Sistemaren errorea. Saiatu saioa ixten eta berriz hasten.';

  @override
  String get community_user_already_banned =>
      'Komunitateko erabiltzaile hau dagoeneko debekatuta dago.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Ezin izan da aurkitu erabiltzaile-izen edo eposta hori.';

  @override
  String get password_incorrect => 'Pasahitz okerra.';

  @override
  String get registration_closed => 'Izen-ematea itxira';

  @override
  String get invalid_password =>
      'Pasahitz baliogabea. Pasahitzak <= 60 karaktere izan behar ditu.';

  @override
  String get passwords_dont_match => 'Pasahitzak ez dira berdinak.';

  @override
  String get captcha_incorrect => 'Okerreko captcha.';

  @override
  String get invalid_username => 'Erabiltzaile-izen baliogabea.';

  @override
  String get bio_length_overflow =>
      'Erabiltzailearen biografiak ezin ditu 300 hizki baino gehiago izan.';

  @override
  String get couldnt_update_user => 'Ezin izan da erabiltzailea eguneratu.';

  @override
  String get couldnt_update_private_message =>
      'Ezin izan da mezu pribatu hori eguneratu.';

  @override
  String get couldnt_update_post => 'Ezin izan da bidalketa eguneratu';

  @override
  String get couldnt_create_private_message =>
      'Ezin izan da mezu pribatu hori sortu.';

  @override
  String get no_private_message_edit_allowed =>
      'Ezin duzu mezu pribaturik editatu.';

  @override
  String get post_title_too_long => 'Bidalketaren izenburua luzeegia da.';

  @override
  String get email_already_exists => 'Eposta hori dagoeneko existitzen da.';

  @override
  String get user_already_exists =>
      'Erabiltzaile hori dagoeneko existitzen da.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: 'Erabiltzaile $count konektatuta',
      other: '$count erabiltzaile konektatuta',
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
      one: 'Iruzkin $countString',
      other: '$countString iruzkin',
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
      one: 'Bidalketa $countString',
      other: '$countString bidalketa',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: 'Harpidetu $count',
      other: '$count harpidetu',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: 'Erabiltzaile $count',
      other: '$count erabiltzaile',
    );
  }

  @override
  String get unsubscribe => 'Ezabatu harpidetza';

  @override
  String get subscribe => 'Harpidetu';

  @override
  String get messages => 'Mezuak';

  @override
  String get banned_users => 'Debekatutako erabiltzaileak';

  @override
  String get delete_account_confirm =>
      'Abisua: honek zure datu guztiak betirako ezabatu ditu. Sartu zure pasahitza baieztatzeko.';

  @override
  String get new_password => 'Pasahitz berria';

  @override
  String get verify_password => 'Balioztatu pasahitza';

  @override
  String get old_password => 'Aurreko pasahitza';

  @override
  String get show_avatars => 'Erakutsi avatarrak';

  @override
  String get search => 'Bilatu';

  @override
  String get send_message => 'Bidali mezua';

  @override
  String get top_day => 'Gaur pil-pilean';

  @override
  String get top_week => 'Asteko Onena';

  @override
  String get top_month => 'Hilabeteko Onena';

  @override
  String get top_year => 'Urteko Onena';

  @override
  String get top_all => 'Onena';

  @override
  String get most_comments => 'Iruzkin gehienak';

  @override
  String get new_comments => 'Iruzkin berriak';

  @override
  String get active => 'Aktibo';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

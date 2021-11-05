import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Catalan Valencian (`ca`).
class L10nCa extends L10n {
  L10nCa([String locale = 'ca']) : super(locale);

  @override
  String get settings => 'Configuració';

  @override
  String get password => 'Contrasenya';

  @override
  String get email_or_username => 'Adreça electrònica o usuari';

  @override
  String get posts => 'Publicacions';

  @override
  String get comments => 'Comentaris';

  @override
  String get modlog => 'Historial de moderació';

  @override
  String get community => 'Comunitat';

  @override
  String get url => 'URL';

  @override
  String get title => 'Títol';

  @override
  String get body => 'Cos';

  @override
  String get nsfw => 'Per a adults';

  @override
  String get post => 'publicar';

  @override
  String get save => 'desa';

  @override
  String get subscribed => 'Subscrit';

  @override
  String get local => 'Local';

  @override
  String get all => 'Tot';

  @override
  String get replies => 'Respostes';

  @override
  String get mentions => 'Mencions';

  @override
  String get from => 'des de';

  @override
  String get to => 'a';

  @override
  String get deleted_by_creator => 'suprimit pel creador';

  @override
  String get more => 'més';

  @override
  String get mark_as_read => 'marca com a llegit';

  @override
  String get mark_as_unread => 'marca com a no llegit';

  @override
  String get reply => 'respon';

  @override
  String get edit => 'edita';

  @override
  String get delete => 'suprimeix';

  @override
  String get restore => 'restaura';

  @override
  String get yes => 'sí';

  @override
  String get no => 'no';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Capçalera';

  @override
  String get display_name => 'Nom a mostrar';

  @override
  String get bio => 'Biografia';

  @override
  String get email => 'Correu electrònic';

  @override
  String get matrix_user => 'Usuari del Matrix';

  @override
  String get sort_type => 'Tipus d’ordenació';

  @override
  String get type => 'Tipus';

  @override
  String get show_nsfw => 'Mostra el contingut per a adults';

  @override
  String get send_notifications_to_email => 'Envia notificacions al correu';

  @override
  String get delete_account => 'Suprimeix el compte';

  @override
  String get saved => 'Desat';

  @override
  String get communities => 'Comunitats';

  @override
  String get users => 'Usuaris';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Llengua';

  @override
  String get hot => 'Popular';

  @override
  String get new_ => 'Nou';

  @override
  String get old => 'Antic';

  @override
  String get top => 'Millor';

  @override
  String get chat => 'Xat';

  @override
  String get admin => 'administrador';

  @override
  String get by => 'per';

  @override
  String get not_a_mod_or_admin => 'No ets un moderador ni un administrador.';

  @override
  String get not_an_admin => 'No és un administrador.';

  @override
  String get couldnt_find_post => 'No s’ha pogut trobar l’apunt.';

  @override
  String get not_logged_in => 'No heu iniciat una sessió.';

  @override
  String get site_ban => 'Us han expulsat del lloc';

  @override
  String get community_ban => 'Us han expulsat d’aquesta comunitat.';

  @override
  String get downvotes_disabled => 'Vots negatius inhabilitats';

  @override
  String get invalid_url => 'URL invàlida.';

  @override
  String get locked => 'blocat';

  @override
  String get couldnt_create_comment => 'No s’ha pogut crear el comentari.';

  @override
  String get couldnt_like_comment =>
      'No s’ha pogut donar «m’agrada» al comentari.';

  @override
  String get couldnt_update_comment =>
      'No s’ha pogut actualitzar el comentari.';

  @override
  String get no_comment_edit_allowed =>
      'No teniu permisos per a editar el comentari.';

  @override
  String get couldnt_save_comment => 'No s’ha pogut desar el comentari.';

  @override
  String get couldnt_get_comments => 'No s’han pogut recuperar els comentaris.';

  @override
  String get report_reason_required => 'Motiu de l\'informe necessari.';

  @override
  String get report_too_long => 'Informe massa llarg.';

  @override
  String get couldnt_create_report => 'No s\'ha pogut crear l\'informe.';

  @override
  String get couldnt_resolve_report => 'No s\'ha pogut resoldre l\'informe.';

  @override
  String get invalid_post_title => 'Títol de la publicació invàlid';

  @override
  String get couldnt_create_post => 'No s’ha pogut crear l’apunt.';

  @override
  String get couldnt_like_post => 'No s’ha pogut donar «m’agrada» a l’apunt.';

  @override
  String get couldnt_find_community => 'No s’ha pogut trobar la comunitat.';

  @override
  String get couldnt_get_posts => 'No s’han pogut recuperar els apunts';

  @override
  String get no_post_edit_allowed => 'No teniu permisos per a editar l’apunt.';

  @override
  String get couldnt_save_post => 'No s’ha pogut desar l’apunt.';

  @override
  String get site_already_exists => 'El lloc ja existeix.';

  @override
  String get couldnt_update_site => 'No s’ha pogut actualitzar el lloc.';

  @override
  String get invalid_community_name => 'El nom no és vàlid.';

  @override
  String get community_already_exists => 'Aquesta comunitat ja existeix.';

  @override
  String get community_moderator_already_exists =>
      'Aquest moderador de la comunitat ja existeix.';

  @override
  String get community_follower_already_exists =>
      'Aquest seguidor de la comunitat ja existeix.';

  @override
  String get not_a_moderator => 'No ets un moderador.';

  @override
  String get couldnt_update_community =>
      'No s’ha pogut actualitzar la comunitat.';

  @override
  String get no_community_edit_allowed =>
      'No teniu permisos per a editar la comunitat.';

  @override
  String get system_err_login =>
      'Error del sistema. Intenti tancar sessió i ingressar de nou.';

  @override
  String get community_user_already_banned =>
      'Aquest usuari de la comunitat ja fou expulsat.';

  @override
  String get couldnt_find_that_username_or_email =>
      'No s’ha pogut trobar aquest nom de usuari o adreça electrònica.';

  @override
  String get password_incorrect => 'Contrasenya incorrecta.';

  @override
  String get registration_closed => 'S’han tancat els registres';

  @override
  String get invalid_password =>
      'Contrasenya no vàlida. La contrasenya ha de tenir <= 60 caràcters.';

  @override
  String get passwords_dont_match => 'Les contrasenyes no coincideixen.';

  @override
  String get captcha_incorrect => 'Captcha incorrecte.';

  @override
  String get invalid_username => 'El nom d’usuari no és vàlid.';

  @override
  String get bio_length_overflow =>
      'La biografia d\'usuari no pot excedir els 300 caràcters.';

  @override
  String get couldnt_update_user => 'No s’ha pogut actualitzar l’usuari.';

  @override
  String get couldnt_update_private_message =>
      'No s’ha pogut actualitzar el missatge privat.';

  @override
  String get couldnt_update_post => 'No s’ha pogut actualitzar l’apunt';

  @override
  String get couldnt_create_private_message =>
      'No s’ha pogut crear el missatge privat.';

  @override
  String get no_private_message_edit_allowed =>
      'No teniu permisos per a editar el missatge privat.';

  @override
  String get post_title_too_long => 'El títol de l’apunt és massa llarg.';

  @override
  String get email_already_exists => 'L’adreça ja és en ús.';

  @override
  String get user_already_exists => 'L’usuari ja existeix.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count usuari en línia',
      other: '$count usuaris en línia',
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
      one: '$countString comentari',
      other: '$countString comentaris',
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
      one: '$countString Publicació',
      other: '$countString Publicacions',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count subscriptor',
      other: '$count subscriptors',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count usuari',
      other: '$count usuaris',
    );
  }

  @override
  String get unsubscribe => 'Dóna’t de baixa';

  @override
  String get subscribe => 'Subscriu-t’hi';

  @override
  String get messages => 'Missatges';

  @override
  String get banned_users => 'Usuaris expulsats';

  @override
  String get delete_account_confirm =>
      'Atenció: aquesta acció suprimirà permanentment la vostra informació. Introduïu la vostra contrasenya per a confirmar.';

  @override
  String get new_password => 'Contrasenya nova';

  @override
  String get verify_password => 'Verifica la contrasenya';

  @override
  String get old_password => 'Contrasenya antiga';

  @override
  String get show_avatars => 'Mostra els avatars';

  @override
  String get search => 'Cerca';

  @override
  String get send_message => 'Envia el missatge';

  @override
  String get top_day => 'El millor del dia';

  @override
  String get top_week => 'El millor de la setmana';

  @override
  String get top_month => 'El millor del mes';

  @override
  String get top_year => 'El millor de l\'any';

  @override
  String get top_all => 'El millor de tots els temps';

  @override
  String get most_comments => 'Més comentaris';

  @override
  String get new_comments => 'Comentaris nous';

  @override
  String get active => 'Actiu';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

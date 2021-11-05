import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Galician (`gl`).
class L10nGl extends L10n {
  L10nGl([String locale = 'gl']) : super(locale);

  @override
  String get settings => 'Axustes';

  @override
  String get password => 'Contrasinal';

  @override
  String get email_or_username => 'Email ou Nome de usuaria';

  @override
  String get posts => 'Publicacións';

  @override
  String get comments => 'Comentarios';

  @override
  String get modlog => 'Rexistro da moderación';

  @override
  String get community => 'Comunidade';

  @override
  String get url => 'URL';

  @override
  String get title => 'Título';

  @override
  String get body => 'Body';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'publicar';

  @override
  String get save => 'gardar';

  @override
  String get subscribed => 'Subscrita';

  @override
  String get local => 'Local';

  @override
  String get all => 'Todo';

  @override
  String get replies => 'Respostas';

  @override
  String get mentions => 'Mencións';

  @override
  String get from => 'desde';

  @override
  String get to => 'a';

  @override
  String get deleted_by_creator => 'eliminado pola creadora';

  @override
  String get more => 'máis';

  @override
  String get mark_as_read => 'marcar como lido';

  @override
  String get mark_as_unread => 'marcar como non lido';

  @override
  String get reply => 'reponder';

  @override
  String get edit => 'editar';

  @override
  String get delete => 'eliminar';

  @override
  String get restore => 'restablecer';

  @override
  String get yes => 'si';

  @override
  String get no => 'non';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Cabeceira';

  @override
  String get display_name => 'Nome público';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Usuaria Matrix';

  @override
  String get sort_type => 'Tipo de orde';

  @override
  String get type => 'Tipo';

  @override
  String get show_nsfw => 'Mostrar contido NSFW';

  @override
  String get send_notifications_to_email => 'Enviar notificacións ao email';

  @override
  String get delete_account => 'Eliminar Conta';

  @override
  String get saved => 'Gardado';

  @override
  String get communities => 'Comunidades';

  @override
  String get users => 'Usuarias';

  @override
  String get theme => 'Decorado';

  @override
  String get language => 'Idioma';

  @override
  String get hot => 'En voga';

  @override
  String get new_ => 'Novo';

  @override
  String get old => 'Antigo';

  @override
  String get top => 'Top';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'admin';

  @override
  String get by => 'por';

  @override
  String get not_a_mod_or_admin => 'Non é moderadora ou admin.';

  @override
  String get not_an_admin => 'Non é admin.';

  @override
  String get couldnt_find_post => 'Non se atopou a publicación.';

  @override
  String get not_logged_in => 'Non conectada.';

  @override
  String get site_ban => 'Retirouseche o veto nesta comunidade';

  @override
  String get community_ban => 'Foches vetada nesta comunidade.';

  @override
  String get downvotes_disabled => 'Votos negativos desactivados';

  @override
  String get invalid_url => 'URL non válido.';

  @override
  String get locked => 'bloqueado';

  @override
  String get couldnt_create_comment => 'Non se creou o comentario.';

  @override
  String get couldnt_like_comment => 'Non se puido gustar o comentario.';

  @override
  String get couldnt_update_comment => 'Non se actualizou o comentario.';

  @override
  String get no_comment_edit_allowed =>
      'Non está permitido editar o comentario.';

  @override
  String get couldnt_save_comment => 'Non se gardou o comentario.';

  @override
  String get couldnt_get_comments => 'Non se obtiveron comentarios.';

  @override
  String get report_reason_required => 'Requírese unha razón para a denuncia.';

  @override
  String get report_too_long => 'Denuncia demasiado longa.';

  @override
  String get couldnt_create_report => 'Non se puido crear a denuncia.';

  @override
  String get couldnt_resolve_report => 'Non se puido resolver a denuncia.';

  @override
  String get invalid_post_title => 'Título da publicación non válido';

  @override
  String get couldnt_create_post => 'Non se puido crear a publicación.';

  @override
  String get couldnt_like_post => 'Non se puido gustar da publicación.';

  @override
  String get couldnt_find_community => 'Non se atopou a comunidade.';

  @override
  String get couldnt_get_posts => 'Non se obtiveron publicacións';

  @override
  String get no_post_edit_allowed => 'Non está permitido editar a publicación.';

  @override
  String get couldnt_save_post => 'Non se gardou a publicación.';

  @override
  String get site_already_exists => 'Xa existe o sitio.';

  @override
  String get couldnt_update_site => 'Non se actualizou o sitio.';

  @override
  String get invalid_community_name => 'Nome non válido.';

  @override
  String get community_already_exists => 'A comunidade xa existe.';

  @override
  String get community_moderator_already_exists =>
      'Xa hai moderadora para a Comunidade.';

  @override
  String get community_follower_already_exists =>
      'Xa existe a seguidora da comunidade.';

  @override
  String get not_a_moderator => 'Non é moderadora.';

  @override
  String get couldnt_update_community => 'Non se actualizou a Comunidade.';

  @override
  String get no_community_edit_allowed =>
      'Non está permitido editar a comunidade.';

  @override
  String get system_err_login =>
      'Erro no sistema. Intenta desconectar e conectar de volta.';

  @override
  String get community_user_already_banned =>
      'A usuaria da comunidade xa foi vetada.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Non se atopa ese nome de usuaria ou email.';

  @override
  String get password_incorrect => 'Contrasinal incorrecto.';

  @override
  String get registration_closed => 'Rexistro pechado';

  @override
  String get invalid_password =>
      'Contrasinal non válido. O contrasinal ten que ser inferior a 60 caracteres.';

  @override
  String get passwords_dont_match => 'Os contrasinais non coinciden.';

  @override
  String get captcha_incorrect => 'Captcha incorrecto.';

  @override
  String get invalid_username => 'Nome de usuaria non válido.';

  @override
  String get bio_length_overflow =>
      'A bio da usuaria non pode superar os 300 caracteres.';

  @override
  String get couldnt_update_user => 'Non se actualizou a usuaria.';

  @override
  String get couldnt_update_private_message =>
      'Non se actualizou a mensaxe privada.';

  @override
  String get couldnt_update_post => 'Non se actualizou a publicación';

  @override
  String get couldnt_create_private_message =>
      'Non se creou a mensaxe privada.';

  @override
  String get no_private_message_edit_allowed =>
      'Non está permitido editar a mensaxe privada.';

  @override
  String get post_title_too_long => 'O título é demasiado longo.';

  @override
  String get email_already_exists => 'Xa existe o email.';

  @override
  String get user_already_exists => 'Xa existe a usuaria.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count usuaria conectada',
      other: '$count usuarias conectadas',
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
      one: '$countString Comentario',
      other: '$countString Comentarios',
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
      one: '$countString Publicación',
      other: '$countString Publicacións',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count subscritora',
      other: '$count subscritoras',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count usuaria',
      other: '$count usuarias',
    );
  }

  @override
  String get unsubscribe => 'Dar de baixa';

  @override
  String get subscribe => 'Subscribir';

  @override
  String get messages => 'Mensaxes';

  @override
  String get banned_users => 'Usuarias vetadas';

  @override
  String get delete_account_confirm =>
      'Aviso: isto eliminará permanentemente tódolos teus datos. Escribe o contrasinal para confirmar.';

  @override
  String get new_password => 'Novo contrasinal';

  @override
  String get verify_password => 'Verifica o contrasinal';

  @override
  String get old_password => 'Contrasinal anterior';

  @override
  String get show_avatars => 'Mostrar avatares';

  @override
  String get search => 'Buscar';

  @override
  String get send_message => 'Enviar mensaxe';

  @override
  String get top_day => 'Top hoxe';

  @override
  String get top_week => 'Top semanal';

  @override
  String get top_month => 'Top mensual';

  @override
  String get top_year => 'Top anual';

  @override
  String get top_all => 'Top de sempre';

  @override
  String get most_comments => 'Máis comentado';

  @override
  String get new_comments => 'Novos comentarios';

  @override
  String get active => 'Activo';

  @override
  String get bot_account => 'Conta Bot';

  @override
  String get show_bot_accounts => 'Mostrar contas tipo bot';

  @override
  String get show_read_posts => 'Mostrar publicacións lidas';
}

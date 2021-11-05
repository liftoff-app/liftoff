import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Configuración';

  @override
  String get password => 'Contraseña';

  @override
  String get email_or_username => 'Correo o nombre de usuario';

  @override
  String get posts => 'Publicaciones';

  @override
  String get comments => 'Comentarios';

  @override
  String get modlog => 'Historial de moderación';

  @override
  String get community => 'Comunidad';

  @override
  String get url => 'URL';

  @override
  String get title => 'Título';

  @override
  String get body => 'Descripción';

  @override
  String get nsfw => 'Para adultos';

  @override
  String get post => 'publicar';

  @override
  String get save => 'guardar';

  @override
  String get subscribed => 'Suscrito';

  @override
  String get local => 'Local';

  @override
  String get all => 'Todo';

  @override
  String get replies => 'Respuestas';

  @override
  String get mentions => 'Menciones';

  @override
  String get from => 'desde';

  @override
  String get to => 'a';

  @override
  String get deleted_by_creator => 'eliminado por creador';

  @override
  String get more => 'más';

  @override
  String get mark_as_read => 'marcar como leído';

  @override
  String get mark_as_unread => 'marcar como no leído';

  @override
  String get reply => 'responder';

  @override
  String get edit => 'editar';

  @override
  String get delete => 'eliminar';

  @override
  String get restore => 'restaurar';

  @override
  String get yes => 'sí';

  @override
  String get no => 'no';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Nombre para visualizar';

  @override
  String get bio => 'Biografía';

  @override
  String get email => 'Correo electrónico';

  @override
  String get matrix_user => 'Usuario Matrix';

  @override
  String get sort_type => 'Tipo de orden';

  @override
  String get type => 'Tipo';

  @override
  String get show_nsfw => 'Mostrar contenido para adultos';

  @override
  String get send_notifications_to_email => 'Enviar notificaciones al correo';

  @override
  String get delete_account => 'Eliminar cuenta';

  @override
  String get saved => 'Guardado';

  @override
  String get communities => 'Comunidades';

  @override
  String get users => 'Usuarios';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Idioma';

  @override
  String get hot => 'Popular';

  @override
  String get new_ => 'Nuevo';

  @override
  String get old => 'Antiguo';

  @override
  String get top => 'Lo mejor';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'administrador';

  @override
  String get by => 'por';

  @override
  String get not_a_mod_or_admin => 'No eres un moderador ni un administrador.';

  @override
  String get not_an_admin => 'No es un administrador.';

  @override
  String get couldnt_find_post => 'No se pudo encontrar la publicación.';

  @override
  String get not_logged_in => 'No has iniciado sesión.';

  @override
  String get site_ban => 'Has sido expulsado del sitio';

  @override
  String get community_ban => 'Has sido expulsado de esta comunidad.';

  @override
  String get downvotes_disabled => 'Votos negativos deshabilitados';

  @override
  String get invalid_url => 'URL no válido.';

  @override
  String get locked => 'bloqueado';

  @override
  String get couldnt_create_comment => 'No se pudo crear el comentario.';

  @override
  String get couldnt_like_comment => 'No se pudo dar me gusta al comentario.';

  @override
  String get couldnt_update_comment => 'No se pudo actualizar el comentario.';

  @override
  String get no_comment_edit_allowed =>
      'No tiene permisos para editar el comentario.';

  @override
  String get couldnt_save_comment => 'No se pudo guardar el comentario.';

  @override
  String get couldnt_get_comments => 'No se pudo obtener los comentarios.';

  @override
  String get report_reason_required => 'Motivo del informe necesario.';

  @override
  String get report_too_long => 'Informe demasiado largo.';

  @override
  String get couldnt_create_report => 'No se pudo generar el informe.';

  @override
  String get couldnt_resolve_report => 'No se pudo resolver el informe.';

  @override
  String get invalid_post_title => 'Título de la publicación no válido';

  @override
  String get couldnt_create_post => 'No se pudo crear la publicación.';

  @override
  String get couldnt_like_post => 'No se pudo dar me gusta a la publicación.';

  @override
  String get couldnt_find_community => 'No se pudo encontrar la comunidad.';

  @override
  String get couldnt_get_posts => 'No se pudo obtener las publicaciones';

  @override
  String get no_post_edit_allowed =>
      'No tiene permisos para editar la publicación.';

  @override
  String get couldnt_save_post => 'No se pudo guardar la publicación.';

  @override
  String get site_already_exists => 'El sitio ya existe.';

  @override
  String get couldnt_update_site => 'No se pudo actualizar el sitio.';

  @override
  String get invalid_community_name => 'Nombre no válido.';

  @override
  String get community_already_exists => 'Esta comunidad ya existe.';

  @override
  String get community_moderator_already_exists =>
      'Este moderador de la comunidad ya existe.';

  @override
  String get community_follower_already_exists =>
      'Este seguidor de la comunidad ya existe.';

  @override
  String get not_a_moderator => 'No eres moderador.';

  @override
  String get couldnt_update_community => 'No se pudo actualizar la comunidad.';

  @override
  String get no_community_edit_allowed =>
      'No tiene permisos para editar la comunidad.';

  @override
  String get system_err_login =>
      'Error del sistema. Intente cerrar sesión e ingresar de nuevo.';

  @override
  String get community_user_already_banned =>
      'Este usuario de la comunidad ya fue expulsado.';

  @override
  String get couldnt_find_that_username_or_email =>
      'No se pudo encontrar ese nombre de usuario o correo electrónico.';

  @override
  String get password_incorrect => 'Contraseña incorrecta.';

  @override
  String get registration_closed => 'Registro cerrado';

  @override
  String get invalid_password =>
      'Contraseña no válida. La contraseña debe ser <= 60 carácteres.';

  @override
  String get passwords_dont_match => 'Las contraseñas no coinciden.';

  @override
  String get captcha_incorrect => 'Captcha incorrecto.';

  @override
  String get invalid_username => 'Nombre de usuario inválido.';

  @override
  String get bio_length_overflow =>
      'La biografía del usuario no puede exceder los 300 caracteres.';

  @override
  String get couldnt_update_user => 'No se pudo actualizar el usuario.';

  @override
  String get couldnt_update_private_message =>
      'No se pudo actualizar el mensaje privado.';

  @override
  String get couldnt_update_post => 'No se pudo actualizar la publicación';

  @override
  String get couldnt_create_private_message =>
      'No se pudo crear el mensaje privado.';

  @override
  String get no_private_message_edit_allowed =>
      'Sin permisos para editar el mensaje privado.';

  @override
  String get post_title_too_long => 'El título de la publicación es muy largo.';

  @override
  String get email_already_exists => 'El correo ya está en uso.';

  @override
  String get user_already_exists => 'El usuario ya existe.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count usuario en línea',
      other: '$count usuarios en línea',
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
      other: '$countString Publicaciones',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count suscriptor',
      other: '$count suscriptores',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count usuario',
      other: '$count usuarios',
    );
  }

  @override
  String get unsubscribe => 'Desuscribirse';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get messages => 'Mensajes';

  @override
  String get banned_users => 'Usuarios expulsados';

  @override
  String get delete_account_confirm =>
      'Advertencia: esta acción eliminará permanentemente toda su información. Introduzca su contraseña para confirmar.';

  @override
  String get new_password => 'Nueva contraseña';

  @override
  String get verify_password => 'Verificar contraseña';

  @override
  String get old_password => 'Antigua contraseña';

  @override
  String get show_avatars => 'Mostrar avatares';

  @override
  String get search => 'Buscar';

  @override
  String get send_message => 'Enviar mensaje';

  @override
  String get top_day => 'Lo mejor del día';

  @override
  String get top_week => 'Lo mejor de la semana';

  @override
  String get top_month => 'Lo mejor del mes';

  @override
  String get top_year => 'Lo mejor del año';

  @override
  String get top_all => 'Lo mejor de todos los tiempos';

  @override
  String get most_comments => 'Más comentados';

  @override
  String get new_comments => 'Nuevos Comentarios';

  @override
  String get active => 'Activo';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

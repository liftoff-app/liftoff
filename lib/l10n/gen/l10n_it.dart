import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Italian (`it`).
class L10nIt extends L10n {
  L10nIt([String locale = 'it']) : super(locale);

  @override
  String get settings => 'Impostazioni';

  @override
  String get password => 'Password';

  @override
  String get email_or_username => 'Email o Nome Utente';

  @override
  String get posts => 'Pubblicazioni';

  @override
  String get comments => 'Commenti';

  @override
  String get modlog => 'Registro di moderazione';

  @override
  String get community => 'Comunità';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titolo';

  @override
  String get body => 'Contenuto';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'pubblica';

  @override
  String get save => 'salva';

  @override
  String get subscribed => 'Iscritto';

  @override
  String get local => 'Locale';

  @override
  String get all => 'Tutti';

  @override
  String get replies => 'Risposte';

  @override
  String get mentions => 'Menzioni';

  @override
  String get from => 'da';

  @override
  String get to => 'su';

  @override
  String get deleted_by_creator => 'eliminato dal creatore';

  @override
  String get more => 'altro';

  @override
  String get mark_as_read => 'segna come letto';

  @override
  String get mark_as_unread => 'segna come non letto';

  @override
  String get reply => 'rispondi';

  @override
  String get edit => 'modifica';

  @override
  String get delete => 'cancella';

  @override
  String get restore => 'ripristina';

  @override
  String get yes => 'sì';

  @override
  String get no => 'no';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Nome visualizzato';

  @override
  String get bio => 'Descrizione';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Utente Matrix';

  @override
  String get sort_type => 'Ordina per';

  @override
  String get type => 'Tipo';

  @override
  String get show_nsfw => 'Mostra contenuto NSFW';

  @override
  String get send_notifications_to_email => 'Invia notifiche via email';

  @override
  String get delete_account => 'Cancella Account';

  @override
  String get saved => 'Salvati';

  @override
  String get communities => 'Comunità';

  @override
  String get users => 'Utenti';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Lingua';

  @override
  String get hot => 'Popolari';

  @override
  String get new_ => 'Nuovi';

  @override
  String get old => 'Vecchi';

  @override
  String get top => 'Migliori';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'amministratore';

  @override
  String get by => 'di';

  @override
  String get not_a_mod_or_admin => 'Non moderatore o amministratore.';

  @override
  String get not_an_admin => 'Non un amministratore.';

  @override
  String get couldnt_find_post => 'Impossibile trovare la pubblicazione.';

  @override
  String get not_logged_in => 'Non hai effettuato l\'accesso.';

  @override
  String get site_ban => 'Sei stato escluso dal sito';

  @override
  String get community_ban => 'Sei stato escluso da questa comunità.';

  @override
  String get downvotes_disabled => 'Voti negativi disabilitati';

  @override
  String get invalid_url => 'URL non valido.';

  @override
  String get locked => 'bloccato';

  @override
  String get couldnt_create_comment => 'Impossibile creare il commento.';

  @override
  String get couldnt_like_comment => 'Impossibile apprezzare il commento.';

  @override
  String get couldnt_update_comment => 'Impossibile aggiornare il commento.';

  @override
  String get no_comment_edit_allowed =>
      'Non sei autorizzato a modificare il commento.';

  @override
  String get couldnt_save_comment => 'Impossibile salvare il commento.';

  @override
  String get couldnt_get_comments => 'Impossibile ottenere i commenti.';

  @override
  String get report_reason_required =>
      'Motivazione della segnalazione obbligatoria.';

  @override
  String get report_too_long => 'Segnalazione troppo lunga.';

  @override
  String get couldnt_create_report => 'Impossibile creare segnalazione.';

  @override
  String get couldnt_resolve_report => 'Impossibile risolvere segnalazione.';

  @override
  String get invalid_post_title => 'Titolo della pubblicazione non valido';

  @override
  String get couldnt_create_post => 'Impossibile creare la pubblicazione.';

  @override
  String get couldnt_like_post => 'Impossibile apprezzare la pubblicazione.';

  @override
  String get couldnt_find_community => 'Impossibile trovare la comunità.';

  @override
  String get couldnt_get_posts => 'Impossibile recuperare le pubblicazioni';

  @override
  String get no_post_edit_allowed =>
      'Non sei autorizzato a modificare la pubblicazione.';

  @override
  String get couldnt_save_post => 'Impossibile salvare la pubblicazione.';

  @override
  String get site_already_exists => 'Il sito esiste già.';

  @override
  String get couldnt_update_site => 'Impossibile aggiornare il sito.';

  @override
  String get invalid_community_name => 'Nome non valido.';

  @override
  String get community_already_exists => 'La comunità esiste già.';

  @override
  String get community_moderator_already_exists =>
      'Questo utente è già moderatore della comunità.';

  @override
  String get community_follower_already_exists =>
      'Utente già membro della comunità.';

  @override
  String get not_a_moderator => 'Non moderatore.';

  @override
  String get couldnt_update_community => 'Impossibile aggiornare la comunità.';

  @override
  String get no_community_edit_allowed =>
      'Non sei autorizzato a modificare la comunità.';

  @override
  String get system_err_login =>
      'Si è verificato un errore. Prova ad effettuare nuovamente l\'accesso.';

  @override
  String get community_user_already_banned =>
      'L\'utente della comunità è già stato espulso.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Il nome utente o l\'email non sono stati trovati.';

  @override
  String get password_incorrect => 'Password non corretta.';

  @override
  String get registration_closed => 'Registrazione Chiusa';

  @override
  String get invalid_password =>
      'Password non valida. La password deve contenere <= 60 caratteri.';

  @override
  String get passwords_dont_match => 'Le password non corrispondono.';

  @override
  String get captcha_incorrect => 'Captcha errato.';

  @override
  String get invalid_username => 'Nome utente non valido.';

  @override
  String get bio_length_overflow =>
      'La descrizione non può superare i 300 caratteri.';

  @override
  String get couldnt_update_user => 'Impossibile aggiornare l\'utente.';

  @override
  String get couldnt_update_private_message =>
      'Impossibile aggiornare un messaggio privato.';

  @override
  String get couldnt_update_post => 'Impossibile aggiornare la pubblicazione';

  @override
  String get couldnt_create_private_message =>
      'Impossibile creare un messaggio privato.';

  @override
  String get no_private_message_edit_allowed =>
      'Non hai i permessi per modificare un messaggio privato.';

  @override
  String get post_title_too_long => 'Titolo della pubblicazione troppo lungo.';

  @override
  String get email_already_exists => 'Indirizzo email già presente.';

  @override
  String get user_already_exists => 'L\'utente esiste già.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count utente connesso',
      other: '$count utenti connessi',
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
      one: '$countString Commento',
      other: '$countString Commenti',
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
      one: '$countString Pubblicazione',
      other: '$countString Pubblicazioni',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count iscritto',
      other: '$count iscritti',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count utente',
      other: '$count utenti',
    );
  }

  @override
  String get unsubscribe => 'Disiscriviti';

  @override
  String get subscribe => 'Iscriviti';

  @override
  String get messages => 'Messaggi';

  @override
  String get banned_users => 'Utenti Espulsi';

  @override
  String get delete_account_confirm =>
      'Attenzione: stai per cancellare permanentemente tutti i tuoi dati. Inserisci la tua password per confermare questa azione.';

  @override
  String get new_password => 'Nuova Password';

  @override
  String get verify_password => 'Verifica Password';

  @override
  String get old_password => 'Vecchia Password';

  @override
  String get show_avatars => 'Mostra Avatar';

  @override
  String get search => 'Cerca';

  @override
  String get send_message => 'Invia Messaggio';

  @override
  String get top_day => 'Migliori della giornata';

  @override
  String get top_week => 'Migliori della settimana';

  @override
  String get top_month => 'Migliori del mese';

  @override
  String get top_year => 'Migliori dell\'anno';

  @override
  String get top_all => 'Migliori di sempre';

  @override
  String get most_comments => 'Più commenti';

  @override
  String get new_comments => 'Nuovi Commenti';

  @override
  String get active => 'Attivi';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

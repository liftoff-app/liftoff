import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Dutch Flemish (`nl`).
class L10nNl extends L10n {
  L10nNl([String locale = 'nl']) : super(locale);

  @override
  String get settings => 'Instellingen';

  @override
  String get password => 'Wachtwoord';

  @override
  String get email_or_username => 'E-mailadres of gebruikersnaam';

  @override
  String get posts => 'Berichten';

  @override
  String get comments => 'Reacties';

  @override
  String get modlog => 'Moderatorlogboek';

  @override
  String get community => 'Gemeenschap';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titel';

  @override
  String get body => 'Hoofdtekst';

  @override
  String get nsfw => '18+';

  @override
  String get post => 'bericht';

  @override
  String get save => 'opslaan';

  @override
  String get subscribed => 'Geabonneerd';

  @override
  String get local => 'Lokaal';

  @override
  String get all => 'Alle';

  @override
  String get replies => 'Antwoorden';

  @override
  String get mentions => 'Vermeldingen';

  @override
  String get from => 'van';

  @override
  String get to => 'aan';

  @override
  String get deleted_by_creator => 'verwijderd door de maker';

  @override
  String get more => 'meer';

  @override
  String get mark_as_read => 'markeer als gelezen';

  @override
  String get mark_as_unread => 'markeer als ongelezen';

  @override
  String get reply => 'reageer';

  @override
  String get edit => 'bewerk';

  @override
  String get delete => 'verwijder';

  @override
  String get restore => 'herstellen';

  @override
  String get yes => 'ja';

  @override
  String get no => 'nee';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Banier';

  @override
  String get display_name => 'Weergavenaam';

  @override
  String get bio => 'Biografie';

  @override
  String get email => 'E-mail';

  @override
  String get matrix_user => 'Matrix-gebruiker';

  @override
  String get sort_type => 'Sorteertype';

  @override
  String get type => 'Type';

  @override
  String get show_nsfw => '18+inhoud vertonen';

  @override
  String get send_notifications_to_email =>
      'Stuur meldingen naar uw e-mailadres';

  @override
  String get delete_account => 'Account verwijderen';

  @override
  String get saved => 'Opgeslagen';

  @override
  String get communities => 'Gemeenschappen';

  @override
  String get users => 'Gebruikers';

  @override
  String get theme => 'Thema';

  @override
  String get language => 'Taal';

  @override
  String get hot => 'Populair';

  @override
  String get new_ => 'Nieuw';

  @override
  String get old => 'Oud';

  @override
  String get top => 'Top';

  @override
  String get chat => 'Babbel';

  @override
  String get admin => 'beheerder';

  @override
  String get by => 'door';

  @override
  String get not_a_mod_or_admin => 'Niet een moderator of beheerder.';

  @override
  String get not_an_admin => 'Niet een beheerder.';

  @override
  String get couldnt_find_post => 'Het bericht kon niet gevonden worden.';

  @override
  String get not_logged_in => 'Niet aangemeld.';

  @override
  String get site_ban => 'U werd verbannen van deze site';

  @override
  String get community_ban => 'U werd verbannen uit deze gemeenschap.';

  @override
  String get downvotes_disabled => 'Neerstemmen uitgeschakeld';

  @override
  String get invalid_url => 'Ongeldige URL.';

  @override
  String get locked => 'vergrendeld';

  @override
  String get couldnt_create_comment => 'Reactie kon niet aangemaakt worden.';

  @override
  String get couldnt_like_comment => 'Reactie kon niet leuk gevonden worden.';

  @override
  String get couldnt_update_comment => 'Reactie kon niet bijgewerkt worden.';

  @override
  String get no_comment_edit_allowed => 'Reactie bewerken is niet toegestaan.';

  @override
  String get couldnt_save_comment => 'Reactie kon niet opgeslagen worden.';

  @override
  String get couldnt_get_comments => 'Reacties konden niet opgehaald worden.';

  @override
  String get report_reason_required =>
      'Een rapporteringsmotivering is vereist.';

  @override
  String get report_too_long => 'Het rapport is te lang.';

  @override
  String get couldnt_create_report => 'Het rapport kon niet aangemaakt worden.';

  @override
  String get couldnt_resolve_report => 'Het rapport kon niet opgelost worden.';

  @override
  String get invalid_post_title => 'Ongeldige berichttitel';

  @override
  String get couldnt_create_post => 'Bericht kon niet aangemaakt worden.';

  @override
  String get couldnt_like_post => 'Het bericht kon niet leuk gevonden worden.';

  @override
  String get couldnt_find_community =>
      'De gemeenschap kon niet teruggevonden worden.';

  @override
  String get couldnt_get_posts => 'De berichten konden niet opgehaald worden';

  @override
  String get no_post_edit_allowed => 'Bericht bewerken is niet toegestaan.';

  @override
  String get couldnt_save_post => 'De berichten konden niet opgeslagen worden.';

  @override
  String get site_already_exists => 'Site bestaat reeds.';

  @override
  String get couldnt_update_site => 'De site kon niet bijgewerkt worden.';

  @override
  String get invalid_community_name => 'Ongeldige naam.';

  @override
  String get community_already_exists => 'Deze gemeenschap bestaat reeds.';

  @override
  String get community_moderator_already_exists =>
      'Deze gemeenschaps-moderator bestaat reeds.';

  @override
  String get community_follower_already_exists =>
      'Deze gemeenschapsvolger bestaat reeds.';

  @override
  String get not_a_moderator => 'Niet een moderator.';

  @override
  String get couldnt_update_community =>
      'De gemeenschap kon niet bijgewerkt worden.';

  @override
  String get no_community_edit_allowed =>
      'Gemeenschap bewerken is niet toegestaan.';

  @override
  String get system_err_login =>
      'Systeemfout. Probeer af te melden en vervolgens weer aan te melden.';

  @override
  String get community_user_already_banned =>
      'Deze gemeenschapsgebruiker werd reeds verbannen.';

  @override
  String get couldnt_find_that_username_or_email =>
      'De gebruikersnaam of het e-mailadres kon niet gevonden worden.';

  @override
  String get password_incorrect => 'Wachtwoord incorrect.';

  @override
  String get registration_closed => 'Registratie gesloten';

  @override
  String get invalid_password =>
      'Ongeldig wachtwoord. Het wachtwoord moet kleiner dan of gelijk aan 60 tekens zijn.';

  @override
  String get passwords_dont_match => 'Wachtwoorden komen niet overeen.';

  @override
  String get captcha_incorrect => 'Incorrecte Captcha.';

  @override
  String get invalid_username => 'Ongeldige gebruikersnaam.';

  @override
  String get bio_length_overflow =>
      'De gebruikersbiografie mag niet 300 tekens overschrijden.';

  @override
  String get couldnt_update_user => 'De gebruiker kon niet bijgewerkt worden.';

  @override
  String get couldnt_update_private_message =>
      'Het privé-bericht kon niet bijgewerkt worden.';

  @override
  String get couldnt_update_post =>
      'De berichten konden niet bijgewerkt worden';

  @override
  String get couldnt_create_private_message =>
      'Het privébericht kon niet aangemaakt worden.';

  @override
  String get no_private_message_edit_allowed =>
      'Het is niet toegestaan om privé-berichten te wijzigen.';

  @override
  String get post_title_too_long => 'De berichttitel is te lang.';

  @override
  String get email_already_exists => 'E-mailadres bestaat reeds.';

  @override
  String get user_already_exists => 'Gebruiker bestaat reeds.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count gebruiker online',
      other: '$count gebruikers online',
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
      one: '$countString reactie',
      other: '$countString reacties',
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
      one: '$countString bericht',
      other: '$countString berichten',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count abonnee',
      other: '$count abonnees',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count gebruiker',
      other: '$count gebruikers',
    );
  }

  @override
  String get unsubscribe => 'Afmelden';

  @override
  String get subscribe => 'Abonneren';

  @override
  String get messages => 'Boodschappen';

  @override
  String get banned_users => 'Verbannen gebruikers';

  @override
  String get delete_account_confirm =>
      'Waarschuwing: dit zal al uw data voorgoed verwijderen. Vul uw wachtwoord in om te bevestigen.';

  @override
  String get new_password => 'Nieuw wachtwoord';

  @override
  String get verify_password => 'Bevestig wachtwoord';

  @override
  String get old_password => 'Oud wachtwoord';

  @override
  String get show_avatars => 'Avatars tonen';

  @override
  String get search => 'Zoeken';

  @override
  String get send_message => 'Boodschap versturen';

  @override
  String get top_day => 'Dagelijks hoogtepunt';

  @override
  String get top_week => 'Wekelijks hoogtepunt';

  @override
  String get top_month => 'Maandelijks hoogtepunt';

  @override
  String get top_year => 'Jaarlijks hoogtepunt';

  @override
  String get top_all => 'Hoogtepunt aller tijden';

  @override
  String get most_comments => 'Meeste reacties';

  @override
  String get new_comments => 'Nieuwe reacties';

  @override
  String get active => 'Actief';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

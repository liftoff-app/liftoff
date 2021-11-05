import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Swedish (`sv`).
class L10nSv extends L10n {
  L10nSv([String locale = 'sv']) : super(locale);

  @override
  String get settings => 'Inställningar';

  @override
  String get password => 'Lösenord';

  @override
  String get email_or_username => 'E-postadress eller användarnamn';

  @override
  String get posts => 'Inlägg';

  @override
  String get comments => 'Kommentarer';

  @override
  String get modlog => 'Moderationslogg';

  @override
  String get community => 'Gemenskap';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titel';

  @override
  String get body => 'Text';

  @override
  String get nsfw => 'Känsligt eller oförbehållsamt innehåll';

  @override
  String get post => 'publicera';

  @override
  String get save => 'spara';

  @override
  String get subscribed => 'Prenumererar';

  @override
  String get local => 'Lokalt';

  @override
  String get all => 'Allt';

  @override
  String get replies => 'Svar';

  @override
  String get mentions => 'Nämner';

  @override
  String get from => 'från';

  @override
  String get to => 'till';

  @override
  String get deleted_by_creator => 'raderad av skapare';

  @override
  String get more => 'mer';

  @override
  String get mark_as_read => 'markera som läst';

  @override
  String get mark_as_unread => 'markera som oläst';

  @override
  String get reply => 'svara';

  @override
  String get edit => 'redigera';

  @override
  String get delete => 'radera';

  @override
  String get restore => 'återställ';

  @override
  String get yes => 'ja';

  @override
  String get no => 'nej';

  @override
  String get avatar => 'Profilbild';

  @override
  String get banner => 'Omslagsbild';

  @override
  String get display_name => 'Visningsnamn';

  @override
  String get bio => 'Presentation';

  @override
  String get email => 'E-postadress';

  @override
  String get matrix_user => 'Matrix-användare';

  @override
  String get sort_type => 'Sortering';

  @override
  String get type => 'Typ';

  @override
  String get show_nsfw => 'Visa känsligt eller oförbehållsamt innehåll';

  @override
  String get send_notifications_to_email =>
      'Skicka aviseringar till e-postadress';

  @override
  String get delete_account => 'Ta bort konto';

  @override
  String get saved => 'Sparade';

  @override
  String get communities => 'Gemenskaper';

  @override
  String get users => 'Användare';

  @override
  String get theme => 'Utseende';

  @override
  String get language => 'Språk';

  @override
  String get hot => 'Hett';

  @override
  String get new_ => 'Nytt';

  @override
  String get old => 'Gammalt';

  @override
  String get top => 'Topp';

  @override
  String get chat => 'Chatta';

  @override
  String get admin => 'administratör';

  @override
  String get by => 'av';

  @override
  String get not_a_mod_or_admin => 'Inte en moderator eller administratör.';

  @override
  String get not_an_admin => 'Inte en administratör.';

  @override
  String get couldnt_find_post => 'Kunde inte hitta inlägg.';

  @override
  String get not_logged_in => 'Inte inloggad.';

  @override
  String get site_ban => 'Du har blockerats från webbplatsen';

  @override
  String get community_ban => 'Du har blockerats från den här gemenskapen.';

  @override
  String get downvotes_disabled => 'Nedröstningar inaktiverade';

  @override
  String get invalid_url => 'Ogiltig URL.';

  @override
  String get locked => 'låst';

  @override
  String get couldnt_create_comment => 'Kunde inte skapa kommentar.';

  @override
  String get couldnt_like_comment => 'Kunde inte gilla kommentar.';

  @override
  String get couldnt_update_comment => 'Kunde inte uppdatera kommentar.';

  @override
  String get no_comment_edit_allowed =>
      'Har inte behörighet att redigera kommentar.';

  @override
  String get couldnt_save_comment => 'Kunde inte spara kommentar.';

  @override
  String get couldnt_get_comments => 'Kunde inte hämta kommentarer.';

  @override
  String get report_reason_required => 'En anledning måste anges.';

  @override
  String get report_too_long => 'Anmälan är för lång.';

  @override
  String get couldnt_create_report => 'Kunde inte skapa anmälan.';

  @override
  String get couldnt_resolve_report => 'Kunde inte markera anmälan som löst.';

  @override
  String get invalid_post_title => 'Ogiltig inläggstitel';

  @override
  String get couldnt_create_post => 'Kunde inte skapa inlägg.';

  @override
  String get couldnt_like_post => 'Kunde inte gilla inlägg.';

  @override
  String get couldnt_find_community => 'Kunde inte hitta gemenskap.';

  @override
  String get couldnt_get_posts => 'Kunde inte hämta inlägg';

  @override
  String get no_post_edit_allowed => 'Har inte behörighet att redigera inlägg.';

  @override
  String get couldnt_save_post => 'Kunde inte spara inlägg.';

  @override
  String get site_already_exists => 'Webbplatsen finns redan.';

  @override
  String get couldnt_update_site => 'Kunde inte uppdatera webbplats.';

  @override
  String get invalid_community_name => 'Ogiltigt namn.';

  @override
  String get community_already_exists => 'Gemenskapen finns redan.';

  @override
  String get community_moderator_already_exists =>
      'Gemenskapsmoderatorn finns redan.';

  @override
  String get community_follower_already_exists =>
      'Gemenskapsföljaren finns redan.';

  @override
  String get not_a_moderator => 'Inte en moderator.';

  @override
  String get couldnt_update_community => 'Kunde inte uppdatera gemenskap.';

  @override
  String get no_community_edit_allowed =>
      'Har inte behörighet att redigera gemenskap.';

  @override
  String get system_err_login =>
      'Systemfel. Försök att logga ut och sedan in igen.';

  @override
  String get community_user_already_banned =>
      'Gemenskapsanvändaren redan blockerad.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Kunde inte hitta det användarnamnet eller e-postadressen.';

  @override
  String get password_incorrect => 'Ogiltigt lösenord.';

  @override
  String get registration_closed => 'Registrering stängd';

  @override
  String get invalid_password =>
      'Ogiltigt lösenord. Lösenordet måste innehålla minst 60 tecken.';

  @override
  String get passwords_dont_match => 'Lösenorden stämmer inte överens.';

  @override
  String get captcha_incorrect => 'Captchan stämmer inte.';

  @override
  String get invalid_username => 'Ogiltigt användarnamn.';

  @override
  String get bio_length_overflow =>
      'Användarpresentationen får inte innehålla fler än 300 tecken.';

  @override
  String get couldnt_update_user => 'Kunde inte uppdatera användare.';

  @override
  String get couldnt_update_private_message =>
      'Kunde inte uppdatera privat meddelande.';

  @override
  String get couldnt_update_post => 'Kunde inte uppdatera inlägg';

  @override
  String get couldnt_create_private_message =>
      'Kunde inte skapa privat meddelande.';

  @override
  String get no_private_message_edit_allowed =>
      'Inte tillåtet att redigera privata meddelanden.';

  @override
  String get post_title_too_long => 'Inläggstiteln är för lång.';

  @override
  String get email_already_exists => 'E-post finns redan.';

  @override
  String get user_already_exists => 'Användaren finns redan.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count användare inloggad',
      other: '$count användare inloggade',
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
      one: '$countString kommentar',
      other: '$countString kommentarer',
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
      one: '$countString inlägg',
      other: '$countString inlägg',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count prenumerant',
      other: '$count prenumeranter',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count användare',
      other: '$count användare',
    );
  }

  @override
  String get unsubscribe => 'Avsluta prenumeration';

  @override
  String get subscribe => 'Prenumerera';

  @override
  String get messages => 'Meddelanden';

  @override
  String get banned_users => 'Blockerade användare';

  @override
  String get delete_account_confirm =>
      'Varning: den här åtgärden kommer radera alla dina data permanent. Skriv in ditt lösenord för att bekräfta.';

  @override
  String get new_password => 'Nytt lösenord';

  @override
  String get verify_password => 'Bekräfta lösenord';

  @override
  String get old_password => 'Gammalt lösenord';

  @override
  String get show_avatars => 'Visa profilbilder';

  @override
  String get search => 'Sök';

  @override
  String get send_message => 'Skicka meddelande';

  @override
  String get top_day => 'Dagstoppen';

  @override
  String get top_week => 'Veckotoppen';

  @override
  String get top_month => 'Månadstoppen';

  @override
  String get top_year => 'Årstoppen';

  @override
  String get top_all => 'Totaltoppen';

  @override
  String get most_comments => 'Flest kommentarer';

  @override
  String get new_comments => 'Nya kommentarer';

  @override
  String get active => 'Aktivt';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

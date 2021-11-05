import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Danish (`da`).
class L10nDa extends L10n {
  L10nDa([String locale = 'da']) : super(locale);

  @override
  String get settings => 'Indstillinger';

  @override
  String get password => 'Kodeord';

  @override
  String get email_or_username => 'Email eller Brugernavn';

  @override
  String get posts => 'Indlæg';

  @override
  String get comments => 'Kommentarer';

  @override
  String get modlog => 'Moderator log';

  @override
  String get community => 'Forum';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titel';

  @override
  String get body => 'Korpus';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'indlæg';

  @override
  String get save => 'gem';

  @override
  String get subscribed => 'Abboneret';

  @override
  String get local => 'Lokal';

  @override
  String get all => 'Alle';

  @override
  String get replies => 'Svar';

  @override
  String get mentions => 'Nævnt dig';

  @override
  String get from => 'fra';

  @override
  String get to => 'til';

  @override
  String get deleted_by_creator => 'slettet af forfatter';

  @override
  String get more => 'mere';

  @override
  String get mark_as_read => 'marker som læst';

  @override
  String get mark_as_unread => 'marker som ulæst';

  @override
  String get reply => 'svar';

  @override
  String get edit => 'ret';

  @override
  String get delete => 'slet';

  @override
  String get restore => 'genskab';

  @override
  String get yes => 'ja';

  @override
  String get no => 'nej';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Visnings navn';

  @override
  String get bio => 'Beskrivelse';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Matrix Bruger';

  @override
  String get sort_type => 'Sortering';

  @override
  String get type => 'Type';

  @override
  String get show_nsfw => 'Vis NSFW indhold';

  @override
  String get send_notifications_to_email => 'Send notifikationer til email';

  @override
  String get delete_account => 'Slet Konto';

  @override
  String get saved => 'Gemt';

  @override
  String get communities => 'Forummer';

  @override
  String get users => 'Brugere';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Sprog';

  @override
  String get hot => 'Hot';

  @override
  String get new_ => 'New';

  @override
  String get old => 'Old';

  @override
  String get top => 'Top';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'administrator';

  @override
  String get by => 'af';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Ej en administrator.';

  @override
  String get couldnt_find_post => 'Kunne ikke finde indlæg.';

  @override
  String get not_logged_in => 'Ikke logget ind.';

  @override
  String get site_ban => 'Du er udelukket fra denne site';

  @override
  String get community_ban => 'Du er blevet udelukket fra dette forum.';

  @override
  String get downvotes_disabled => 'Nedstem deaktiveret';

  @override
  String get invalid_url => 'Ugyldig URL.';

  @override
  String get locked => 'låst';

  @override
  String get couldnt_create_comment => 'Kunne ikke oprette kommentar.';

  @override
  String get couldnt_like_comment => 'Kunne ikke like kommentar.';

  @override
  String get couldnt_update_comment => 'Kunne ikke opdatere kommentar.';

  @override
  String get no_comment_edit_allowed => 'Ej tilladt at ændre kommentar.';

  @override
  String get couldnt_save_comment => 'Kunne ikke gemme kommentar.';

  @override
  String get couldnt_get_comments => 'Kunne ikke hente kommentarer.';

  @override
  String get report_reason_required => 'Angiv grund påkrævet.';

  @override
  String get report_too_long => 'Angivelsen er for lang.';

  @override
  String get couldnt_create_report => 'Kunne ikke oprette angivelse.';

  @override
  String get couldnt_resolve_report => 'Kunne ikke løse angivelse.';

  @override
  String get invalid_post_title => 'Ugyldig indlægstitel';

  @override
  String get couldnt_create_post => 'Kunne ikke oprette indlæg.';

  @override
  String get couldnt_like_post => 'Kunne ikke like indlæg.';

  @override
  String get couldnt_find_community => 'Kunne ikke finde forum.';

  @override
  String get couldnt_get_posts => 'Kunne ikke hente indlæg';

  @override
  String get no_post_edit_allowed => 'Ej tilladt at ændre indlæg.';

  @override
  String get couldnt_save_post => 'Kunne ikke gemme indlæg.';

  @override
  String get site_already_exists => 'Site findes allerede.';

  @override
  String get couldnt_update_site => 'Kunne ikke opdatere site.';

  @override
  String get invalid_community_name => 'Ugyldigt navn.';

  @override
  String get community_already_exists => 'Forum findes allerede.';

  @override
  String get community_moderator_already_exists =>
      'Forum moderator findes allerede.';

  @override
  String get community_follower_already_exists =>
      'Forum abonnent findes allerede.';

  @override
  String get not_a_moderator => 'Ej en moderator.';

  @override
  String get couldnt_update_community => 'Kunne ikke opdatere forum.';

  @override
  String get no_community_edit_allowed => 'Ej tilladt at ændre forum.';

  @override
  String get system_err_login => 'System fejl. Prøv at logge ud- og ind igen.';

  @override
  String get community_user_already_banned =>
      'Forum bruger allerede udelukket.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Kunne ikke finde bruger eller email.';

  @override
  String get password_incorrect => 'Kodeord forkert.';

  @override
  String get registration_closed => 'Tilmelding lukket';

  @override
  String get invalid_password =>
      'Ugyldigt kodeord. Kodeord skal have <= 60 tegn.';

  @override
  String get passwords_dont_match => 'Kodeord matcher ikke.';

  @override
  String get captcha_incorrect => 'Captcha forkert.';

  @override
  String get invalid_username => 'Fejl i brugernavn.';

  @override
  String get bio_length_overflow =>
      'Brugerbeskrivelse skal være mindre end 300 tegn.';

  @override
  String get couldnt_update_user => 'Kunne ikke opdatere brugeren.';

  @override
  String get couldnt_update_private_message =>
      'Kunne ej opdatere privat besked.';

  @override
  String get couldnt_update_post => 'Kunne ikke opdatere indlæg';

  @override
  String get couldnt_create_private_message =>
      'Kunne ikke oprette privat besked.';

  @override
  String get no_private_message_edit_allowed =>
      'Ulovligt at ændre i privat besked.';

  @override
  String get post_title_too_long => 'Indlægstitel for lang.';

  @override
  String get email_already_exists => 'Emailen findes allerede.';

  @override
  String get user_already_exists => 'Brugeren findes allerede.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Bruger Online',
      other: '$count Brugere Online',
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
      one: '$countString Kommentar',
      other: '$countString Kommentarer',
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
      one: '$countString Indlæg',
      other: '$countString Indlæg',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Abonnent',
      other: '$count Abonnenter',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Bruger',
      other: '$count Brugere',
    );
  }

  @override
  String get unsubscribe => 'Afmeld abbonement';

  @override
  String get subscribe => 'Abboner';

  @override
  String get messages => 'Beskeder';

  @override
  String get banned_users => 'Udelukkede Brugere';

  @override
  String get delete_account_confirm =>
      'Advarsel: Dette vil slette alle dine data. Indtast adgangskode for at bekræfte.';

  @override
  String get new_password => 'Nyt Kodeord';

  @override
  String get verify_password => 'Check Kodeord';

  @override
  String get old_password => 'Tidligere Kodeord';

  @override
  String get show_avatars => 'Vis Avatarer';

  @override
  String get search => 'Søg';

  @override
  String get send_message => 'Send Besked';

  @override
  String get top_day => 'Top dag';

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

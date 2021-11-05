import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Esperanto (`eo`).
class L10nEo extends L10n {
  L10nEo([String locale = 'eo']) : super(locale);

  @override
  String get settings => 'Agordoj';

  @override
  String get password => 'Pasvorto';

  @override
  String get email_or_username => 'Retpoŝtadreso aŭ uzantonomo';

  @override
  String get posts => 'Afiŝoj';

  @override
  String get comments => 'Komentoj';

  @override
  String get modlog => 'Protokolo de reguligado';

  @override
  String get community => 'Komunumo';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titolo';

  @override
  String get body => 'Ĉefparto';

  @override
  String get nsfw => 'Konsterna';

  @override
  String get post => 'Afiŝi';

  @override
  String get save => 'konservi';

  @override
  String get subscribed => 'Abonita';

  @override
  String get local => 'Loka';

  @override
  String get all => 'Ĉiam';

  @override
  String get replies => 'Respondoj';

  @override
  String get mentions => 'Mencioj';

  @override
  String get from => 'de';

  @override
  String get to => 'al';

  @override
  String get deleted_by_creator => 'forigita de la kreinto';

  @override
  String get more => 'pli';

  @override
  String get mark_as_read => 'marki legita';

  @override
  String get mark_as_unread => 'marki nelegita';

  @override
  String get reply => 'respondi';

  @override
  String get edit => 'redakti';

  @override
  String get delete => 'forigi';

  @override
  String get restore => 'revenigi';

  @override
  String get yes => 'jes';

  @override
  String get no => 'ne';

  @override
  String get avatar => 'Profilbildo';

  @override
  String get banner => 'Standardo';

  @override
  String get display_name => 'Prezenta nomo';

  @override
  String get bio => 'Prio';

  @override
  String get email => 'Retpoŝtadreso';

  @override
  String get matrix_user => 'Uzanto de Matrix';

  @override
  String get sort_type => 'Ordigilo';

  @override
  String get type => 'Tipo';

  @override
  String get show_nsfw => 'Montri konsternan enhavon';

  @override
  String get send_notifications_to_email => 'Sendi sciigojn al retpoŝtadreso';

  @override
  String get delete_account => 'Forigi konton';

  @override
  String get saved => 'Konservita';

  @override
  String get communities => 'Komunumoj';

  @override
  String get users => 'Uzantoj';

  @override
  String get theme => 'Haŭto';

  @override
  String get language => 'Lingvo';

  @override
  String get hot => 'Furoraj';

  @override
  String get new_ => 'Novaj';

  @override
  String get old => 'Malnovaj';

  @override
  String get top => 'Supraj';

  @override
  String get chat => 'Babilo';

  @override
  String get admin => 'administranto';

  @override
  String get by => 'de';

  @override
  String get not_a_mod_or_admin => 'Nek reguligisto nek administranto.';

  @override
  String get not_an_admin => 'Ne estas administranto.';

  @override
  String get couldnt_find_post => 'Ne povis trovi la afiŝon.';

  @override
  String get not_logged_in => 'Nesalutinta.';

  @override
  String get site_ban => 'Vi estas forbarita de la retejo';

  @override
  String get community_ban => 'Vi estas forbarita de la komunumo.';

  @override
  String get downvotes_disabled => 'Kontraŭvoĉoj malŝaltiĝis';

  @override
  String get invalid_url => 'Nevalida URL.';

  @override
  String get locked => 'ŝlosita';

  @override
  String get couldnt_create_comment => 'Ne povis krei la komenton.';

  @override
  String get couldnt_like_comment => 'Ne povis ŝati la komenton.';

  @override
  String get couldnt_update_comment => 'Ne povis ĝisdatigi la komenton.';

  @override
  String get no_comment_edit_allowed => 'Ne rajtas redakti la komenton.';

  @override
  String get couldnt_save_comment => 'Ne povis konservi la komenton.';

  @override
  String get couldnt_get_comments => 'Ne povis akiri la komentojn.';

  @override
  String get report_reason_required => 'Necesas kialo de raporto.';

  @override
  String get report_too_long => 'Raporto estas tro longa.';

  @override
  String get couldnt_create_report => 'Ne povis krei raporton.';

  @override
  String get couldnt_resolve_report => 'Ne povis trakti raporton.';

  @override
  String get invalid_post_title => 'Nevalida titolo de afiŝo';

  @override
  String get couldnt_create_post => 'Ne povis krei la afiŝon.';

  @override
  String get couldnt_like_post => 'Ne povis ŝati la afiŝon.';

  @override
  String get couldnt_find_community => 'Ne povis trovi la komunumon.';

  @override
  String get couldnt_get_posts => 'Ne povis akiri afiŝojn';

  @override
  String get no_post_edit_allowed => 'Ne rajtas redakti la afiŝon.';

  @override
  String get couldnt_save_post => 'Ne povis konservi la afiŝon.';

  @override
  String get site_already_exists => 'Retejo jam ekzistas.';

  @override
  String get couldnt_update_site => 'Ne povis ĝisdatigi la retejon.';

  @override
  String get invalid_community_name => 'Nevalida nomo.';

  @override
  String get community_already_exists => 'Komunumo jam ekzistas.';

  @override
  String get community_moderator_already_exists =>
      'Reguligisto de komunumo jam ekzistas.';

  @override
  String get community_follower_already_exists =>
      'Abonanto de komunumo jam ekzistas.';

  @override
  String get not_a_moderator => 'Nereguligisto.';

  @override
  String get couldnt_update_community => 'Ne povis ĝisdatigi la komunumon.';

  @override
  String get no_community_edit_allowed => 'Ne rajtas redakti la komunumon.';

  @override
  String get system_err_login => 'Sistema eraro. Provu adiaŭi kaj resaluti.';

  @override
  String get community_user_already_banned =>
      'Uzanto de komunumo jam estas forbarita.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Ne povis trovi tiun uzantonomon aŭ retpoŝtadreson.';

  @override
  String get password_incorrect => 'Pasvorto malĝustas.';

  @override
  String get registration_closed => 'Registrado malebliĝis';

  @override
  String get invalid_password =>
      'Nevalido pasvorto. Pasvorto devas havi ≤ 60 signojn.';

  @override
  String get passwords_dont_match => 'Pasvortoj ne samas.';

  @override
  String get captcha_incorrect => 'Neĝuste solvita kontrolo de homeco.';

  @override
  String get invalid_username => 'Nevalida uzantonomo.';

  @override
  String get bio_length_overflow =>
      'Prio de uzanto ne povas havi pli ol 300 signojn.';

  @override
  String get couldnt_update_user => 'Ne povis ĝisdatigi la uzanton.';

  @override
  String get couldnt_update_private_message =>
      'Ne povis ĝisdatigi la privatan mesaĝon.';

  @override
  String get couldnt_update_post => 'Ne povis ĝisdatigi la afiŝon';

  @override
  String get couldnt_create_private_message =>
      'Ne povis krei privatan mesaĝon.';

  @override
  String get no_private_message_edit_allowed =>
      'Ne rajtas redakti la privatan mesaĝon.';

  @override
  String get post_title_too_long => 'Titolo de afiŝo estas tro longa.';

  @override
  String get email_already_exists => 'Retpoŝtadreso jam ekzistas.';

  @override
  String get user_already_exists => 'Uzanto jam ekzistas.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count uzanto enreta',
      other: '$count uzantoj enretaj',
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
      one: '$countString komento',
      other: '$countString komentoj',
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
      one: '$countString afiŝo',
      other: '$countString afiŝoj',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count abonanto',
      other: '$count abonantoj',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count uzanto',
      other: '$count uzantoj',
    );
  }

  @override
  String get unsubscribe => 'Malaboni';

  @override
  String get subscribe => 'Aboni';

  @override
  String get messages => 'Mesaĝoj';

  @override
  String get banned_users => 'Forbaritaj uzantoj';

  @override
  String get delete_account_confirm =>
      'Averto: ĉi tio por ĉiam forigos ĉiujn viajn datumojn. Enigu pasvorton por konfirmi.';

  @override
  String get new_password => 'Nova pasvorto';

  @override
  String get verify_password => 'Konfirmu vian pasvorton';

  @override
  String get old_password => 'Malnova pasvorto';

  @override
  String get show_avatars => 'Montri profilbildojn';

  @override
  String get search => 'Serĉi';

  @override
  String get send_message => 'Sendi mesaĝon';

  @override
  String get top_day => 'Supraj tagaj';

  @override
  String get top_week => 'Supraj semajnaj';

  @override
  String get top_month => 'Supraj monataj';

  @override
  String get top_year => 'Supraj jaraj';

  @override
  String get top_all => 'Supraj ĉiamaj';

  @override
  String get most_comments => 'Plej komentitaj';

  @override
  String get new_comments => 'Nove komentitaj';

  @override
  String get active => 'Aktiva';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

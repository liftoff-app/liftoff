import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Albanian (`sq`).
class L10nSq extends L10n {
  L10nSq([String locale = 'sq']) : super(locale);

  @override
  String get settings => 'Konfigurimet';

  @override
  String get password => 'Fjalëkalimi';

  @override
  String get email_or_username => 'Email-i ose Emri Virtual';

  @override
  String get posts => 'Postime';

  @override
  String get comments => 'Komentet';

  @override
  String get modlog => 'Ditari i moderimit';

  @override
  String get community => 'Komuniteti';

  @override
  String get url => 'URL';

  @override
  String get title => 'Titulli';

  @override
  String get body => 'Teksti';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'publiko';

  @override
  String get save => 'ruaj';

  @override
  String get subscribed => 'Jeni abonuar';

  @override
  String get local => 'Local';

  @override
  String get all => 'Gjithçka';

  @override
  String get replies => 'Përgjigjet';

  @override
  String get mentions => 'Përmendur';

  @override
  String get from => 'nga';

  @override
  String get to => 'në';

  @override
  String get deleted_by_creator => 'është fshirë nga autori';

  @override
  String get more => 'më shumë';

  @override
  String get mark_as_read => 'shëno si të lexuar';

  @override
  String get mark_as_unread => 'shëno si të palexuar';

  @override
  String get reply => 'përgjigju';

  @override
  String get edit => 'redakto';

  @override
  String get delete => 'fshije';

  @override
  String get restore => 'riktheje';

  @override
  String get yes => 'po';

  @override
  String get no => 'jo';

  @override
  String get avatar => 'Fotoja e profilit';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Display name';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Përdorues i Matrix-it';

  @override
  String get sort_type => 'Radhit sipas';

  @override
  String get type => 'Lloji';

  @override
  String get show_nsfw => 'Shfaq përmbajtje NSFW';

  @override
  String get send_notifications_to_email => 'Dërgo njoftimet në Email';

  @override
  String get delete_account => 'Fshije Account-in';

  @override
  String get saved => 'E ruajtur';

  @override
  String get communities => 'Komunitetet';

  @override
  String get users => 'Përdoruesit';

  @override
  String get theme => 'Pamja';

  @override
  String get language => 'Gjuha';

  @override
  String get hot => 'Popullore';

  @override
  String get new_ => 'Të rejat';

  @override
  String get old => 'Të vjetrat';

  @override
  String get top => 'Më të pëqlyerat';

  @override
  String get chat => 'Chat';

  @override
  String get admin => 'administrator';

  @override
  String get by => 'nga';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Nuk je administrator.';

  @override
  String get couldnt_find_post => 'Nuk mund të gjendeshin postimet.';

  @override
  String get not_logged_in => 'Nuk jeni kyçur.';

  @override
  String get site_ban => 'Jeni dëbuar nga kjo faqe';

  @override
  String get community_ban => 'Jeni dëbuar nga ky komunitet.';

  @override
  String get downvotes_disabled => 'Votat negative janë të çaktivizuara';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => 'mbyllur';

  @override
  String get couldnt_create_comment =>
      'Krijimi i komentit nuk ishte i mundshëm.';

  @override
  String get couldnt_like_comment => 'Pëlqimi i komentit nuk ishte i mundshëm.';

  @override
  String get couldnt_update_comment =>
      'Përditësimi i komentit nuk ishte i mundshëm.';

  @override
  String get no_comment_edit_allowed => 'Nuk të lejohet redaktimi i komentit.';

  @override
  String get couldnt_save_comment => 'Ruajtja e komentit nuk ishte e mundshme.';

  @override
  String get couldnt_get_comments => 'Nuk mund të merrnim komentet.';

  @override
  String get report_reason_required => 'Report reason required.';

  @override
  String get report_too_long => 'Report too long.';

  @override
  String get couldnt_create_report => 'Couldn\'t create report.';

  @override
  String get couldnt_resolve_report => 'Couldn\'t resolve report.';

  @override
  String get invalid_post_title => 'Invalid post title';

  @override
  String get couldnt_create_post => 'Nuk mund të krijohej postimi.';

  @override
  String get couldnt_like_post => 'Nuk mund të pëlqehej postimi.';

  @override
  String get couldnt_find_community => 'Komuniteti nuk mund të gjendej.';

  @override
  String get couldnt_get_posts => 'Nuk mund të merreshin postimet';

  @override
  String get no_post_edit_allowed => 'Nuk lejohet redaktimi i postimit.';

  @override
  String get couldnt_save_post => 'Postimi nuk u ruajt.';

  @override
  String get site_already_exists => 'Faqja tashmë ekziston.';

  @override
  String get couldnt_update_site => 'Faqja nuk mund të përditësohej.';

  @override
  String get invalid_community_name => 'Emër invalid.';

  @override
  String get community_already_exists => 'Komuniteti ekziston më.';

  @override
  String get community_moderator_already_exists =>
      'Moderatori i komunitetit tashmë ekziston.';

  @override
  String get community_follower_already_exists =>
      'Ndjekësi i komunitetit tashmë ekziston.';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community =>
      'Komuniteti nuk mundi të përditësohej.';

  @override
  String get no_community_edit_allowed =>
      'Nuk të lejohet redaktimi i komunitetit.';

  @override
  String get system_err_login =>
      'Gabim sistemi. Provo të shkyçesh dhe të kyçesh përsëri.';

  @override
  String get community_user_already_banned =>
      'Anëtari i komunitetit tashmë është dëbuar.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Nuk mund të gjendej ky emër virtual ose email.';

  @override
  String get password_incorrect => 'Fjalëkalimi është i pasaktë.';

  @override
  String get registration_closed => 'Regjistrimi u mbyll';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'Fjalëkalimet nuk janë të njëjta.';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Emri virtual është invalid.';

  @override
  String get bio_length_overflow => 'User bio cannot exceed 300 characters.';

  @override
  String get couldnt_update_user =>
      'Përditësimi i përdoruesit nuk ishte i mundshëm.';

  @override
  String get couldnt_update_private_message =>
      'Nuk mundëm të përditësonim mesazhin privat.';

  @override
  String get couldnt_update_post => 'Postimi nuk mundi të përditësohej';

  @override
  String get couldnt_create_private_message =>
      'Nuk mund të krijohej mesazhi privat.';

  @override
  String get no_private_message_edit_allowed =>
      'Nuk lejohet redaktimi i mesazhit privat.';

  @override
  String get post_title_too_long => 'Titulli i postimit ishte shumë i gjatë.';

  @override
  String get email_already_exists => 'Email-i tashmë ekziston.';

  @override
  String get user_already_exists => 'Përdoruesi tashmë ekziston.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Përdorues Online',
      other: '$count Përdoruesa Online',
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
      one: '$countString Koment',
      other: '$countString Komente',
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
      one: '$countString Postim',
      other: '$countString Postime',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count i abonuar',
      other: '$count të abonuar',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Përdorues',
      other: '$count Përdoruesa',
    );
  }

  @override
  String get unsubscribe => 'Ndalo Abonimin';

  @override
  String get subscribe => 'Abonohu';

  @override
  String get messages => 'Mesazhet';

  @override
  String get banned_users => 'Pëdoruesit e dëbuar';

  @override
  String get delete_account_confirm =>
      'Paralajmërim: kjo do të fshij të gjitha të dhënat e juaja përgjithmonë. Shtyp fjalëkalimin tënd për ta konfirmuar.';

  @override
  String get new_password => 'Fjalëkalimi i ri';

  @override
  String get verify_password => 'Konfirmo Fjalëkalimin';

  @override
  String get old_password => 'Fjalëkalimi i vjetër';

  @override
  String get show_avatars => 'Shfaq fotot e profilit';

  @override
  String get search => 'Kërko';

  @override
  String get send_message => 'Dërgo Mesazh';

  @override
  String get top_day => 'Më të pëlqyerat e ditës';

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

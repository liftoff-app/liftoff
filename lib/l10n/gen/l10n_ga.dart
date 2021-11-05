import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Irish (`ga`).
class L10nGa extends L10n {
  L10nGa([String locale = 'ga']) : super(locale);

  @override
  String get settings => 'Socruithe';

  @override
  String get password => 'Pasfhocal';

  @override
  String get email_or_username => 'Ríomhphost nó Ainm Úsáideora';

  @override
  String get posts => 'Postálacha';

  @override
  String get comments => 'Tráchtanna';

  @override
  String get modlog => 'Logamod';

  @override
  String get community => 'Pobal';

  @override
  String get url => 'URL';

  @override
  String get title => 'Teideal';

  @override
  String get body => 'Corp';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'postáil';

  @override
  String get save => 'sábháil';

  @override
  String get subscribed => 'Suibscríofa';

  @override
  String get local => 'Áitiúil';

  @override
  String get all => 'Gach';

  @override
  String get replies => 'Freagraí';

  @override
  String get mentions => 'Luann';

  @override
  String get from => 'ó';

  @override
  String get to => 'chun';

  @override
  String get deleted_by_creator => 'scriosta ag cruthaitheoir';

  @override
  String get more => 'tuilleadh';

  @override
  String get mark_as_read => 'marc mar a léitear';

  @override
  String get mark_as_unread => 'marc mar neamhléite';

  @override
  String get reply => 'freagra';

  @override
  String get edit => 'cuir in eagar';

  @override
  String get delete => 'scriosadh';

  @override
  String get restore => 'athchóirigh';

  @override
  String get yes => 'tá';

  @override
  String get no => 'níl';

  @override
  String get avatar => 'Abhatár';

  @override
  String get banner => 'Meirge';

  @override
  String get display_name => 'Ainm taispeána';

  @override
  String get bio => 'Beathaisnéis';

  @override
  String get email => 'Ríomhphost';

  @override
  String get matrix_user => 'Úsáideoir Matrix';

  @override
  String get sort_type => 'Cineál sórtála';

  @override
  String get type => 'Cineál';

  @override
  String get show_nsfw => 'Taispeáin ábhar NSFW';

  @override
  String get send_notifications_to_email => 'Seol fógraí chuig Ríomhphost';

  @override
  String get delete_account => 'Scrios Cuntas';

  @override
  String get saved => 'Coinníodh';

  @override
  String get communities => 'Pobail';

  @override
  String get users => 'Úsáideoirí';

  @override
  String get theme => 'Téama';

  @override
  String get language => 'Teanga';

  @override
  String get hot => 'Te';

  @override
  String get new_ => 'Nua';

  @override
  String get old => 'Sean';

  @override
  String get top => 'Barr';

  @override
  String get chat => 'Comhrá';

  @override
  String get admin => 'riarthóir';

  @override
  String get by => 'le';

  @override
  String get not_a_mod_or_admin => 'Ní modhnóir ná riarthóir é.';

  @override
  String get not_an_admin => 'Ní riarthóir é.';

  @override
  String get couldnt_find_post => 'Níorbh fhéidir an post a aimsiú.';

  @override
  String get not_logged_in => 'Ní logáilte isteach.';

  @override
  String get site_ban => 'Cuireadh cosc ort ón suíomh';

  @override
  String get community_ban => 'Cuireadh cosc ort ón bpobal seo.';

  @override
  String get downvotes_disabled => 'Síosvótaí faoi mhíchumas';

  @override
  String get invalid_url => 'URL neamhbhailí.';

  @override
  String get locked => 'glasáilte';

  @override
  String get couldnt_create_comment => 'Níorbh fhéidir a chruthú trácht.';

  @override
  String get couldnt_like_comment => 'Níorbh fhéidir a is maith trácht.';

  @override
  String get couldnt_update_comment => 'Níorbh fhéidir trácht a nuashonrú.';

  @override
  String get no_comment_edit_allowed =>
      'Ní cheadaítear trácht a chur in eagar.';

  @override
  String get couldnt_save_comment => 'Níorbh fhéidir trácht a shábháil.';

  @override
  String get couldnt_get_comments => 'Níorbh fhéidir tuairimí a fháil.';

  @override
  String get report_reason_required => 'Cúis leis an Tuarascáil Riachtanach.';

  @override
  String get report_too_long => 'Tuairiscigh ró-fhada.';

  @override
  String get couldnt_create_report => 'Níorbh fhéidir tuairisc a chruthú.';

  @override
  String get couldnt_resolve_report =>
      'Níorbh fhéidir an tuarascáil a réiteach.';

  @override
  String get invalid_post_title => 'Teideal poist neamhbhailí';

  @override
  String get couldnt_create_post => 'Níorbh fhéidir postáil a chruthú.';

  @override
  String get couldnt_like_post => 'Níorbh fhéidir a is maith post.';

  @override
  String get couldnt_find_community => 'Níorbh fhéidir Pobal a aimsiú.';

  @override
  String get couldnt_get_posts => 'Níorbh fhéidir an post a fháil';

  @override
  String get no_post_edit_allowed => 'Ní cheadaítear an post a chur in eagar.';

  @override
  String get couldnt_save_post => 'Níorbh fhéidir an post a shábháil.';

  @override
  String get site_already_exists => 'Suíomh ann cheana.';

  @override
  String get couldnt_update_site => 'Níorbh fhéidir an suíomh a nuashonrú.';

  @override
  String get invalid_community_name => 'Ainm neamhbhailí.';

  @override
  String get community_already_exists => 'Pobal ann cheana féin.';

  @override
  String get community_moderator_already_exists =>
      'Tá modhnóir pobail ann cheana féin.';

  @override
  String get community_follower_already_exists =>
      'Tá leantóir pobail ann cheana féin.';

  @override
  String get not_a_moderator => 'Ní modhnóir.';

  @override
  String get couldnt_update_community => 'Níorbh fhéidir an Pobal a nuashonrú.';

  @override
  String get no_community_edit_allowed =>
      'Ní cheadaítear an pobal a chur in eagar.';

  @override
  String get system_err_login =>
      'Earráid chórais. Bain triail as logáil amach agus ar ais isteach.';

  @override
  String get community_user_already_banned =>
      'Toirmisctear úsáideoir pobail cheana féin.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Níorbh fhéidir an t-ainm úsáideora nó an ríomhphost sin a fháil.';

  @override
  String get password_incorrect => 'Pasfhocal mícheart.';

  @override
  String get registration_closed => 'Clárú dúnta';

  @override
  String get invalid_password =>
      'Pasfhocal neamhbhailí. Caithfidh <= 60 carachtar a bheith sa phasfhocal.';

  @override
  String get passwords_dont_match => 'Ní hionann pasfhocail.';

  @override
  String get captcha_incorrect => 'Ta Captcha mícheart.';

  @override
  String get invalid_username => 'Ainm Úsáideora neamhbhailí.';

  @override
  String get bio_length_overflow =>
      'Ní féidir le bith-úsáideoir níos mó ná 300 carachtar.';

  @override
  String get couldnt_update_user =>
      'Níorbh fhéidir an t-úsáideoir a nuashonrú.';

  @override
  String get couldnt_update_private_message =>
      'Níorbh fhéidir teachtaireacht phríobháideach a nuashonrú.';

  @override
  String get couldnt_update_post => 'Níorbh fhéidir an post a nuashonrú';

  @override
  String get couldnt_create_private_message =>
      'Níorbh fhéidir teachtaireacht phríobháideach a chruthú.';

  @override
  String get no_private_message_edit_allowed =>
      'Ní cheadaítear teachtaireacht phríobháideach a chur in eagar.';

  @override
  String get post_title_too_long => 'Tá teideal an postáil ró-fhada.';

  @override
  String get email_already_exists => 'Tá ríomhphost ann cheana féin.';

  @override
  String get user_already_exists => 'Úsáideoir ann cheana.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count user online',
      other: '$count users online',
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
      one: '$countString comment',
      other: '$countString comments',
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
      one: '$countString post',
      other: '$countString posts',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count subscriber',
      other: '$count subscribers',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count user',
      other: '$count users',
    );
  }

  @override
  String get unsubscribe => 'Díliostáil';

  @override
  String get subscribe => 'Liostáil';

  @override
  String get messages => 'Teachtaireachtaí';

  @override
  String get banned_users => 'Úsáideoirí Coisceadh';

  @override
  String get delete_account_confirm =>
      'Rabhadh: scriosfaidh sé seo do chuid sonraí go buan. Iontráil do phasfhocal le deimhniú.';

  @override
  String get new_password => 'Focal Faire Nua';

  @override
  String get verify_password => 'Deimhnigh Pasfhocal';

  @override
  String get old_password => 'Sean Pasfhocal';

  @override
  String get show_avatars => 'Taispeáin Abhatáranna';

  @override
  String get search => 'Cuardaigh';

  @override
  String get send_message => 'Seol Teachtaireacht';

  @override
  String get top_day => 'Lá Barr';

  @override
  String get top_week => 'Seachtain Barr';

  @override
  String get top_month => 'Barr Mí';

  @override
  String get top_year => 'Bar Bliain';

  @override
  String get top_all => 'Barr an Ama Uile';

  @override
  String get most_comments => 'Tuairimí an chuid is mó';

  @override
  String get new_comments => 'Tráchtaireachtaí Nua';

  @override
  String get active => 'Gnóthach';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

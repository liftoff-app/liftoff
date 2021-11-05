import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Georgian (`ka`).
class L10nKa extends L10n {
  L10nKa([String locale = 'ka']) : super(locale);

  @override
  String get settings => 'პარამეტრები';

  @override
  String get password => 'პაროლი';

  @override
  String get email_or_username => 'ელ-პოსტა  ან მომხმარებლის სახელი';

  @override
  String get posts => 'პოსტები';

  @override
  String get comments => 'კომენტარები';

  @override
  String get modlog => 'მოდ-ლოგი';

  @override
  String get community => 'თემა';

  @override
  String get url => 'მისამართი';

  @override
  String get title => 'სათაური';

  @override
  String get body => 'ტექსტი';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'პოსტი';

  @override
  String get save => 'დამახსოვრება';

  @override
  String get subscribed => 'გამოწერილია';

  @override
  String get local => 'Local';

  @override
  String get all => 'ყველა';

  @override
  String get replies => 'პასუხები';

  @override
  String get mentions => 'ხსენებები';

  @override
  String get from => 'from';

  @override
  String get to => 'to';

  @override
  String get deleted_by_creator => 'წაშლილია';

  @override
  String get more => 'მეტი';

  @override
  String get mark_as_read => 'მონიშნე როგორც წაკითხული';

  @override
  String get mark_as_unread => 'მონიშნე როგორც წაუკითხავი';

  @override
  String get reply => 'პასუხის გაცემა';

  @override
  String get edit => 'რადექტირება';

  @override
  String get delete => 'წაშლა';

  @override
  String get restore => 'რასტორაცია';

  @override
  String get yes => 'კი';

  @override
  String get no => 'არა';

  @override
  String get avatar => 'ავატარი';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Display name';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'ელ-პოსტა';

  @override
  String get matrix_user => 'მატრიცული მომხმარებელი';

  @override
  String get sort_type => 'სორტირების ტიპი';

  @override
  String get type => 'ტიპი';

  @override
  String get show_nsfw => 'Show NSFW content';

  @override
  String get send_notifications_to_email => 'შეტყობინების გაგზავნა ელ-პოსტაზე';

  @override
  String get delete_account => 'ჩემი ანგარიშის წაშლა';

  @override
  String get saved => 'შანახული';

  @override
  String get communities => 'თემები';

  @override
  String get users => 'მომხმარებელი';

  @override
  String get theme => 'საიტის თემა';

  @override
  String get language => 'ენა';

  @override
  String get hot => 'ცხელი';

  @override
  String get new_ => 'ახალი';

  @override
  String get old => 'ძველი';

  @override
  String get top => 'ტოპ';

  @override
  String get chat => 'ჩეტი';

  @override
  String get admin => 'ადმინი';

  @override
  String get by => 'by';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'ადმინი არ არის';

  @override
  String get couldnt_find_post => 'პოსტი ვერ მოიძებნა.';

  @override
  String get not_logged_in => 'შასული არ ხართ';

  @override
  String get site_ban => 'საიტიდან გაშავებული ხარ.';

  @override
  String get community_ban => 'შენ ამ თემისგან გაშავებული ხარ.';

  @override
  String get downvotes_disabled => 'არმოწონები გამორთულია';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => 'ჩაკეტილი';

  @override
  String get couldnt_create_comment => 'კომენტარის შექმნა ვერ მოხერხდა.';

  @override
  String get couldnt_like_comment => 'კომენტარის მოწონება ვერ მოხერხდა.';

  @override
  String get couldnt_update_comment => 'კომენტარის განახლება ვერ მოხერხდა.';

  @override
  String get no_comment_edit_allowed => 'კომენტარის რედაკტირება არ შეიძლება.';

  @override
  String get couldnt_save_comment => 'კომენტარის შენახვა ვერ მოხერხდა.';

  @override
  String get couldnt_get_comments => 'კომენტარების ნახვა ვერ მოხერხდა.';

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
  String get couldnt_create_post => 'პოსტი ვერ შეიქმნა.';

  @override
  String get couldnt_like_post => 'პოსტის მოწონება ვერ მოხერხდა.';

  @override
  String get couldnt_find_community => 'ტემა არ მოიძებნა.';

  @override
  String get couldnt_get_posts => 'პოსტები არ არის.';

  @override
  String get no_post_edit_allowed => 'პოსტის რედაკტირება არ შეიძლება.';

  @override
  String get couldnt_save_post => 'პოსტის დასეივება ვერ მოხერხდა.';

  @override
  String get site_already_exists => 'Site already exists.';

  @override
  String get couldnt_update_site => 'Couldn\'t update site.';

  @override
  String get invalid_community_name => 'Invalid name.';

  @override
  String get community_already_exists => 'ეს თემა უკვე არსებობს.';

  @override
  String get community_moderator_already_exists =>
      'ამ თემის მოდერატორი უკვე არსებობს.';

  @override
  String get community_follower_already_exists =>
      'თემის ფოლოვორი უკვე არსებობს.';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community => 'თემა ვერ განახლდა.';

  @override
  String get no_community_edit_allowed => 'თემის რედაკტირება არ შეიძლება.';

  @override
  String get system_err_login => 'ერორი.  თავიდან შემოსვლა ცადეთ.';

  @override
  String get community_user_already_banned =>
      'თემის მომხმარებელი უკვე შავ სიაშია.';

  @override
  String get couldnt_find_that_username_or_email =>
      'სახელი ან ელ-პოსტა ვერ მოიძებნა.';

  @override
  String get password_incorrect => 'პაროლი არასწორია .';

  @override
  String get registration_closed => 'რეგისტრაცია დახურულია';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'პაროლები იგივი არ არის.';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Invalid username.';

  @override
  String get bio_length_overflow => 'User bio cannot exceed 300 characters.';

  @override
  String get couldnt_update_user => 'მომხმარებლის განახლება ვერ მოხერხდა.';

  @override
  String get couldnt_update_private_message =>
      'Couldn\'t update private message.';

  @override
  String get couldnt_update_post => 'პოსტი ვერ განახლდა';

  @override
  String get couldnt_create_private_message =>
      'Couldn\'t create private message.';

  @override
  String get no_private_message_edit_allowed =>
      'Not allowed to edit private message.';

  @override
  String get post_title_too_long => 'პოსტის სათაური ძალიან გრძელია.';

  @override
  String get email_already_exists => 'ელ-პოსტა უკვე არსებობს.';

  @override
  String get user_already_exists => 'მომხმარებელი უკვე არსებობს.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: 'მომხმარებელი საიტზე',
      other: 'მომხმარებელი საიტზე',
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
      one: 'კომენტარი',
      other: 'კომანტარები',
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
      one: 'თარგმნა',
      other: 'თარგმნა',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: 'გამომწერი',
      other: 'გამომწერები',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: 'მომხმარებელი',
      other: 'მომხმარებლები',
    );
  }

  @override
  String get unsubscribe => 'გამოწერის გაუქმნება';

  @override
  String get subscribe => 'გამოწერა';

  @override
  String get messages => 'მესეჯები';

  @override
  String get banned_users => 'გაშავებული მომხმარებლები';

  @override
  String get delete_account_confirm =>
      'გაფთხილება: ეს შენს ყველაფერს წაშლის.  პაროლი ჩაწერეთ რომ დაადასტუროთ.';

  @override
  String get new_password => 'ახალი პაროლი';

  @override
  String get verify_password => 'პაროლის დადასტურება';

  @override
  String get old_password => 'ძველი პაროლი';

  @override
  String get show_avatars => 'ავატარები გამოჩენა';

  @override
  String get search => 'ძებმა';

  @override
  String get send_message => 'მესეჯის გაგზავნა';

  @override
  String get top_day => 'ტოპ დღეს';

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

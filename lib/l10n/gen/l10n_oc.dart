import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Occitan (`oc`).
class L10nOc extends L10n {
  L10nOc([String locale = 'oc']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get password => 'Password';

  @override
  String get email_or_username => 'Email or Username';

  @override
  String get posts => 'Posts';

  @override
  String get comments => 'Comments';

  @override
  String get modlog => 'Modlog';

  @override
  String get community => 'Community';

  @override
  String get url => 'URL';

  @override
  String get title => 'Title';

  @override
  String get body => 'Body';

  @override
  String get nsfw => 'NSFW';

  @override
  String get post => 'post';

  @override
  String get save => 'save';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get local => 'Local';

  @override
  String get all => 'All';

  @override
  String get replies => 'Replies';

  @override
  String get mentions => 'Mentions';

  @override
  String get from => 'from';

  @override
  String get to => 'to';

  @override
  String get deleted_by_creator => 'deleted by creator';

  @override
  String get more => 'more';

  @override
  String get mark_as_read => 'mark as read';

  @override
  String get mark_as_unread => 'mark as unread';

  @override
  String get reply => 'reply';

  @override
  String get edit => 'edit';

  @override
  String get delete => 'delete';

  @override
  String get restore => 'restore';

  @override
  String get yes => 'yes';

  @override
  String get no => 'no';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Display name';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Matrix User';

  @override
  String get sort_type => 'Sort type';

  @override
  String get type => 'Type';

  @override
  String get show_nsfw => 'Show NSFW content';

  @override
  String get send_notifications_to_email => 'Send notifications to Email';

  @override
  String get delete_account => 'Delete account';

  @override
  String get saved => 'Saved';

  @override
  String get communities => 'Communities';

  @override
  String get users => 'Users';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

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
  String get admin => 'admin';

  @override
  String get by => 'by';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Not an admin.';

  @override
  String get couldnt_find_post => 'Couldn\'t find post.';

  @override
  String get not_logged_in => 'Not logged in.';

  @override
  String get site_ban => 'You have been banned from the site';

  @override
  String get community_ban => 'You have been banned from this community.';

  @override
  String get downvotes_disabled => 'Downvotes disabled';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => 'locked';

  @override
  String get couldnt_create_comment => 'Couldn\'t create comment.';

  @override
  String get couldnt_like_comment => 'Couldn\'t like comment.';

  @override
  String get couldnt_update_comment => 'Couldn\'t update comment.';

  @override
  String get no_comment_edit_allowed => 'Not allowed to edit comment.';

  @override
  String get couldnt_save_comment => 'Couldn\'t save comment.';

  @override
  String get couldnt_get_comments => 'Couldn\'t get comments.';

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
  String get couldnt_create_post => 'Couldn\'t create post.';

  @override
  String get couldnt_like_post => 'Couldn\'t like post.';

  @override
  String get couldnt_find_community => 'Couldn\'t find community.';

  @override
  String get couldnt_get_posts => 'Couldn\'t get posts';

  @override
  String get no_post_edit_allowed => 'Not allowed to edit post.';

  @override
  String get couldnt_save_post => 'Couldn\'t save post.';

  @override
  String get site_already_exists => 'Site already exists.';

  @override
  String get couldnt_update_site => 'Couldn\'t update site.';

  @override
  String get invalid_community_name => 'Invalid name.';

  @override
  String get community_already_exists => 'Community already exists.';

  @override
  String get community_moderator_already_exists =>
      'Community moderator already exists.';

  @override
  String get community_follower_already_exists =>
      'Community follower already exists.';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community => 'Couldn\'t update Community.';

  @override
  String get no_community_edit_allowed => 'Not allowed to edit community.';

  @override
  String get system_err_login => 'System error. Try logging out and back in.';

  @override
  String get community_user_already_banned => 'Community user already banned.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Couldn\'t find that username or email.';

  @override
  String get password_incorrect => 'Password incorrect.';

  @override
  String get registration_closed => 'Registration closed';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'Passwords do not match.';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Invalid username.';

  @override
  String get bio_length_overflow => 'User bio cannot exceed 300 characters.';

  @override
  String get couldnt_update_user => 'Couldn\'t update user.';

  @override
  String get couldnt_update_private_message =>
      'Couldn\'t update private message.';

  @override
  String get couldnt_update_post => 'Couldn\'t update post';

  @override
  String get couldnt_create_private_message =>
      'Couldn\'t create private message.';

  @override
  String get no_private_message_edit_allowed =>
      'Not allowed to edit private message.';

  @override
  String get post_title_too_long => 'Post title too long.';

  @override
  String get email_already_exists => 'Email already exists.';

  @override
  String get user_already_exists => 'User already exists.';

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
  String get unsubscribe => 'unsubscribe';

  @override
  String get subscribe => 'subscribe';

  @override
  String get messages => 'Messages';

  @override
  String get banned_users => 'Banned users';

  @override
  String get delete_account_confirm =>
      'Warning: this will permanently delete all your data. Enter your password to confirm.';

  @override
  String get new_password => 'New password';

  @override
  String get verify_password => 'Verify password';

  @override
  String get old_password => 'Old password';

  @override
  String get show_avatars => 'Show avatars';

  @override
  String get search => 'search';

  @override
  String get send_message => 'Send message';

  @override
  String get top_day => 'Top Day';

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

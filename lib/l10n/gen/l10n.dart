import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_bg.dart';
import 'l10n_ca.dart';
import 'l10n_da.dart';
import 'l10n_de.dart';
import 'l10n_el.dart';
import 'l10n_en.dart';
import 'l10n_eo.dart';
import 'l10n_es.dart';
import 'l10n_eu.dart';
import 'l10n_fa.dart';
import 'l10n_fi.dart';
import 'l10n_fr.dart';
import 'l10n_ga.dart';
import 'l10n_gl.dart';
import 'l10n_hi.dart';
import 'l10n_hr.dart';
import 'l10n_hu.dart';
import 'l10n_it.dart';
import 'l10n_ja.dart';
import 'l10n_ka.dart';
import 'l10n_km.dart';
import 'l10n_ko.dart';
import 'l10n_nb.dart';
import 'l10n_nl.dart';
import 'l10n_oc.dart';
import 'l10n_pl.dart';
import 'l10n_pt.dart';
import 'l10n_ru.dart';
import 'l10n_sq.dart';
import 'l10n_sr.dart';
import 'l10n_sv.dart';
import 'l10n_th.dart';
import 'l10n_tr.dart';
import 'l10n_uk.dart';
import 'l10n_zh.dart';

/// Callers can lookup localized strings with an instance of L10n returned
/// by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('bg'),
    Locale('ca'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('eo'),
    Locale('es'),
    Locale('eu'),
    Locale('fa'),
    Locale('fi'),
    Locale('fr'),
    Locale('ga'),
    Locale('gl'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('ka'),
    Locale('km'),
    Locale('ko'),
    Locale('nb'),
    Locale('nb', 'NO'),
    Locale('nl'),
    Locale('oc'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('sq'),
    Locale('sr'),
    Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email_or_username.
  ///
  /// In en, this message translates to:
  /// **'Email or Username'**
  String get email_or_username;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @modlog.
  ///
  /// In en, this message translates to:
  /// **'Modlog'**
  String get modlog;

  /// No description provided for @community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get community;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @nsfw.
  ///
  /// In en, this message translates to:
  /// **'NSFW'**
  String get nsfw;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'post'**
  String get post;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'save'**
  String get save;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @local.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get local;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get replies;

  /// No description provided for @mentions.
  ///
  /// In en, this message translates to:
  /// **'Mentions'**
  String get mentions;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @deleted_by_creator.
  ///
  /// In en, this message translates to:
  /// **'deleted by creator'**
  String get deleted_by_creator;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// No description provided for @mark_as_read.
  ///
  /// In en, this message translates to:
  /// **'mark as read'**
  String get mark_as_read;

  /// No description provided for @mark_as_unread.
  ///
  /// In en, this message translates to:
  /// **'mark as unread'**
  String get mark_as_unread;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'reply'**
  String get reply;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get delete;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'restore'**
  String get restore;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @banner.
  ///
  /// In en, this message translates to:
  /// **'Banner'**
  String get banner;

  /// No description provided for @display_name.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get display_name;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @matrix_user.
  ///
  /// In en, this message translates to:
  /// **'Matrix User'**
  String get matrix_user;

  /// No description provided for @sort_type.
  ///
  /// In en, this message translates to:
  /// **'Sort type'**
  String get sort_type;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @show_nsfw.
  ///
  /// In en, this message translates to:
  /// **'Show NSFW content'**
  String get show_nsfw;

  /// No description provided for @send_notifications_to_email.
  ///
  /// In en, this message translates to:
  /// **'Send notifications to Email'**
  String get send_notifications_to_email;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get delete_account;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @communities.
  ///
  /// In en, this message translates to:
  /// **'Communities'**
  String get communities;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @hot.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hot;

  /// No description provided for @new_.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_;

  /// No description provided for @old.
  ///
  /// In en, this message translates to:
  /// **'Old'**
  String get old;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'admin'**
  String get admin;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @not_a_mod_or_admin.
  ///
  /// In en, this message translates to:
  /// **'Not a moderator or admin.'**
  String get not_a_mod_or_admin;

  /// No description provided for @not_an_admin.
  ///
  /// In en, this message translates to:
  /// **'Not an admin.'**
  String get not_an_admin;

  /// No description provided for @couldnt_find_post.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find post.'**
  String get couldnt_find_post;

  /// No description provided for @not_logged_in.
  ///
  /// In en, this message translates to:
  /// **'Not logged in.'**
  String get not_logged_in;

  /// No description provided for @site_ban.
  ///
  /// In en, this message translates to:
  /// **'You have been banned from the site'**
  String get site_ban;

  /// No description provided for @community_ban.
  ///
  /// In en, this message translates to:
  /// **'You have been banned from this community.'**
  String get community_ban;

  /// No description provided for @downvotes_disabled.
  ///
  /// In en, this message translates to:
  /// **'Downvotes disabled'**
  String get downvotes_disabled;

  /// No description provided for @invalid_url.
  ///
  /// In en, this message translates to:
  /// **'Invalid URL.'**
  String get invalid_url;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get locked;

  /// No description provided for @couldnt_create_comment.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create comment.'**
  String get couldnt_create_comment;

  /// No description provided for @couldnt_like_comment.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t like comment.'**
  String get couldnt_like_comment;

  /// No description provided for @couldnt_update_comment.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update comment.'**
  String get couldnt_update_comment;

  /// No description provided for @no_comment_edit_allowed.
  ///
  /// In en, this message translates to:
  /// **'Not allowed to edit comment.'**
  String get no_comment_edit_allowed;

  /// No description provided for @couldnt_save_comment.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save comment.'**
  String get couldnt_save_comment;

  /// No description provided for @couldnt_get_comments.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get comments.'**
  String get couldnt_get_comments;

  /// No description provided for @report_reason_required.
  ///
  /// In en, this message translates to:
  /// **'Report reason required.'**
  String get report_reason_required;

  /// No description provided for @report_too_long.
  ///
  /// In en, this message translates to:
  /// **'Report too long.'**
  String get report_too_long;

  /// No description provided for @couldnt_create_report.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create report.'**
  String get couldnt_create_report;

  /// No description provided for @couldnt_resolve_report.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t resolve report.'**
  String get couldnt_resolve_report;

  /// No description provided for @invalid_post_title.
  ///
  /// In en, this message translates to:
  /// **'Invalid post title'**
  String get invalid_post_title;

  /// No description provided for @couldnt_create_post.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create post.'**
  String get couldnt_create_post;

  /// No description provided for @couldnt_like_post.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t like post.'**
  String get couldnt_like_post;

  /// No description provided for @couldnt_find_community.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find community.'**
  String get couldnt_find_community;

  /// No description provided for @couldnt_get_posts.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get posts'**
  String get couldnt_get_posts;

  /// No description provided for @no_post_edit_allowed.
  ///
  /// In en, this message translates to:
  /// **'Not allowed to edit post.'**
  String get no_post_edit_allowed;

  /// No description provided for @couldnt_save_post.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save post.'**
  String get couldnt_save_post;

  /// No description provided for @site_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Site already exists.'**
  String get site_already_exists;

  /// No description provided for @couldnt_update_site.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update site.'**
  String get couldnt_update_site;

  /// No description provided for @invalid_community_name.
  ///
  /// In en, this message translates to:
  /// **'Invalid name.'**
  String get invalid_community_name;

  /// No description provided for @community_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Community already exists.'**
  String get community_already_exists;

  /// No description provided for @community_moderator_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Community moderator already exists.'**
  String get community_moderator_already_exists;

  /// No description provided for @community_follower_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Community follower already exists.'**
  String get community_follower_already_exists;

  /// No description provided for @not_a_moderator.
  ///
  /// In en, this message translates to:
  /// **'Not a moderator.'**
  String get not_a_moderator;

  /// No description provided for @couldnt_update_community.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update Community.'**
  String get couldnt_update_community;

  /// No description provided for @no_community_edit_allowed.
  ///
  /// In en, this message translates to:
  /// **'Not allowed to edit community.'**
  String get no_community_edit_allowed;

  /// No description provided for @system_err_login.
  ///
  /// In en, this message translates to:
  /// **'System error. Try logging out and back in.'**
  String get system_err_login;

  /// No description provided for @community_user_already_banned.
  ///
  /// In en, this message translates to:
  /// **'Community user already banned.'**
  String get community_user_already_banned;

  /// No description provided for @couldnt_find_that_username_or_email.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find that username or email.'**
  String get couldnt_find_that_username_or_email;

  /// No description provided for @password_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Password incorrect.'**
  String get password_incorrect;

  /// No description provided for @registration_closed.
  ///
  /// In en, this message translates to:
  /// **'Registration closed'**
  String get registration_closed;

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid password. Password must be <= 60 characters.'**
  String get invalid_password;

  /// No description provided for @passwords_dont_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwords_dont_match;

  /// No description provided for @captcha_incorrect.
  ///
  /// In en, this message translates to:
  /// **'Captcha incorrect.'**
  String get captcha_incorrect;

  /// No description provided for @invalid_username.
  ///
  /// In en, this message translates to:
  /// **'Invalid username.'**
  String get invalid_username;

  /// No description provided for @bio_length_overflow.
  ///
  /// In en, this message translates to:
  /// **'User bio cannot exceed 300 characters.'**
  String get bio_length_overflow;

  /// No description provided for @couldnt_update_user.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update user.'**
  String get couldnt_update_user;

  /// No description provided for @couldnt_update_private_message.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update private message.'**
  String get couldnt_update_private_message;

  /// No description provided for @couldnt_update_post.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t update post'**
  String get couldnt_update_post;

  /// No description provided for @couldnt_create_private_message.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create private message.'**
  String get couldnt_create_private_message;

  /// No description provided for @no_private_message_edit_allowed.
  ///
  /// In en, this message translates to:
  /// **'Not allowed to edit private message.'**
  String get no_private_message_edit_allowed;

  /// No description provided for @post_title_too_long.
  ///
  /// In en, this message translates to:
  /// **'Post title too long.'**
  String get post_title_too_long;

  /// No description provided for @email_already_exists.
  ///
  /// In en, this message translates to:
  /// **'Email already exists.'**
  String get email_already_exists;

  /// No description provided for @user_already_exists.
  ///
  /// In en, this message translates to:
  /// **'User already exists.'**
  String get user_already_exists;

  /// No description provided for @number_of_users_online.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} user online} other{{count} users online}}'**
  String number_of_users_online(int count);

  /// No description provided for @number_of_comments.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} comment} other{{count} comments}}'**
  String number_of_comments(int count);

  /// No description provided for @number_of_posts.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} post} other{{count} posts}}'**
  String number_of_posts(int count);

  /// No description provided for @number_of_subscribers.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} subscriber} other{{count} subscribers}}'**
  String number_of_subscribers(int count);

  /// No description provided for @number_of_users.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{{count} user} other{{count} users}}'**
  String number_of_users(int count);

  /// No description provided for @unsubscribe.
  ///
  /// In en, this message translates to:
  /// **'unsubscribe'**
  String get unsubscribe;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'subscribe'**
  String get subscribe;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @banned_users.
  ///
  /// In en, this message translates to:
  /// **'Banned users'**
  String get banned_users;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Warning: this will permanently delete all your data. Enter your password to confirm.'**
  String get delete_account_confirm;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @verify_password.
  ///
  /// In en, this message translates to:
  /// **'Verify password'**
  String get verify_password;

  /// No description provided for @old_password.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get old_password;

  /// No description provided for @show_avatars.
  ///
  /// In en, this message translates to:
  /// **'Show avatars'**
  String get show_avatars;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'search'**
  String get search;

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get send_message;

  /// No description provided for @top_day.
  ///
  /// In en, this message translates to:
  /// **'Top Day'**
  String get top_day;

  /// No description provided for @top_week.
  ///
  /// In en, this message translates to:
  /// **'Top Week'**
  String get top_week;

  /// No description provided for @top_month.
  ///
  /// In en, this message translates to:
  /// **'Top Month'**
  String get top_month;

  /// No description provided for @top_year.
  ///
  /// In en, this message translates to:
  /// **'Top Year'**
  String get top_year;

  /// No description provided for @top_all.
  ///
  /// In en, this message translates to:
  /// **'Top All Time'**
  String get top_all;

  /// No description provided for @most_comments.
  ///
  /// In en, this message translates to:
  /// **'Most Comments'**
  String get most_comments;

  /// No description provided for @new_comments.
  ///
  /// In en, this message translates to:
  /// **'New Comments'**
  String get new_comments;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @bot_account.
  ///
  /// In en, this message translates to:
  /// **'Bot Account'**
  String get bot_account;

  /// No description provided for @show_bot_accounts.
  ///
  /// In en, this message translates to:
  /// **'Show Bot Accounts'**
  String get show_bot_accounts;

  /// No description provided for @show_read_posts.
  ///
  /// In en, this message translates to:
  /// **'Show Read Posts'**
  String get show_read_posts;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bg',
        'ca',
        'da',
        'de',
        'el',
        'en',
        'eo',
        'es',
        'eu',
        'fa',
        'fi',
        'fr',
        'ga',
        'gl',
        'hi',
        'hr',
        'hu',
        'it',
        'ja',
        'ka',
        'km',
        'ko',
        'nb',
        'nl',
        'oc',
        'pl',
        'pt',
        'ru',
        'sq',
        'sr',
        'sv',
        'th',
        'tr',
        'uk',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'sr':
      {
        switch (locale.scriptCode) {
          case 'Latn':
            return L10nSrLatn();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return L10nZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'nb':
      {
        switch (locale.countryCode) {
          case 'NO':
            return L10nNbNo();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return L10nPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'bg':
      return L10nBg();
    case 'ca':
      return L10nCa();
    case 'da':
      return L10nDa();
    case 'de':
      return L10nDe();
    case 'el':
      return L10nEl();
    case 'en':
      return L10nEn();
    case 'eo':
      return L10nEo();
    case 'es':
      return L10nEs();
    case 'eu':
      return L10nEu();
    case 'fa':
      return L10nFa();
    case 'fi':
      return L10nFi();
    case 'fr':
      return L10nFr();
    case 'ga':
      return L10nGa();
    case 'gl':
      return L10nGl();
    case 'hi':
      return L10nHi();
    case 'hr':
      return L10nHr();
    case 'hu':
      return L10nHu();
    case 'it':
      return L10nIt();
    case 'ja':
      return L10nJa();
    case 'ka':
      return L10nKa();
    case 'km':
      return L10nKm();
    case 'ko':
      return L10nKo();
    case 'nb':
      return L10nNb();
    case 'nl':
      return L10nNl();
    case 'oc':
      return L10nOc();
    case 'pl':
      return L10nPl();
    case 'pt':
      return L10nPt();
    case 'ru':
      return L10nRu();
    case 'sq':
      return L10nSq();
    case 'sr':
      return L10nSr();
    case 'sv':
      return L10nSv();
    case 'th':
      return L10nTh();
    case 'tr':
      return L10nTr();
    case 'uk':
      return L10nUk();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
      'L10n.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

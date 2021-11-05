import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get settings => 'الإعدادات';

  @override
  String get password => 'الكلمة السرية';

  @override
  String get email_or_username => 'عنوان البريد أو اسم المستخدم';

  @override
  String get posts => 'منشورات';

  @override
  String get comments => 'التعليقات';

  @override
  String get modlog => 'تأريخ الإشراف';

  @override
  String get community => 'المجتمع';

  @override
  String get url => 'الرابط';

  @override
  String get title => 'العنوان';

  @override
  String get body => 'المحتوى';

  @override
  String get nsfw => 'محتوى حساس';

  @override
  String get post => 'منشور';

  @override
  String get save => 'حفظ';

  @override
  String get subscribed => 'مُتابِعون';

  @override
  String get local => 'محلي';

  @override
  String get all => 'الكل';

  @override
  String get replies => 'الإجابات';

  @override
  String get mentions => 'الإشارات';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get deleted_by_creator => 'حذفه صاحبه';

  @override
  String get more => 'المزيد';

  @override
  String get mark_as_read => 'تعيين كمقروء';

  @override
  String get mark_as_unread => 'تعيين كغير مقروء بعد';

  @override
  String get reply => 'رد';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get restore => 'استعادة';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get avatar => 'الصورة الرمزية';

  @override
  String get banner => 'اللافتة';

  @override
  String get display_name => 'الاسم';

  @override
  String get bio => 'السيرة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get matrix_user => 'مستخدم ماتريكس';

  @override
  String get sort_type => 'ترتيب حسب';

  @override
  String get type => 'النوع';

  @override
  String get show_nsfw => 'إظهار المحتوى الحساس';

  @override
  String get send_notifications_to_email =>
      'إرسال الإشعارات عبر البريد الإلكتروني';

  @override
  String get delete_account => 'حذف الحساب';

  @override
  String get saved => 'تم حفظه';

  @override
  String get communities => 'المجتمعات';

  @override
  String get users => 'المستخدِمون';

  @override
  String get theme => 'المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get hot => 'المتداولة';

  @override
  String get new_ => 'جديد';

  @override
  String get old => 'قديم';

  @override
  String get top => 'المتداولة';

  @override
  String get chat => 'دردشة';

  @override
  String get admin => 'مدير';

  @override
  String get by => 'مِن';

  @override
  String get not_a_mod_or_admin => 'ليس مشرفًا ولا مديرًا.';

  @override
  String get not_an_admin => 'لستَ مديرا.';

  @override
  String get couldnt_find_post => 'تعذر العثور على المشاركة.';

  @override
  String get not_logged_in => 'لستَ متصلا.';

  @override
  String get site_ban => 'لقد تم طردك مِن هذا الموقع';

  @override
  String get community_ban => 'لقد تم طردك مِن هذا المجتمع.';

  @override
  String get downvotes_disabled => 'تم تعطيل التصويتات السلبية';

  @override
  String get invalid_url => 'الرابط غير صالح.';

  @override
  String get locked => 'محظور';

  @override
  String get couldnt_create_comment => 'تعذّر إنشاءالتعليق.';

  @override
  String get couldnt_like_comment => 'تعذر الإعجاب بالتعليق.';

  @override
  String get couldnt_update_comment => 'تعذر تحديث التعليق.';

  @override
  String get no_comment_edit_allowed => 'لا يُسمح لك تعديل التعليق.';

  @override
  String get couldnt_save_comment => 'تعذر حفظ التعليق.';

  @override
  String get couldnt_get_comments => 'تعذر جلب التعليق.';

  @override
  String get report_reason_required => 'سبب الإبلاغ مطلوب.';

  @override
  String get report_too_long => 'تقرير الإبلاغ طويل.';

  @override
  String get couldnt_create_report => 'تعذر إتشاء التقرير.';

  @override
  String get couldnt_resolve_report => 'تعذر تحليل.';

  @override
  String get invalid_post_title => 'عنوان المنشور غير';

  @override
  String get couldnt_create_post => 'تعذر انشاء المشاركة.';

  @override
  String get couldnt_like_post => 'تعذر الإعجاب بالمنشور.';

  @override
  String get couldnt_find_community => 'تعذر العثور على المجتمع.';

  @override
  String get couldnt_get_posts => 'تعذر جلب المشاركات';

  @override
  String get no_post_edit_allowed => 'لا يسمح لك تعديل المشاركة.';

  @override
  String get couldnt_save_post => 'تعذر حفظ المشاركة.';

  @override
  String get site_already_exists => 'الموقع موجود.';

  @override
  String get couldnt_update_site => 'تعذر تحديث الموقع.';

  @override
  String get invalid_community_name => 'اسم غير صالح.';

  @override
  String get community_already_exists => 'المجتمع موجود مسبقًا.';

  @override
  String get community_moderator_already_exists =>
      'مشىرف المجتمع موجود مسبقًا.';

  @override
  String get community_follower_already_exists =>
      'هذا العضو مشترك في المجمع مسبقا.';

  @override
  String get not_a_moderator => 'ليس مشرفًا.';

  @override
  String get couldnt_update_community => 'تعذر تحديث المجتمع.';

  @override
  String get no_community_edit_allowed => 'لا يُسمح لك تعديل المجتمع.';

  @override
  String get system_err_login => 'خطأ في النظام. جرب إعادة الولوج.';

  @override
  String get community_user_already_banned => 'هذا العضو محضور مسبقا.';

  @override
  String get couldnt_find_that_username_or_email =>
      'تعذر العثور على مستخدم يملك هذا البريد أو اسم المستخدم.';

  @override
  String get password_incorrect => 'الكلمة السرية خاطئة.';

  @override
  String get registration_closed => 'إنشاء الحسابات معطل';

  @override
  String get invalid_password =>
      'كلمة المرور غير صالحة. يجب ألّا تزيد عن 60 محرفًا.';

  @override
  String get passwords_dont_match => 'الكلمات السرية غير متطابقة.';

  @override
  String get captcha_incorrect => 'رمز التحقق خاطئ.';

  @override
  String get invalid_username => 'اسم المستخدم غير صالح.';

  @override
  String get bio_length_overflow => 'لا يمكن أن تزيد السيرة عن 300 محرف.';

  @override
  String get couldnt_update_user => 'Couldn\'t update user.';

  @override
  String get couldnt_update_private_message => 'تعذر تحديث الرسالة الخاصة.';

  @override
  String get couldnt_update_post => 'تعذر تحديث';

  @override
  String get couldnt_create_private_message => 'تعذر انشاء الرسالة الخاصة.';

  @override
  String get no_private_message_edit_allowed =>
      'لا يسمح لك تعديل الرسالة الخاصة.';

  @override
  String get post_title_too_long => 'عنوان المشاركة طويل.';

  @override
  String get email_already_exists =>
      'عنوان البريد الإلكتروني هذا موجود بالفعل.';

  @override
  String get user_already_exists => 'هذا المستخدِم موجود بالفعل.';

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
  String get unsubscribe => 'الغ الإشتراك';

  @override
  String get subscribe => 'اتبع';

  @override
  String get messages => 'لرسائل';

  @override
  String get banned_users => 'المستخدمون المحظورون';

  @override
  String get delete_account_confirm =>
      'تحذير: ستحذف جميع بياناتك. أدخل كلمة المرور لتأكيد.';

  @override
  String get new_password => 'لكلمة السرية الجديدة';

  @override
  String get verify_password => 'تأكيد الكلمة السرية';

  @override
  String get old_password => 'الكلمة السرية القديمة';

  @override
  String get show_avatars => 'إظهار الصور الرمزية';

  @override
  String get search => 'البحث';

  @override
  String get send_message => 'أرسل الرسالة';

  @override
  String get top_day => 'المتداول';

  @override
  String get top_week => 'المتداول هذا';

  @override
  String get top_month => 'المتداول هذا';

  @override
  String get top_year => 'المتداول هذه';

  @override
  String get top_all => 'المتداولة';

  @override
  String get most_comments => 'الأكثر';

  @override
  String get new_comments => 'الأحدث';

  @override
  String get active => 'النشط';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

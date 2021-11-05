import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Turkish (`tr`).
class L10nTr extends L10n {
  L10nTr([String locale = 'tr']) : super(locale);

  @override
  String get settings => 'Ayarlar';

  @override
  String get password => 'Şifre';

  @override
  String get email_or_username => 'E-mail ya da Kullanıcı Adı';

  @override
  String get posts => 'Paylaşımlar';

  @override
  String get comments => 'Yorumlar';

  @override
  String get modlog => 'İdare geçmişi';

  @override
  String get community => 'Topluluk';

  @override
  String get url => 'URL';

  @override
  String get title => 'Başlık';

  @override
  String get body => 'Metin';

  @override
  String get nsfw => 'Müstehcen';

  @override
  String get post => 'paylaşım';

  @override
  String get save => 'kaydet';

  @override
  String get subscribed => 'Takibe alındı';

  @override
  String get local => 'Local';

  @override
  String get all => 'Hepsi';

  @override
  String get replies => 'Cevaplar';

  @override
  String get mentions => 'Bahisler';

  @override
  String get from => 'tarafından';

  @override
  String get to => 'tarafına';

  @override
  String get deleted_by_creator => 'yazarı tarafından silindi';

  @override
  String get more => 'dahası';

  @override
  String get mark_as_read => 'okunmuş olarak işaretle';

  @override
  String get mark_as_unread => 'okunmamış olarak işaretle';

  @override
  String get reply => 'cevapla';

  @override
  String get edit => 'düzenle';

  @override
  String get delete => 'sil';

  @override
  String get restore => 'geri al';

  @override
  String get yes => 'evet';

  @override
  String get no => 'hayır';

  @override
  String get avatar => 'Avatar';

  @override
  String get banner => 'Banner';

  @override
  String get display_name => 'Display name';

  @override
  String get bio => 'Bio';

  @override
  String get email => 'E-mail';

  @override
  String get matrix_user => 'Matrix Kullanıcısı';

  @override
  String get sort_type => 'Sıralama metodu';

  @override
  String get type => 'Tür';

  @override
  String get show_nsfw => 'Müstehcen içerikleri göster';

  @override
  String get send_notifications_to_email => 'E-maile bildirim yolla';

  @override
  String get delete_account => 'Hesabı Sil';

  @override
  String get saved => 'Kaydedildi';

  @override
  String get communities => 'Topluluklar';

  @override
  String get users => 'Kullanıcılar';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Dil';

  @override
  String get hot => 'Flaş';

  @override
  String get new_ => 'Yeni';

  @override
  String get old => 'Eski';

  @override
  String get top => 'En iyiler';

  @override
  String get chat => 'Sohbet';

  @override
  String get admin => 'baş idareci';

  @override
  String get by => 'tarafından';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => 'Baş idareci değil.';

  @override
  String get couldnt_find_post => 'Paylaşım bulunamadı.';

  @override
  String get not_logged_in => 'Hesaba giriş yapılmamış.';

  @override
  String get site_ban => 'Bu siteden yasaklandınız';

  @override
  String get community_ban => 'Bu topluluğa yazmanız yasaklandı.';

  @override
  String get downvotes_disabled => 'Eksi puan verme özelliği kaldırıldı';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => 'kilitlendi';

  @override
  String get couldnt_create_comment => 'Yorum yapılamadı.';

  @override
  String get couldnt_like_comment => 'Yorum beğenilemedi.';

  @override
  String get couldnt_update_comment => 'Yorum güncellenemedi.';

  @override
  String get no_comment_edit_allowed => 'Yorumu düzenleme izniniz yok.';

  @override
  String get couldnt_save_comment => 'Yorum kaydedilemedi.';

  @override
  String get couldnt_get_comments => 'Yorumlar yüklenemedi.';

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
  String get couldnt_create_post => 'Paylaşım yapılamadı.';

  @override
  String get couldnt_like_post => 'Paylaşım beğenilemedi.';

  @override
  String get couldnt_find_community => 'Topluluk bulunamadı.';

  @override
  String get couldnt_get_posts => 'Paylaşımlar yüklenemedi';

  @override
  String get no_post_edit_allowed => 'Paylaşımı düzenleme izniniz yok.';

  @override
  String get couldnt_save_post => 'Paylaşım kaydedilemedi.';

  @override
  String get site_already_exists => 'Bu site zaten var.';

  @override
  String get couldnt_update_site => 'Site güncellenemedi.';

  @override
  String get invalid_community_name => 'Hatalı ad.';

  @override
  String get community_already_exists => 'Böyle bir topluluk zaten var.';

  @override
  String get community_moderator_already_exists =>
      'Bu kullanıcı zaten bu topluluğun bir idarecisi.';

  @override
  String get community_follower_already_exists =>
      'Topluluğun böyle bir takipçisi zaten var.';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community => 'Topluluk bilgisi güncellenemedi.';

  @override
  String get no_community_edit_allowed => 'Topluluğu düzenleme yetkiniz yok.';

  @override
  String get system_err_login =>
      'Sistem hatası. Hesaptan çıkıp tekrar girmeyi deneyin.';

  @override
  String get community_user_already_banned =>
      'Bu kullanıcı zaten bu toplulukta yasaklı.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Böyle bir e-mail ya da kullanıcı adı bulunamadı.';

  @override
  String get password_incorrect => 'Şifre yanlış.';

  @override
  String get registration_closed => 'Kayıt kapalı';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'Şifreler eşleşmiyor.';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Hatalı kullanıcı adı.';

  @override
  String get bio_length_overflow => 'User bio cannot exceed 300 characters.';

  @override
  String get couldnt_update_user => 'Kullanıcı bilgisi güncellenemedi.';

  @override
  String get couldnt_update_private_message =>
      'Şahsa özel mesaj güncellenemedi.';

  @override
  String get couldnt_update_post => 'Paylaşım güncellenemedi';

  @override
  String get couldnt_create_private_message => 'Şahsa özel mesaj yaratılamadı.';

  @override
  String get no_private_message_edit_allowed =>
      'Şahsa özel mesajı düzenlemek mümkün değil.';

  @override
  String get post_title_too_long => 'Paylaşım başlığı çok uzun.';

  @override
  String get email_already_exists => 'Böyle bir e-mail adresi zaten var.';

  @override
  String get user_already_exists => 'Böyle bir kullanıcı zaten var.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Kullanıcı Hatta',
      other: '$count Kullanıcı Hatta',
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
      one: '$countString Yorum',
      other: '$countString Yorum',
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
      one: '$countString Paylaşım',
      other: '$countString Paylaşım',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Takipçi',
      other: '$count Takipçi',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count Kullanıcı',
      other: '$count Kullanıcı',
    );
  }

  @override
  String get unsubscribe => 'Takibi bırak';

  @override
  String get subscribe => 'Takip et';

  @override
  String get messages => 'Mesajlar';

  @override
  String get banned_users => 'Yasaklanmış Kullanıcılar';

  @override
  String get delete_account_confirm =>
      'Uyarı: Devam etmek bütün verilerinizi kalıcı olarak silecektir. Onaylamak için şifrenizi girin.';

  @override
  String get new_password => 'Yeni şifre';

  @override
  String get verify_password => 'Şifreyi doğrulayın';

  @override
  String get old_password => 'Eski şifre';

  @override
  String get show_avatars => 'Avatarları Göster';

  @override
  String get search => 'Ara';

  @override
  String get send_message => 'Mesaj Yolla';

  @override
  String get top_day => 'Günün en iyileri';

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

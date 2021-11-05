import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get settings => '設定';

  @override
  String get password => 'パスワード';

  @override
  String get email_or_username => 'メールアドレスまたはユーザー名';

  @override
  String get posts => '投稿';

  @override
  String get comments => 'コメント';

  @override
  String get modlog => 'モデレーションログ';

  @override
  String get community => 'コミュニティ';

  @override
  String get url => 'URL';

  @override
  String get title => 'タイトル';

  @override
  String get body => '本文';

  @override
  String get nsfw => '閲覧注意';

  @override
  String get post => '投稿';

  @override
  String get save => '保存';

  @override
  String get subscribed => '登録済み';

  @override
  String get local => 'Local';

  @override
  String get all => '全て';

  @override
  String get replies => '返信';

  @override
  String get mentions => '言及';

  @override
  String get from => 'から';

  @override
  String get to => '宛先';

  @override
  String get deleted_by_creator => '削除済み';

  @override
  String get more => 'さらに表示';

  @override
  String get mark_as_read => '既読にする';

  @override
  String get mark_as_unread => '未読にする';

  @override
  String get reply => '返信';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get restore => '復元';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get avatar => 'アバター';

  @override
  String get banner => 'バナー';

  @override
  String get display_name => '表示名';

  @override
  String get bio => '自己紹介';

  @override
  String get email => 'メールアドレス';

  @override
  String get matrix_user => 'Matrix のユーザーアカウント';

  @override
  String get sort_type => '並び順の種類';

  @override
  String get type => '種類';

  @override
  String get show_nsfw => '閲覧注意のコンテンツを表示';

  @override
  String get send_notifications_to_email => '通知をメール送信';

  @override
  String get delete_account => 'アカウントを削除';

  @override
  String get saved => '保存済み';

  @override
  String get communities => 'コミュニティ';

  @override
  String get users => 'ユーザー';

  @override
  String get theme => 'テーマ';

  @override
  String get language => '言語';

  @override
  String get hot => '人気';

  @override
  String get new_ => '新しい順';

  @override
  String get old => '古い順';

  @override
  String get top => 'トップ';

  @override
  String get chat => '会話';

  @override
  String get admin => '管理者';

  @override
  String get by => '投稿者';

  @override
  String get not_a_mod_or_admin => 'Not a moderator or admin.';

  @override
  String get not_an_admin => '管理者ではありません。';

  @override
  String get couldnt_find_post => '投稿が見付かりません。';

  @override
  String get not_logged_in => 'ログインしていません。';

  @override
  String get site_ban => 'サイトへのアクセスを禁止されています';

  @override
  String get community_ban => 'このコミュニティへのアクセスを禁止されています。';

  @override
  String get downvotes_disabled => '反対票を無効化';

  @override
  String get invalid_url => 'Invalid URL.';

  @override
  String get locked => '凍結中';

  @override
  String get couldnt_create_comment => '投稿を作成できませんでした。';

  @override
  String get couldnt_like_comment => 'コメントが「いいね」できない。';

  @override
  String get couldnt_update_comment => 'コメントが更新されない。';

  @override
  String get no_comment_edit_allowed => 'コメントの編集権限がありません。';

  @override
  String get couldnt_save_comment => 'コメントが保存されない。';

  @override
  String get couldnt_get_comments => 'コメントが取得されない。';

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
  String get couldnt_create_post => '投稿ができない。';

  @override
  String get couldnt_like_post => '投稿が「いいね」できない。';

  @override
  String get couldnt_find_community => 'コミュニティが見付かりません。';

  @override
  String get couldnt_get_posts => '投稿が取得できない';

  @override
  String get no_post_edit_allowed => '投稿の編集権限がありません。';

  @override
  String get couldnt_save_post => '投稿が保存されない。';

  @override
  String get site_already_exists => 'サイトは既に存在します。';

  @override
  String get couldnt_update_site => 'サイトが更新されない。';

  @override
  String get invalid_community_name => '無効な名前です。';

  @override
  String get community_already_exists => 'コミュニティは既に存在します。';

  @override
  String get community_moderator_already_exists => 'コミュニティ管理人は既に存在します。';

  @override
  String get community_follower_already_exists => 'コミュニティフォロワーは既に存在します。';

  @override
  String get not_a_moderator => 'Not a moderator.';

  @override
  String get couldnt_update_community => 'コミュニティが更新されない。';

  @override
  String get no_community_edit_allowed => 'コミュニティの編集許可がありません。';

  @override
  String get system_err_login => 'システムエラーが発生しました。一度ログアウトして、再度ログインをお試しください。';

  @override
  String get community_user_already_banned => 'コミュニティユーザーは既に禁止されています。';

  @override
  String get couldnt_find_that_username_or_email => 'ユーザー名またはメールアドレスが見付かりません。';

  @override
  String get password_incorrect => 'パスワードが不正です。';

  @override
  String get registration_closed => '登録は受け付けていません';

  @override
  String get invalid_password =>
      'Invalid password. Password must be <= 60 characters.';

  @override
  String get passwords_dont_match => 'パスワードが一致しません。';

  @override
  String get captcha_incorrect => 'Captcha incorrect.';

  @override
  String get invalid_username => 'Invalid username.';

  @override
  String get bio_length_overflow => '自己紹介は 300 文字までです。';

  @override
  String get couldnt_update_user => 'ユーザーが更新されない。';

  @override
  String get couldnt_update_private_message => 'プライベートメッセージが更新されない。';

  @override
  String get couldnt_update_post => '投稿が更新されない';

  @override
  String get couldnt_create_private_message => 'プライベートメッセージが作成されない。';

  @override
  String get no_private_message_edit_allowed => 'プライベートメッセージの編集許可がありません。';

  @override
  String get post_title_too_long => '投稿のタイトルが長すぎます。';

  @override
  String get email_already_exists => 'メールアドレスが既に使用されています。';

  @override
  String get user_already_exists => 'ユーザーは既に存在します。';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 名のユーザーがオンライン',
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
      other: '$countString 件のコメント',
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
      other: '$countString 件の投稿',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 名の登録者',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 名のユーザー',
    );
  }

  @override
  String get unsubscribe => '登録解除';

  @override
  String get subscribe => '登録';

  @override
  String get messages => 'メッセージ';

  @override
  String get banned_users => 'Banned users';

  @override
  String get delete_account_confirm =>
      '警告: あなたのデータを全て恒久的に削除します。確認のためパスワードを入力してください。';

  @override
  String get new_password => '新しいパスワード';

  @override
  String get verify_password => 'パスワードの確認';

  @override
  String get old_password => '現在のパスワード';

  @override
  String get show_avatars => 'アバターを表示';

  @override
  String get search => '検索';

  @override
  String get send_message => 'メッセージを送信';

  @override
  String get top_day => '日間トップ';

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
  String get active => '活発さ';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

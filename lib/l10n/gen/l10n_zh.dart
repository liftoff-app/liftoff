import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Chinese (`zh`).
class L10nZh extends L10n {
  L10nZh([String locale = 'zh']) : super(locale);

  @override
  String get settings => '设置';

  @override
  String get password => '密码';

  @override
  String get email_or_username => '邮箱或用户名';

  @override
  String get posts => '帖子';

  @override
  String get comments => '评论';

  @override
  String get modlog => '管理记录';

  @override
  String get community => '社群';

  @override
  String get url => '相关网址';

  @override
  String get title => '标语';

  @override
  String get body => '内容';

  @override
  String get nsfw => '工作场所不宜';

  @override
  String get post => '回帖';

  @override
  String get save => '保存';

  @override
  String get subscribed => '已订阅';

  @override
  String get local => '本地';

  @override
  String get all => '所有';

  @override
  String get replies => '回复';

  @override
  String get mentions => '提到';

  @override
  String get from => '由';

  @override
  String get to => '发布到';

  @override
  String get deleted_by_creator => '作者已删除';

  @override
  String get more => '更多';

  @override
  String get mark_as_read => '标记为已读';

  @override
  String get mark_as_unread => '标记为未读';

  @override
  String get reply => '回复';

  @override
  String get edit => '编辑';

  @override
  String get delete => '删除';

  @override
  String get restore => '恢复';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get avatar => '头像';

  @override
  String get banner => '横幅';

  @override
  String get display_name => '显示名称';

  @override
  String get bio => '简介';

  @override
  String get email => '邮箱';

  @override
  String get matrix_user => 'Matrix用户';

  @override
  String get sort_type => '排序方式';

  @override
  String get type => '类型';

  @override
  String get show_nsfw => '显示工作场所不宜内容';

  @override
  String get send_notifications_to_email => '向邮箱发送通知';

  @override
  String get delete_account => '删除账号';

  @override
  String get saved => '保存';

  @override
  String get communities => '社群';

  @override
  String get users => '用户';

  @override
  String get theme => '主题';

  @override
  String get language => '语言';

  @override
  String get hot => '最热';

  @override
  String get new_ => '最新';

  @override
  String get old => '最早';

  @override
  String get top => '推荐';

  @override
  String get chat => '聊天';

  @override
  String get admin => '总管理员';

  @override
  String get by => ' ';

  @override
  String get not_a_mod_or_admin => '不是仲裁员或管理员。';

  @override
  String get not_an_admin => '不是管理员。';

  @override
  String get couldnt_find_post => '无法找到帖子。';

  @override
  String get not_logged_in => '未登录。';

  @override
  String get site_ban => '你已被本站拉黑';

  @override
  String get community_ban => '你已被此社群拉黑。';

  @override
  String get downvotes_disabled => '踩已禁用';

  @override
  String get invalid_url => 'URL无效。';

  @override
  String get locked => '已锁定';

  @override
  String get couldnt_create_comment => '无法创建评论。';

  @override
  String get couldnt_like_comment => '无法点赞评论。';

  @override
  String get couldnt_update_comment => '无法更新评论。';

  @override
  String get no_comment_edit_allowed => '没有编辑评论的权限。';

  @override
  String get couldnt_save_comment => '无法保存评论。';

  @override
  String get couldnt_get_comments => '无法获取评论。';

  @override
  String get report_reason_required => '需要报告原因。';

  @override
  String get report_too_long => '报告时间过长。';

  @override
  String get couldnt_create_report => '无法创建报告。';

  @override
  String get couldnt_resolve_report => '无法解析报告。';

  @override
  String get invalid_post_title => '帖子标题无效';

  @override
  String get couldnt_create_post => '无法创建帖子。';

  @override
  String get couldnt_like_post => '无法点赞帖子。';

  @override
  String get couldnt_find_community => '无法找到社群。';

  @override
  String get couldnt_get_posts => '无法获取帖子';

  @override
  String get no_post_edit_allowed => '没有编辑帖子的权限。';

  @override
  String get couldnt_save_post => '无法保存帖子。';

  @override
  String get site_already_exists => '站点已存在。';

  @override
  String get couldnt_update_site => '无法更新站点。';

  @override
  String get invalid_community_name => '无效名称。';

  @override
  String get community_already_exists => '社群已存在。';

  @override
  String get community_moderator_already_exists => '社群监管人已存在。';

  @override
  String get community_follower_already_exists => '社群关注者已存在。';

  @override
  String get not_a_moderator => '不是仲裁员。';

  @override
  String get couldnt_update_community => '无法更新社群。';

  @override
  String get no_community_edit_allowed => '没有编辑社群的权限。';

  @override
  String get system_err_login => '系统错误。请尝试注销后重新登入。';

  @override
  String get community_user_already_banned => '社群用户已被禁止。';

  @override
  String get couldnt_find_that_username_or_email => '用户名/邮箱不存在。';

  @override
  String get password_incorrect => '密码不正确。';

  @override
  String get registration_closed => '注册功能已关闭';

  @override
  String get invalid_password => '密码无效。密码长度必须小于60个字符。';

  @override
  String get passwords_dont_match => '密码不匹配。';

  @override
  String get captcha_incorrect => '验证码不正确。';

  @override
  String get invalid_username => '用户名无效。';

  @override
  String get bio_length_overflow => '自我介绍不能超过300个字符。';

  @override
  String get couldnt_update_user => '无法更新用户。';

  @override
  String get couldnt_update_private_message => '无法更新私信。';

  @override
  String get couldnt_update_post => '无法更新帖子';

  @override
  String get couldnt_create_private_message => '无法创建私信。';

  @override
  String get no_private_message_edit_allowed => '没有编辑私信的权限。';

  @override
  String get post_title_too_long => '帖子标题过长。';

  @override
  String get email_already_exists => '邮箱已占用。';

  @override
  String get user_already_exists => '用户已存在。';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count 在线用户',
      other: '$count 名在线用户',
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
      one: '$countString 条评论',
      other: '$countString 条评论',
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
      one: '$countString 个帖子',
      other: '$countString 条帖子',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count 订阅者',
      other: '$count 名订阅者',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count 用户',
      other: '$count 名用户',
    );
  }

  @override
  String get unsubscribe => '取消订阅';

  @override
  String get subscribe => '订阅';

  @override
  String get messages => '信息';

  @override
  String get banned_users => '被禁止用户';

  @override
  String get delete_account_confirm => '警告:此操作将永久删除你的数据，请输入密码进行确认。';

  @override
  String get new_password => '新密码';

  @override
  String get verify_password => '确认密码';

  @override
  String get old_password => '当前密码';

  @override
  String get show_avatars => '显示头像';

  @override
  String get search => '搜索';

  @override
  String get send_message => '发送消息';

  @override
  String get top_day => '日推荐';

  @override
  String get top_week => '周推荐';

  @override
  String get top_month => '月推荐';

  @override
  String get top_year => '年推荐';

  @override
  String get top_all => '全部推荐';

  @override
  String get most_comments => '最多评论';

  @override
  String get new_comments => '新评论';

  @override
  String get active => '活跃';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class L10nZhHant extends L10nZh {
  L10nZhHant() : super('zh_Hant');

  @override
  String get posts => '貼文';

  @override
  String get comments => '評論';

  @override
  String get post => '回文';

  @override
  String get more => '更多';

  @override
  String get reply => '回覆';

  @override
  String get edit => '編輯';

  @override
  String get avatar => '虛擬化身';

  @override
  String get banner => '橫幅';

  @override
  String get communities => '社群';

  @override
  String get users => '使用者';

  @override
  String get invalid_community_name => '無效的名稱。';

  @override
  String number_of_comments(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString 則評論',
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
      other: '$countString 個貼文',
    );
  }

  @override
  String get show_avatars => '顯示頭像';

  @override
  String get send_message => '發送私人訊息';

  @override
  String get bot_account => '機器人帳號';

  @override
  String get show_bot_accounts => '顯示機器人帳號';
}

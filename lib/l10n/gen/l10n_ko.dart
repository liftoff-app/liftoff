import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get settings => '설정';

  @override
  String get password => '비밀번호';

  @override
  String get email_or_username => '이메일 또는 유저명';

  @override
  String get posts => '게시글';

  @override
  String get comments => '덧글';

  @override
  String get modlog => '관리기록';

  @override
  String get community => '커뮤니티';

  @override
  String get url => 'URL';

  @override
  String get title => '제목';

  @override
  String get body => '내용';

  @override
  String get nsfw => '18+ 콘텐츠';

  @override
  String get post => '등록';

  @override
  String get save => '저장';

  @override
  String get subscribed => '구독';

  @override
  String get local => 'Local';

  @override
  String get all => '모두';

  @override
  String get replies => '댓글';

  @override
  String get mentions => '언급';

  @override
  String get from => '에서';

  @override
  String get to => 'to';

  @override
  String get deleted_by_creator => '글쓴이에 의해 삭제됨';

  @override
  String get more => '더 보기';

  @override
  String get mark_as_read => '읽은 상태로 표시';

  @override
  String get mark_as_unread => '읽지 않은 상태로 표시';

  @override
  String get reply => '댓글';

  @override
  String get edit => '수정';

  @override
  String get delete => '삭제';

  @override
  String get restore => '복원';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get avatar => '아바타';

  @override
  String get banner => '배너';

  @override
  String get display_name => '표시 이름';

  @override
  String get bio => '자기 소개';

  @override
  String get email => '이메일';

  @override
  String get matrix_user => '메트릭스 사용자';

  @override
  String get sort_type => '정렬';

  @override
  String get type => '유형';

  @override
  String get show_nsfw => '18+ 콘텐츠 보기';

  @override
  String get send_notifications_to_email => '이메일로 알림 보내기';

  @override
  String get delete_account => '계정 삭제';

  @override
  String get saved => '저장한글';

  @override
  String get communities => '커뮤니티';

  @override
  String get users => '유저';

  @override
  String get theme => '테마';

  @override
  String get language => '언어';

  @override
  String get hot => '인기있는';

  @override
  String get new_ => '새로운';

  @override
  String get old => '오래된';

  @override
  String get top => 'Top';

  @override
  String get chat => '대화';

  @override
  String get admin => '관리자';

  @override
  String get by => '작성';

  @override
  String get not_a_mod_or_admin => '중재자 또는 관리자가 아닙니다.';

  @override
  String get not_an_admin => '관리자가 아닙니다.';

  @override
  String get couldnt_find_post => '게시물을 찾을 수 없습니다.';

  @override
  String get not_logged_in => '로그인하지 않았습니다.';

  @override
  String get site_ban => '당신은 사이트에서 추방되었습니다';

  @override
  String get community_ban => '이 커뮤니티에서 추방되었습니다.';

  @override
  String get downvotes_disabled => '내림 비활성화';

  @override
  String get invalid_url => '잘못된 URL.';

  @override
  String get locked => '잠김';

  @override
  String get couldnt_create_comment => '덧글을 작성할 수 없습니다.';

  @override
  String get couldnt_like_comment => '덧글에 좋아요 표시를 할 수 없습니다.';

  @override
  String get couldnt_update_comment => '덧글을 업데이트 할 수 없습니다.';

  @override
  String get no_comment_edit_allowed => '덧글을 수정할 수 없습니다.';

  @override
  String get couldnt_save_comment => '덧글을 저장할 수 없습니다.';

  @override
  String get couldnt_get_comments => '덧글을 가져올 수 없습니다.';

  @override
  String get report_reason_required => '사유를 제출해야합니다.';

  @override
  String get report_too_long => '보고 글이 너무 길어요.';

  @override
  String get couldnt_create_report => '보고서를 생성할 수 없습니다.';

  @override
  String get couldnt_resolve_report => '보고서를 해결할 수 없습니다.';

  @override
  String get invalid_post_title => '잘못된 게시물 제목';

  @override
  String get couldnt_create_post => '게시물을 작성할 수 없습니다.';

  @override
  String get couldnt_like_post => '이 게시물에 좋아요 표시를 할 수 없습니다.';

  @override
  String get couldnt_find_community => '커뮤니티를 찾을 수 없습니다.';

  @override
  String get couldnt_get_posts => '게시물을 가져올 수 없습니다';

  @override
  String get no_post_edit_allowed => '게시물을 수정할 수 없습니다.';

  @override
  String get couldnt_save_post => '게시물을 저장할 수 없습니다.';

  @override
  String get site_already_exists => '사이트가 이미 존재합니다.';

  @override
  String get couldnt_update_site => '사이트를 업데이트 할 수 없습니다.';

  @override
  String get invalid_community_name => '잘못된 이름.';

  @override
  String get community_already_exists => '커뮤니티가 이미 존재합니다.';

  @override
  String get community_moderator_already_exists => '커뮤니티 운영자가 이미 존재합니다.';

  @override
  String get community_follower_already_exists => '커뮤니티 팔로어가 이미 존재합니다.';

  @override
  String get not_a_moderator => '중재자가 아닙니다.';

  @override
  String get couldnt_update_community => '커뮤니티를 업데이트 할 수 없습니다.';

  @override
  String get no_community_edit_allowed => '커뮤니티를 수정할 수 없습니다.';

  @override
  String get system_err_login => '시스템 오류. 다시 로그인하십시오.';

  @override
  String get community_user_already_banned => '커뮤니티 사용자가 이미 차단되었습니다.';

  @override
  String get couldnt_find_that_username_or_email =>
      '해당 사용자 이름이나 이메일을 찾을 수 없습니다.';

  @override
  String get password_incorrect => '잘못된 비밀번호입니다.';

  @override
  String get registration_closed => '등록 닫기';

  @override
  String get invalid_password => '잘못된 비밀번호입니다. 비밀번호는 60글자이하로 만들어야 합니다.';

  @override
  String get passwords_dont_match => '비밀번호가 일치하지 않습니다.';

  @override
  String get captcha_incorrect => '보안문자가 일치하지 않습니다.';

  @override
  String get invalid_username => '잘못된 사용자 이름.';

  @override
  String get bio_length_overflow => '자기 소개는 300자를 초과 할 수 없습니다.';

  @override
  String get couldnt_update_user => '사용자를 업데이트 할 수 없습니다.';

  @override
  String get couldnt_update_private_message => '개인 메시지를 업데이트 할 수 없습니다.';

  @override
  String get couldnt_update_post => '게시물을 업데이트 할 수 없습니다';

  @override
  String get couldnt_create_private_message => '개인 메시지를 만들 수 없습니다.';

  @override
  String get no_private_message_edit_allowed => '개인 메시지를 편집 할 수 없습니다.';

  @override
  String get post_title_too_long => '게시물 제목이 너무 깁니다.';

  @override
  String get email_already_exists => '이메일이 이미 존재합니다.';

  @override
  String get user_already_exists => '사용자가 이미 존재합니다.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '접속자수 $count',
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
      other: '덧글수 $countString',
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
      other: '게시물수 $countString',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '구독자수 $count',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '가입자수 $count',
    );
  }

  @override
  String get unsubscribe => '구독취소';

  @override
  String get subscribe => '구독';

  @override
  String get messages => '메세지';

  @override
  String get banned_users => '금지 된 사용자';

  @override
  String get delete_account_confirm =>
      '경고: 모든 데이터가 영구적으로 삭제됩니다. 확인을 위해 비밀번호를 입력하십시오.';

  @override
  String get new_password => '새 비밀번호';

  @override
  String get verify_password => '비밀번호 재입력';

  @override
  String get old_password => '기존 비밀번호';

  @override
  String get show_avatars => '아바타 보기';

  @override
  String get search => '검색';

  @override
  String get send_message => '메세지 전송';

  @override
  String get top_day => '일별';

  @override
  String get top_week => '주별';

  @override
  String get top_month => '월별';

  @override
  String get top_year => '년간';

  @override
  String get top_all => '전체';

  @override
  String get most_comments => '최근 덧글';

  @override
  String get new_comments => '새 덧글';

  @override
  String get active => '활발한';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

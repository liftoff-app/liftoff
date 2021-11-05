import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

/// The translations for Modern Greek (`el`).
class L10nEl extends L10n {
  L10nEl([String locale = 'el']) : super(locale);

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get password => 'Κωδικός';

  @override
  String get email_or_username =>
      'Διεύθυνση ηλεκτρονικού ταχυδρομείου ή όνομα χρήστη';

  @override
  String get posts => 'Δημοσιεύσεις';

  @override
  String get comments => 'Σχόλια';

  @override
  String get modlog => 'Ιστορικό συντονισμού';

  @override
  String get community => 'Κοινότητα';

  @override
  String get url => 'URL';

  @override
  String get title => 'Επικεφαλίδα';

  @override
  String get body => 'Κορμός';

  @override
  String get nsfw => 'Ακατάλληλο για ανηλίκους';

  @override
  String get post => 'δημοσίευση';

  @override
  String get save => 'αποθήκευση';

  @override
  String get subscribed => 'Συνδρομές';

  @override
  String get local => 'Τοπικά';

  @override
  String get all => 'Όλα';

  @override
  String get replies => 'Απαντήσεις';

  @override
  String get mentions => 'Αναφορές';

  @override
  String get from => 'από';

  @override
  String get to => 'προς';

  @override
  String get deleted_by_creator => 'διαγράφηκε από τον δημιουργό';

  @override
  String get more => 'περισσότερα';

  @override
  String get mark_as_read => 'επισήμανση ως διαβασμένο';

  @override
  String get mark_as_unread => 'επισήμανση ως μη διαβασμένο';

  @override
  String get reply => 'απάντηση';

  @override
  String get edit => 'επεξεργασία';

  @override
  String get delete => 'διαγραφή';

  @override
  String get restore => 'επαναφορά';

  @override
  String get yes => 'ναι';

  @override
  String get no => 'όχι';

  @override
  String get avatar => 'Άβαταρ';

  @override
  String get banner => 'Μπάνερ';

  @override
  String get display_name => 'Προβαλλόμενο όνομα';

  @override
  String get bio => 'Βιογραφικό';

  @override
  String get email => 'Email';

  @override
  String get matrix_user => 'Χρήστης Matrix';

  @override
  String get sort_type => 'Ταξινόμηση κατά';

  @override
  String get type => 'Είδος';

  @override
  String get show_nsfw => 'Προβολή περιεχομένου ακατάλληλου για ανηλίκους';

  @override
  String get send_notifications_to_email =>
      'Αποστολή ειδοποιήσεων στη διεύθυνση ηλεκτρονικού ταχυδρομείου';

  @override
  String get delete_account => 'Διαγραφή λογαριασμού';

  @override
  String get saved => 'Αποθηκευμένα';

  @override
  String get communities => 'Κοινότητες';

  @override
  String get users => 'Χρήστες';

  @override
  String get theme => 'Θέμα';

  @override
  String get language => 'Γλώσσα';

  @override
  String get hot => 'Δημοφιλία';

  @override
  String get new_ => 'Φρεσκάδα';

  @override
  String get old => 'Παλιά';

  @override
  String get top => 'Κορυφαία';

  @override
  String get chat => 'Συνομιλία';

  @override
  String get admin => 'διαχειριστής';

  @override
  String get by => 'από';

  @override
  String get not_a_mod_or_admin => 'Δεν είστε συντονιστής ή διαχειριστής.';

  @override
  String get not_an_admin => 'Ο χρήστης δεν είναι διαχειριστής.';

  @override
  String get couldnt_find_post => 'Δεν μπόρεσε να βρεθεί η δημοσίευση.';

  @override
  String get not_logged_in => 'Αποσυνδεδέμενος.';

  @override
  String get site_ban => 'Έχετε αποβληθεί από τον ιστότοπο';

  @override
  String get community_ban => 'Έχετε αποβληθεί από αυτή την κοινότητα.';

  @override
  String get downvotes_disabled => 'Αρνητικές ψήφοι απενεργοποιημένες';

  @override
  String get invalid_url => 'Μη έγκυρο URL.';

  @override
  String get locked => 'κλειδωμένο';

  @override
  String get couldnt_create_comment => 'Αδυναμία δημιουργίας σχόλιου.';

  @override
  String get couldnt_like_comment =>
      'Δεν μπόρεσε να ψηφισθεί θετικά το σχόλιο.';

  @override
  String get couldnt_update_comment => 'Δεν μπόρεσε να ενημερωθεί το σχόλιο.';

  @override
  String get no_comment_edit_allowed =>
      'Δεν επιτρέπεται η επεξεργασία του σχολίου.';

  @override
  String get couldnt_save_comment => 'Δεν μπόρεσε να αποθηκευτεί το σχόλιο.';

  @override
  String get couldnt_get_comments => 'Δεν μπόρεσαν να φορτώσουν τα σχόλια.';

  @override
  String get report_reason_required => 'Απαιτείται λόγος αναφοράς.';

  @override
  String get report_too_long => 'Η αναφορά είναι υπερβολικά μεγάλη.';

  @override
  String get couldnt_create_report => 'Αδυναμία δημιουργίας αναφοράς.';

  @override
  String get couldnt_resolve_report => 'Αδυναμία επίλυσης αναφοράς.';

  @override
  String get invalid_post_title => 'Μη έγκυρη επικεφαλίδα δημοσίευσης';

  @override
  String get couldnt_create_post => 'Δεν μπόρεσε να δημιουργηθεί η δημοσίευση.';

  @override
  String get couldnt_like_post =>
      'Δεν μπόρεσε να ψηφισθεί θετικά η δημοσίευση.';

  @override
  String get couldnt_find_community => 'Δεν μπόρεσε να βρεθεί η κοινότητα.';

  @override
  String get couldnt_get_posts => 'Αδυναμία εύρεσης δημοσιεύσων';

  @override
  String get no_post_edit_allowed =>
      'Δεν επιτρέπεται η επεξεργασία της δημοσίευσης.';

  @override
  String get couldnt_save_post => 'Δεν μπόρεσε να αποθηκευτεί η δημοσίευση.';

  @override
  String get site_already_exists => 'Ο ιστότοπος υπάρχει ήδη.';

  @override
  String get couldnt_update_site => 'Αδυναμία ενημέρωσης ιστότοπου.';

  @override
  String get invalid_community_name => 'Άκυρο όνομα.';

  @override
  String get community_already_exists => 'Η κοινότητα υπάρχει ήδη.';

  @override
  String get community_moderator_already_exists =>
      'Ο χρήστης είναι ήδη συντονιστής της κοινότητας.';

  @override
  String get community_follower_already_exists =>
      'Ο χρήστης είναι ήδη εγγεγραμμένος στην κοινότητα.';

  @override
  String get not_a_moderator => 'Δεν είναι συντονιστής.';

  @override
  String get couldnt_update_community =>
      'Δεν μπόρεσε να ενημερωθεί η κοινότητα.';

  @override
  String get no_community_edit_allowed =>
      'Δεν επιτρέπεται η επεξεργασία της κοινότητας.';

  @override
  String get system_err_login =>
      'Σφάλμα στο σύστημα. Προσπαθήστε να αποσυνδεθείτε και να συνδεθείτε ξανά.';

  @override
  String get community_user_already_banned =>
      'Ο χρήστης έχει ήδη αποβληθεί από την κοινότητα.';

  @override
  String get couldnt_find_that_username_or_email =>
      'Αδυναμία εύρεσης χρήστη ή διεύθυνσης ηλεκτρονικού ταχυδρομείου.';

  @override
  String get password_incorrect => 'Λάθος κωδικός.';

  @override
  String get registration_closed => 'Εγγραφή κλειστή';

  @override
  String get invalid_password =>
      'Άκυρος κωδικός. Ο κωδικός πρέπει να είναι <= 60 χαρακτήρες.';

  @override
  String get passwords_dont_match => 'Οι κωδικοί δεν ταιριάζουν.';

  @override
  String get captcha_incorrect => 'Εσφαλμένο captcha.';

  @override
  String get invalid_username => 'Λάθος όνομα χρήστη.';

  @override
  String get bio_length_overflow =>
      'Το βιογραφικό χρήστη δεν μπορεί να ξεπερνά τους 300 χαρακτήρες.';

  @override
  String get couldnt_update_user => 'Αδυναμία ενημέρωσης χρήστη.';

  @override
  String get couldnt_update_private_message =>
      'Αδυναμία ενημέρωσης προσωπικού μηνύματος.';

  @override
  String get couldnt_update_post => 'Αδυναμία ενημέρωσης δημοσιεύσης';

  @override
  String get couldnt_create_private_message =>
      'Αδυναμία δημιουργίας προσωπικού μηνύματος.';

  @override
  String get no_private_message_edit_allowed =>
      'Δεν επιτρέπεται η επεξεργασία του προσωπικού μηνύματος.';

  @override
  String get post_title_too_long =>
      'Η επικεφαλίδα της δημοσίευσης είναι υπερβολικά μεγάλη.';

  @override
  String get email_already_exists =>
      'Η διεύθυνση ηλεκτρονικού ταχυδρομείου υπάρχει ήδη.';

  @override
  String get user_already_exists => 'Ο χρήστης υπάρχει ήδη.';

  @override
  String number_of_users_online(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count ενεργός χρήστης',
      other: '$count ενεργοί χρήστες',
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
      one: '$countString Σχόλιο',
      other: '$countString Σχόλια',
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
      one: '$countString Δημοσίευση',
      other: '$countString Δημοσιεύσεις',
    );
  }

  @override
  String number_of_subscribers(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count εγγεγραμμένος',
      other: '$count εγγεγραμμένοι',
    );
  }

  @override
  String number_of_users(int count) {
    return intl.Intl.pluralLogic(
      count,
      locale: localeName,
      one: '$count χρήστης',
      other: '$count χρήστες',
    );
  }

  @override
  String get unsubscribe => 'Απεγγραφή';

  @override
  String get subscribe => 'Εγγραφή';

  @override
  String get messages => 'Μηνύματα';

  @override
  String get banned_users => 'Αποβεβλημένοι χρήστες';

  @override
  String get delete_account_confirm =>
      'Προσοχή: αυτό θα διαγράψει όλα τα δεδομένα σας. Είσαγετε τον κωδικό σας για επιβεβαίωση.';

  @override
  String get new_password => 'Νέος κωδικός';

  @override
  String get verify_password => 'Επαλήθευση κωδικού';

  @override
  String get old_password => 'Παλιός κωδικός';

  @override
  String get show_avatars => 'Εμφάνιση των άβαταρς';

  @override
  String get search => 'Αναζήτηση';

  @override
  String get send_message => 'Αποστολή μηνύματος';

  @override
  String get top_day => 'Κορυφαία σήμερα';

  @override
  String get top_week => 'Κορυφαία της εβδομάδας';

  @override
  String get top_month => 'Κορυφαία του μήνα';

  @override
  String get top_year => 'Κορυφαία φέτος';

  @override
  String get top_all => 'Κορυφαία από πάντα';

  @override
  String get most_comments => 'Περισσότερα σχόλια';

  @override
  String get new_comments => 'Νέα σχόλια';

  @override
  String get active => 'Δραστηριότητα';

  @override
  String get bot_account => 'Bot Account';

  @override
  String get show_bot_accounts => 'Show Bot Accounts';

  @override
  String get show_read_posts => 'Show Read Posts';
}

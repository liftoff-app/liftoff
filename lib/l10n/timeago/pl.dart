import 'package:timeago/timeago.dart';

class PlShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'teraz';
  @override
  String aboutAMinute(int minutes) => '1min.';
  @override
  String minutes(int minutes) => '${minutes}min.';
  @override
  String aboutAnHour(int minutes) => '~1g.';
  @override
  String hours(int hours) => '${hours}g.';
  @override
  String aDay(int hours) => '~1d.';
  @override
  String days(int days) => '${days}d.';
  @override
  String aboutAMonth(int days) => '~1mies.';
  @override
  String months(int months) => '${months}mies.';
  @override
  String aboutAYear(int year) => '~1r.';
  @override
  String years(int years) => _pluralize(years, 'lata', 'lat');
  @override
  String wordSeparator() => ' ';

  String _pluralize(int n, String form1, String form2) {
    // Rules as per https://www.gnu.org/software/gettext/manual/html_node/Plural-forms.html
    if (n % 10 >= 2 && n % 10 <= 4 && (n % 100 < 10 || n % 100 >= 20)) {
      return '$n $form1';
    }

    return '$n $form2';
  }
}

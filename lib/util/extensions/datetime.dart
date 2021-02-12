import 'package:timeago/timeago.dart' as timeago;

extension FancyTime on DateTime {
  /// returns `this` time as a relative, human-readable string. In short format
  String get fancyShort => timeago.format(this,
      locale: 'en_short',
      clock: DateTime.now().subtract(DateTime.now().timeZoneOffset));

  /// returns `this` time as a relative, human-readable string
  String get fancy => timeago.format(this,
      clock: DateTime.now().subtract(DateTime.now().timeZoneOffset));
}

import 'package:timeago/timeago.dart' as timeago;

extension FancyTime on DateTime {
  /// returns `this` time as a relative, human-readable string. In short format
  String get fancyShort => timeago.format(this, locale: 'en_short');

  /// returns `this` time as a relative, human-readable string
  String get fancy => timeago.format(this);
}

import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

extension FancyTime on DateTime {
  /// returns `this` time as a relative, human-readable string. In short format
  String timeagoShort(BuildContext context) => format(
        this,
        locale: '${Localizations.localeOf(context).toLanguageTag()}_short',
      );

  /// returns `this` time as a relative, human-readable string
  String timeago(BuildContext context) =>
      format(this, locale: Localizations.localeOf(context).toLanguageTag());
}

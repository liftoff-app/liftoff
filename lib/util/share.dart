import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart' as flutter_share;

/// A `package:share` wrapper that fallbacks to copying contents to the clipboard
/// on platforms that do not support native sharing
abstract class Share {
  static Future<void> share(
    String text, {
    String subject,
    Rect sharePositionOrigin,
    @required BuildContext context,
  }) async {
    assert(context != null);

    try {
      return await flutter_share.Share.share(
        text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      );
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied data to clipboard!')),
      );
    }
  }
}

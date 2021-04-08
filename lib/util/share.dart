import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

/// A `package:share` wrapper that fallbacks to copying contents to the clipboard
/// on platforms that do not support native sharing
Future<void> share(
  String text, {
  String? subject,
  Rect? sharePositionOrigin,
  required BuildContext context,
}) async {

  try {
    return await Share.share(
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

/// A `package:share` wrapper that fallbacks to copying contents to the clipboard
/// on platforms that do not support native sharing
Future<void> share(
  String text, {
  String? subject,
  Rect? sharePositionOrigin,
  required BuildContext context,
}) async {
  if (Platform.isLinux || Platform.isWindows) {
    await _fallbackShare(text, context: context);
    return;
  }

  try {
    await Share.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  } on MissingPluginException {
    await _fallbackShare(text, context: context);
  }
}

Future<void> _fallbackShare(
  String text, {
  required BuildContext context,
}) async {
  await Clipboard.setData(ClipboardData(text: text));
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copied data to clipboard!')),
  );
}

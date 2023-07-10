import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image/image.dart';

Future<dynamic> convertWebpToPng(File file) async {
  try {
    final bytes = file.readAsBytesSync();
    final img = decodeWebP(bytes)!;
    final png = encodePng(img);

    final newPath = file.path.replaceAll('.webp', '.png');
    final output = File(newPath);

    return await output.writeAsBytes(png);
  } catch (e) {
    debugPrint(e.toString());
    return 'Error converting the image.';
  }
}

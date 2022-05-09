import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Picks a single image from the system
Future<XFile?> pickImage() async {
  if (kIsWeb || Platform.isIOS || Platform.isAndroid) {
    return ImagePicker().pickImage(source: ImageSource.gallery);
  } else {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) return null;

    return XFile(result.files.single.path!);
  }
}

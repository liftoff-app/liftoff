import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Picks a single image from the system
Future<XFile?> pickImage() async {
  if (kIsWeb || Platform.isIOS || Platform.isMacOS || Platform.isAndroid) {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    if (!Platform.isIOS && !Platform.isMacOS) return image;

    // iOS encodes the camera orientation in the EXIF data.
    // Lemmy removes EXIF data on upload, so bake it in first.
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/liftoffphoto123.jpg');

    final imageIn = img.decodeImage(await image.readAsBytes())!;

    // Here's the magic.
    final imageOut = img.bakeOrientation(imageIn);

    final bytes = img.encodeJpg(imageOut);
    tempFile.writeAsBytesSync(bytes);
    return XFile.fromData(
      bytes,
      path: tempFile.path,
      length: bytes.length,
      name: 'liftoff123.jpg',
    );
  } else {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result == null) return null;

    return XFile(result.files.single.path!);
  }
}

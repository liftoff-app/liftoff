import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image/image.dart' as img;
import 'package:image_editor/image_editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/gen/l10n.dart';
import '../util/files.dart';

/// Modal for picking and editing a photo from the OS.
/// Pops the navigator stack with a [XFile]
class PickImagePage extends HookWidget {
  const PickImagePage({super.key});

  /// read the supplied XFile, check orientation and
  /// provide the corrected XFile.
  _getImage(context, key) async {
    final state = key.currentState;
    final imgBytes = state.rawImageData;
    final cropRect = state.getCropRect();
    final option = ImageEditorOption()
      ..addOption(ClipOption.fromRect(cropRect));
    final result = await ImageEditor.editImage(
      image: imgBytes,
      imageEditorOption: option,
    );

    // Bake in the orientation.
    final tempDir = await getTemporaryDirectory();

    // there has to be a better way....
    var i = 0;
    while (File('${tempDir.path}/liftoffphoto$i.jpg').existsSync()) {
      i += 1;
    }
    final tempFile = File('${tempDir.path}/liftoffphoto$i.jpg');

    final imageIn = img.decodeImage(result!)!;

    // Here's the magic.
    final imageOut = img.bakeOrientation(imageIn);

    final bytes = img.encodeJpg(imageOut);
    tempFile.writeAsBytesSync(bytes);
    final outXFile = XFile.fromData(
      bytes,
      path: tempFile.path,
      length: bytes.length,
      name: 'chosen_image.jpg',
    );
    Navigator.of(context).pop(outXFile);
  }

  @override
  Widget build(BuildContext context) {
    final editorKey = GlobalKey<ExtendedImageEditorState>();
    final xfile = useState<XFile?>(null);

    // Make this a function so we can use UseEffect() on it.
    Future callPickImage() async {
      xfile
        ..value = null // clear image
        ..value = await pickImage();
    }

    // Call a Hooks effect to load the image picker on startup.
    // Passing [] to keys makes this only load on first build.
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => callPickImage());
      return null; // ie no dispose function needed.
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(L10n.of(context).photo_picker_explanation),
            const SizedBox(height: 10),
            if (xfile.value == null)
              const ColoredBox(
                color: Colors.grey,
                child: SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Text(''),
                ),
              )
            else
              ClipRect(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: ExtendedImage.file(
                    File(xfile.value!.path),
                    fit: BoxFit.contain,
                    mode: ExtendedImageMode.editor,
                    enableLoadState: true,
                    extendedImageEditorKey: editorKey,
                    cacheRawData: true,
                    initEditorConfigHandler: (ExtendedImageState? state) {
                      return EditorConfig(
                        maxScale: 4,
                        initCropRectType: InitCropRectType.layoutRect,
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: callPickImage,
                    child: Text(L10n.of(context).pick_a_photo)),
                ElevatedButton(
                  onPressed: (xfile.value == null)
                      ? null
                      : () => _getImage(context, editorKey),
                  child: Text(L10n.of(context).use_this_image),
                ),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(L10n.of(context).cancel)),
              ],
            )
          ],
        ),
      ),
    );
  }

  static Route<XFile?> route() => MaterialPageRoute(
        builder: (context) => const PickImagePage(),
        fullscreenDialog: true,
      );
}

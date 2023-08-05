import 'dart:io';
import 'dart:math' show max, min;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../stores/config_store.dart';
import '../util/convert_webp.dart';
import '../util/icons.dart';
import '../util/share.dart';
import '../widgets/bottom_modal.dart';

// FIXME: Remove this when linting fix for this rule is in Flutter SDK
// See: https://github.com/dart-lang/linter/issues/4007
// ignore_for_file: use_build_context_synchronously

/// View to interact with a media object. Zoom in/out, download, share, etc.
class MediaViewPage extends HookWidget {
  final String url;
  final String? heroTag;
  static const yThreshold = 150;
  static const speedThreshold = 45;

  const MediaViewPage(this.url, {super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final showButtons = useState(true);
    final isZoomedOut = useState(true);
    final scaleIsInitial = useState(true);

    final isDragging = useState(false);

    final offset = useState(Offset.zero);
    final prevOffset = usePrevious(offset.value) ?? Offset.zero;

    // TODO: hide navbar and topbar on android without a content jump

    sharePhoto() {
      showBottomModal(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Share link'),
              onTap: () {
                Navigator.of(context).pop();
                share(url, context: context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Share file'),
              onTap: () async {
                Navigator.of(context).pop();
                final File file =
                    await DefaultCacheManager().getSingleFile(url);
                if (Platform.isAndroid || Platform.isIOS) {
                  await Share.shareXFiles([XFile(file.path)]);
                } else if (Platform.isLinux || Platform.isWindows) {
                  _showSnackBar(context, 'sharing does not work on Desktop');
                }
              },
            ),
          ],
        ),
      );
    }

    // Keep a record of the default style and reset it once we're done here.
    final originalStyle = Theme.of(context).appBarTheme.systemOverlayStyle!;
    useEffect(() {
      return () => SystemChrome.setSystemUIOverlayStyle(originalStyle);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor:
          Colors.black.withOpacity(max(0, 1.0 - (offset.value.dy.abs() / 200))),
      appBar: showButtons.value
          ? AppBar(
              systemOverlayStyle: SystemUiOverlayStyle.light,
              iconTheme: const IconThemeData(color: Colors.white),
              backgroundColor: Colors.black38,
              leading: const CloseButton(),
              actions: [
                IconButton(
                  icon: Icon(shareIcon),
                  tooltip: 'share',
                  onPressed: sharePhoto,
                ),
                IconButton(
                  icon: const Icon(Icons.file_download),
                  tooltip: 'download',
                  onPressed: () async {
                    File file = await DefaultCacheManager().getSingleFile(url);
                    final filePath = file.path;

                    final store =
                        Provider.of<ConfigStore>(context, listen: false);

                    if (store.convertWebpToPng == true) {
                      // Check if image is a webp and convert it
                      if (filePath.endsWith('.webp')) {
                        final result = await convertWebpToPng(file);

                        // A returned File means the conversion was successful.
                        if (result is File) {
                          file = result;
                          debugPrint('File was successfully converted.');
                        }

                        // String means error. Cancel the download.
                        if (result is String) {
                          debugPrint(result);
                          _showSnackBar(context, result);
                          return;
                        }
                      }
                    }

                    if (Platform.isAndroid || Platform.isIOS) {
                      if (!await requestMediaPermission()) {
                        _showSnackBar(context,
                            'Media permission revoked. Please go to the settings to fix');
                        return;
                      }
                      var result = await GallerySaver.saveImage(file.path,
                          albumName: 'Liftoff');

                      result ??= false;

                      final message = result
                          ? 'Image saved'
                          : 'Error downloading the image';

                      _showSnackBar(context, message);
                    } else if (Platform.isLinux || Platform.isWindows) {
                      final filePath =
                          '${(await getDownloadsDirectory())!.path}/Liftoff/${basename(file.path)}';

                      File(filePath)
                        ..createSync(recursive: true)
                        ..writeAsBytesSync(file.readAsBytesSync());

                      _showSnackBar(context, 'Image saved to $filePath');
                    }
                  },
                ),
              ],
            )
          : null,
      body: Listener(
        onPointerMove: scaleIsInitial.value
            ? (event) {
                if (!isDragging.value &&
                    event.delta.dx.abs() > event.delta.dy.abs()) return;
                isDragging.value = true;
                offset.value += event.delta;
              }
            : (_) => isDragging.value = false,
        onPointerCancel: (_) => offset.value = Offset.zero,
        onPointerUp: isZoomedOut.value
            ? (_) {
                if (!isDragging.value) {
                  showButtons.value = !showButtons.value;
                  return;
                }

                isDragging.value = false;
                final speed = (offset.value - prevOffset).distance;
                if (speed > speedThreshold ||
                    offset.value.dy.abs() > yThreshold) {
                  Navigator.of(context).pop();
                } else {
                  offset.value = Offset.zero;
                }
              }
            : (_) {
                offset.value = Offset.zero;
                isDragging.value = false;
              },
        child: AnimatedContainer(
          transform: Matrix4Transform()
              .scale(max(0.9, 1 - offset.value.dy.abs() / 1000))
              .translateOffset(offset.value)
              .rotate(min(-offset.value.dx / 2000, 0.1))
              .matrix4,
          duration: isDragging.value
              ? Duration.zero
              : const Duration(milliseconds: 200),
          child: PhotoView(
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            scaleStateChangedCallback: (value) {
              isZoomedOut.value = value == PhotoViewScaleState.zoomedOut ||
                  value == PhotoViewScaleState.initial;
              showButtons.value = isZoomedOut.value;

              scaleIsInitial.value = value == PhotoViewScaleState.initial;
              isDragging.value = false;
              offset.value = Offset.zero;
            },
            onTapUp: isZoomedOut.value
                ? (_, __, ___) => Navigator.of(context).pop()
                : (_, __, ___) => showButtons.value = !showButtons.value,
            minScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
            imageProvider: ExtendedNetworkImageProvider(url, cache: true),
            heroAttributes:
                heroTag != null ? PhotoViewHeroAttributes(tag: heroTag!) : null,
            loadingBuilder: (context, event) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),
      ),
    );
  }

  Future<bool> requestMediaPermission() async {
    await [
      Permission.photos,
      Permission.photosAddOnly,
      Permission.storage,
    ].request();

    final hasPermission = await Permission.photos.isGranted ||
        await Permission.photos.isLimited ||
        await Permission.storage.isGranted;

    return hasPermission;
  }

  _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

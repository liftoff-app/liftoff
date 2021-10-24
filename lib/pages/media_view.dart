import 'dart:math' show max, min;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:photo_view/photo_view.dart';

import '../util/share.dart';
import '../widgets/bottom_modal.dart';

/// View to interact with a media object. Zoom in/out, download, share, etc.
class MediaViewPage extends HookWidget {
  final String url;
  static const yThreshold = 150;
  static const speedThreshold = 45;

  const MediaViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    final showButtons = useState(true);
    final isZoomedOut = useState(true);
    final scaleIsInitial = useState(true);

    final isDragging = useState(false);

    final offset = useState(Offset.zero);
    final prevOffset = usePrevious(offset.value) ?? Offset.zero;

    notImplemented() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("this feature hasn't been implemented yet 😰")));
    }

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
              onTap: () {
                Navigator.of(context).pop();
                notImplemented();
                // TODO: share file
              },
            ),
          ],
        ),
      );
    }

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
                  icon: const Icon(Icons.share),
                  tooltip: 'share',
                  onPressed: sharePhoto,
                ),
                IconButton(
                  icon: const Icon(Icons.file_download),
                  tooltip: 'download',
                  onPressed: notImplemented,
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
                ? null
                : (_, __, ___) => showButtons.value = !showButtons.value,
            minScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
            imageProvider: ExtendedNetworkImageProvider(url, cache: true),
            heroAttributes: PhotoViewHeroAttributes(tag: url),
            loadingBuilder: (context, event) =>
                const Center(child: CircularProgressIndicator.adaptive()),
          ),
        ),
      ),
    );
  }
}

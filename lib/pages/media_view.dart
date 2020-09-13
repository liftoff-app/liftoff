import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

import '../widgets/bottom_modal.dart';

class MediaViewPage extends HookWidget {
  final String url;

  const MediaViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    final showButtons = useState(true);
    final isZoomedOut = useState(true);

    useEffect(() {
      if (showButtons.value) {
        SystemChrome.setEnabledSystemUIOverlays([
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
      return () => SystemChrome.setEnabledSystemUIOverlays([
            SystemUiOverlay.bottom,
            SystemUiOverlay.top,
          ]);
    });

    share() {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => BottomModal(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.link),
                title: Text('Share link'),
                onTap: () {
                  Navigator.of(context).pop();
                  Share.text('Share image url', url, 'text/plain');
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Share file'),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: share file
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: showButtons.value
          ? AppBar(
              backgroundColor: Colors.black38,
              shadowColor: Colors.transparent,
              leading: CloseButton(),
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  tooltip: 'share',
                  onPressed: share,
                ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  tooltip: 'download',
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: Dismissible(
        direction: DismissDirection.vertical,
        onDismissed: (_) => Navigator.of(context).pop(),
        key: const Key('media view'),
        background: Container(color: Colors.black),
        dismissThresholds: {
          DismissDirection.vertical: 0,
        },
        confirmDismiss: (direction) => Future.value(isZoomedOut.value),
        resizeDuration: null,
        child: GestureDetector(
          onTapUp: (details) => showButtons.value = !showButtons.value,
          child: PhotoView(
            scaleStateChangedCallback: (value) {
              isZoomedOut.value = value == PhotoViewScaleState.zoomedOut ||
                  value == PhotoViewScaleState.initial;
            },
            minScale: PhotoViewComputedScale.contained,
            initialScale: PhotoViewComputedScale.contained,
            imageProvider: CachedNetworkImageProvider(url),
            heroAttributes: PhotoViewHeroAttributes(tag: url),
            loadingBuilder: (context, event) =>
                Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

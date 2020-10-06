import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

import '../widgets/bottom_modal.dart';

/// View to interact with a media object. Zoom in/out, download, share, etc.
class MediaViewPage extends HookWidget {
  final String url;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  MediaViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    final showButtons = useState(true);
    final isZoomedOut = useState(true);

    notImplemented() {
      _key.currentState.showSnackBar(SnackBar(
          content: Text("this feature hasn't been implemented yet 😰")));
    }

    useEffect(() {
      if (showButtons.value) {
        SystemChrome.setEnabledSystemUIOverlays([
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
      return null;
    }, [showButtons.value]);

    useEffect(
        () => () => SystemChrome.setEnabledSystemUIOverlays([
              SystemUiOverlay.bottom,
              SystemUiOverlay.top,
            ]),
        []);

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
                  notImplemented();
                  // TODO: share file
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      key: _key,
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
                  onPressed: notImplemented,
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTapUp: (details) => showButtons.value = !showButtons.value,
        onVerticalDragEnd: isZoomedOut.value
            ? (details) {
                if (details.primaryVelocity.abs() > 1000) {
                  Navigator.of(context).pop();
                }
              }
            : null,
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
    );
  }
}

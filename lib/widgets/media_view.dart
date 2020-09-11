import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

class MediaView extends HookWidget {
  final String url;

  const MediaView(this.url);

  @override
  Widget build(BuildContext context) {
    var showButtons = useState(true);

    useEffect(() => () => SystemChrome.setEnabledSystemUIOverlays([
          SystemUiOverlay.bottom,
          SystemUiOverlay.top,
        ]));

    if (showButtons.value) {
      SystemChrome.setEnabledSystemUIOverlays([
        SystemUiOverlay.bottom,
        SystemUiOverlay.top,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

    return Scaffold(
      appBar: showButtons.value
          ? AppBar(
              backgroundColor: Colors.black38,
              shadowColor: Colors.transparent,
              leading: CloseButton(),
              actions: [
                IconButton(
                  icon: Icon(Icons.share),
                  tooltip: 'share',
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.file_download),
                  tooltip: 'download',
                  onPressed: () {},
                ),
              ],
            )
          : null,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onTapUp: (details) => showButtons.value = !showButtons.value,
        child: PhotoView(
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

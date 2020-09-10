import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';

class MediaView extends HookWidget {
  final String url;

  const MediaView(this.url);

  @override
  Widget build(BuildContext context) {
    var showButtons = useState(true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            showButtons.value ? Colors.black38 : Colors.transparent,
        shadowColor: Colors.transparent,
        leading: showButtons.value ? CloseButton() : Container(),
        actions: showButtons.value
            ? [
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
              ]
            : null,
      ),
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

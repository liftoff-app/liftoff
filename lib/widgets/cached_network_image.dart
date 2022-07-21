import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

typedef ImageBuilder = Widget Function(
    BuildContext context, ImageProvider imageProvider);

typedef LoadingBuilder = Widget Function(
    BuildContext context, ImageChunkEvent? progress);

typedef ErrorBuilder = Widget Function(
    BuildContext context, Object? lastException);

extension Progress on ImageChunkEvent {
  double? get progress {
    if (expectedTotalBytes == null ||
        cumulativeBytesLoaded > expectedTotalBytes!) {
      return null;
    }

    return cumulativeBytesLoaded / expectedTotalBytes!;
  }
}

class CachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool cache;

  final ErrorBuilder? errorBuilder;
  final LoadingBuilder? loadingBuilder;
  final ImageBuilder? imageBuilder;

  const CachedNetworkImage({
    required this.imageUrl,
    this.errorBuilder,
    this.loadingBuilder,
    this.imageBuilder,
    this.height,
    this.width,
    this.fit,
    this.cache = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      height: height,
      width: width,
      fit: fit,
      cache: cache,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return loadingBuilder?.call(context, state.loadingProgress) ??
                SizedBox(height: height, width: width);
          case LoadState.completed:
            return imageBuilder?.call(context, state.imageProvider);
          case LoadState.failed:
            return errorBuilder?.call(context, state.lastException);
        }
      },
    );
  }
}

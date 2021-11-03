import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../stores/config_store.dart';
import 'cached_network_image.dart';

/// User's avatar. Respects the `showAvatars` setting from configStore
/// If passed url is null, a blank box is displayed to prevent weird indents
/// Can be disabled with `noBlank`
class Avatar extends HookWidget {
  const Avatar({
    Key? key,
    required this.url,
    this.radius = 25,
    this.noBlank = false,
    this.alwaysShow = false,
    this.padding = EdgeInsets.zero,
    this.onTap,
  }) : super(key: key);

  final String? url;
  final double radius;
  final bool noBlank;
  final VoidCallback? onTap;

  /// padding is applied unless blank widget is returned
  final EdgeInsetsGeometry padding;

  /// Overrides the `showAvatars` setting
  final bool alwaysShow;

  @override
  Widget build(BuildContext context) {
    final showAvatars =
        useStore((ConfigStore store) => store.showAvatars) || alwaysShow;

    final blankWidget = () {
      if (noBlank) return const SizedBox.shrink();

      return SizedBox(
        width: radius * 2,
        height: radius * 2,
      );
    }();

    final imageUrl = url;

    if (imageUrl == null || !showAvatars) {
      return blankWidget;
    }

    return Padding(
      padding: padding,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: ClipOval(
          child: CachedNetworkImage(
            height: radius * 2,
            width: radius * 2,
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __) => blankWidget,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../hooks/delayed_loading.dart';

/// [IconButton], usually at the bottom of some tile, that performs an async
/// action that uses [DelayedLoading], has reduced size to be more compact,
/// and has built in spinner
class TileAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final DelayedLoading? delayedLoading;
  final bool loading;
  final Color? iconColor;

  const TileAction({
    Key? key,
    this.delayedLoading,
    this.iconColor,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: BoxConstraints.tight(const Size(36, 30)),
        padding: EdgeInsets.zero,
        splashRadius: 25,
        iconSize: 25,
        tooltip: tooltip,
        onPressed: delayedLoading?.pending ?? loading ? () {} : onPressed,
        icon: delayedLoading?.loading ?? loading
            ? SizedBox.fromSize(
                size: const Size.square(22),
                child: const CircularProgressIndicator.adaptive(),
              )
            : Icon(
                icon,
                color: iconColor ??
                    Theme.of(context).iconTheme.color?.withAlpha(190),
              ),
      );
}

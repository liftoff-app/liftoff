import 'package:flutter/material.dart';

import '../hooks/delayed_loading.dart';

/// [IconButton], usually at the bottom of some tile, that performs an async
/// action that uses [DelayedLoading], has reduced size to be more compact,
/// and has built in spinner
class TileAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final DelayedLoading delayedLoading;
  final Color iconColor;

  const TileAction({
    Key key,
    this.delayedLoading,
    this.iconColor,
    @required this.icon,
    @required this.onPressed,
    @required this.tooltip,
  })  : assert(icon != null),
        assert(onPressed != null),
        assert(tooltip != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        constraints: BoxConstraints.tight(const Size(36, 30)),
        icon: delayedLoading?.loading ?? false
            ? SizedBox.fromSize(
                size: const Size.square(22),
                child: const CircularProgressIndicator())
            : Icon(
                icon,
                color: iconColor ??
                    Theme.of(context).iconTheme.color.withAlpha(190),
              ),
        splashRadius: 25,
        onPressed: delayedLoading?.pending ?? false ? () {} : onPressed,
        iconSize: 25,
        tooltip: tooltip,
        padding: const EdgeInsets.all(0),
      );
}

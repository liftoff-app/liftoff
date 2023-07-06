import 'package:flutter/material.dart';

import '../hooks/delayed_loading.dart';

/// [IconButton], usually at the bottom of some tile, that performs an async
/// action that uses [DelayedLoading], has reduced size to be more compact,
/// and has built in spinner
class TileToggle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final DelayedLoading? delayedLoading;
  final bool loading;
  final bool activated;
  final Color? activeColor;

  const TileToggle({
    super.key,
    this.delayedLoading,
    required this.icon,
    required this.onPressed,
    required this.activated,
    required this.tooltip,
    this.activeColor,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(36, 30)),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: activated
              ? (activeColor ?? Theme.of(context).colorScheme.secondary)
                  .withAlpha(120)
              : Colors.transparent,
          child: IconButton(
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
                    color: activated
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).iconTheme.color?.withAlpha(190),
                  ),
          ),
        ),
      );
}

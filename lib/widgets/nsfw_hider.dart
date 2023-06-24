import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../stores/config_store.dart';

/// Hides NSFW content until clicked.
class NSFWHider extends HookWidget {
  final Widget child;

  const NSFWHider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final hideContent = useState(true);
    final blurNsfW = useStore((ConfigStore store) => store.blurNsfw);

    if (!blurNsfW || !hideContent.value) return child;
    return Container(
      alignment: Alignment.center,
      child: TextButton.icon(
          icon: const Icon(Icons.warning),
          label: const Text('NSFW content: click to view'),
          onPressed: () {
            hideContent.value = false;
          }),
    );
  }
}

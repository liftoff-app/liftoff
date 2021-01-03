import 'package:flutter/material.dart';

/// Should be spawned with a showModalBottomSheet, not routed to.
class BottomModal extends StatelessWidget {
  final Widget child;
  final String title;

  const BottomModal({@required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Container(
            padding: title != null ? const EdgeInsets.only(top: 10) : null,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 70),
                    child: Text(
                      title,
                      style: theme.textTheme.subtitle2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  )
                ],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// Should be spawned with a [showBottomModal], not routed to.
class BottomModal extends StatelessWidget {
  final String title;
  final EdgeInsets padding;
  final Widget child;

  const BottomModal({
    this.title,
    this.padding = EdgeInsets.zero,
    @required this.child,
  })  : assert(padding != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    const SizedBox(height: 10),
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
                  Padding(
                    padding: padding,
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function for showing a [BottomModal]
Future<T> showBottomModal<T>({
  @required BuildContext context,
  @required WidgetBuilder builder,
  String title,
  EdgeInsets padding = EdgeInsets.zero,
}) =>
    showCustomModalBottomSheet<T>(
      context: context,
      animationCurve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      builder: builder,
      containerWidget: (context, animation, child) => BottomModal(
        title: title,
        padding: padding,
        child: child,
      ),
    );

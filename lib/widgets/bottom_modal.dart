import 'package:flutter/material.dart';

class BottomModal extends StatelessWidget {
  final Widget child;
  final String title;

  BottomModal({@required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(const Radius.circular(10.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Text(
                    'account',
                    style: theme.textTheme.subtitle2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Divider()
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'bottom_modal.dart';

/// A picker with radio values (only one value can be picked at once)
class RadioPicker<T> extends StatelessWidget {
  final List<T> values;
  final T groupValue;
  final ValueChanged<T> onChanged;

  /// Map a given value to a string for display
  final String Function(T) mapValueToString;
  final String title;

  /// custom button builder. When null, an OutlinedButton is used
  final Widget Function(
          BuildContext context, String displayValue, VoidCallback onPressed)
      buttonBuilder;

  final Widget trailing;

  const RadioPicker({
    Key key,
    @required this.values,
    @required this.groupValue,
    @required this.onChanged,
    this.mapValueToString,
    this.buttonBuilder,
    this.title,
    this.trailing,
  })  : assert(values != null),
        assert(groupValue != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapValueToString =
        this.mapValueToString ?? (value) => value.toString();

    final buttonBuilder = this.buttonBuilder ??
        (context, displayString, onPressed) => OutlinedButton(
              onPressed: onPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(displayString),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            );

    Future<void> onPressed() async {
      final value = await showBottomModal<T>(
        context: context,
        title: title,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final value in values)
              RadioListTile<T>(
                value: value,
                groupValue: groupValue,
                title: Text(mapValueToString(value)),
                onChanged: (value) => Navigator.of(context).pop(value),
              ),
            if (trailing != null) trailing
          ],
        ),
      );

      if (value != null) {
        onChanged?.call(value);
      }
    }

    return buttonBuilder(context, mapValueToString(groupValue), onPressed);
  }
}

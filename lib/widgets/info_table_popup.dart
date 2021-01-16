import 'package:flutter/material.dart';

void showInfoTablePopup(BuildContext context, Map<String, dynamic> table) {
  showDialog(
    context: context,
    builder: (c) => SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      children: [
        Table(
          children: table.entries
              .map((e) => TableRow(
                  children: [Text('${e.key}:'), Text(e.value.toString())]))
              .toList(),
        ),
      ],
    ),
  );
}

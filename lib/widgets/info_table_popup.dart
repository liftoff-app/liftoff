import 'package:flutter/material.dart';

import 'bottom_modal.dart';

void showInfoTablePopup({
  @required BuildContext context,
  @required Map<String, dynamic> table,
  String title,
}) {
  assert(context != null);
  assert(table != null);

  showBottomModal(
    context: context,
    title: title,
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      child: Column(
        children: [
          Table(children: [
            for (final e in table.entries)
              TableRow(children: [
                Text('${e.key}:'),
                if (e.value is Map<String, dynamic>)
                  GestureDetector(
                    onTap: () => showInfoTablePopup(
                      context: context,
                      table: e.value as Map<String, dynamic>,
                      title: e.key,
                    ),
                    child: Text(
                      '[tap to show]',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  )
                else
                  Text(e.value.toString())
              ])
          ]),
        ],
      ),
    ),
  );
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v2.dart';

import 'radio_picker.dart';

/// Dropdown filters where you can change sorting or viewing type
class PostListOptions extends StatelessWidget {
  final ValueChanged<SortType> onSortChanged;
  final SortType sortValue;
  final bool styleButton;

  const PostListOptions({
    @required this.onSortChanged,
    @required this.sortValue,
    this.styleButton = true,
  }) : assert(sortValue != null);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            RadioPicker<SortType>(
              title: 'sort by',
              values: SortType.values,
              groupValue: sortValue,
              onChanged: onSortChanged,
              mapValueToString: (value) => value.value,
            ),
            const Spacer(),
            if (styleButton)
              IconButton(
                icon: const Icon(Icons.view_stream),
                // TODO: create compact post and dropdown for selecting
                onPressed: () => print('TBD'),
              ),
          ],
        ),
      );
}

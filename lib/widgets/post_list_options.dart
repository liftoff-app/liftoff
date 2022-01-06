import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../l10n/l10n.dart';
import 'radio_picker.dart';

/// Dropdown filters where you can change sorting or viewing type
class PostListOptions extends StatelessWidget {
  final ValueChanged<SortType> onSortChanged;
  final SortType sortValue;
  final bool styleButton;

  const PostListOptions({
    required this.onSortChanged,
    required this.sortValue,
    this.styleButton = true,
  });

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
              mapValueToString: (value) => value.tr(context),
            ),
            const Spacer(),
            if (styleButton)
              const IconButton(
                icon: Icon(Icons.view_stream),
                // TODO: create compact post and dropdown for selecting
                onPressed: null,
              ),
          ],
        ),
      );
}

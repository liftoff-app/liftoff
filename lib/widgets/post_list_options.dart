import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import '../l10n/l10n.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
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
  Widget build(BuildContext context) {
    return ObserverBuilder<ConfigStore>(
        builder: (context, store) => Padding(
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
                    IconButton(
                      icon: store.compactPostView
                          ? const Icon(Icons.view_stream)
                          : const Icon(Icons.square_rounded),
                      onPressed: () {
                        store.compactPostView = !store.compactPostView;
                      },
                    ),
                ],
              ),
            ));
  }
}

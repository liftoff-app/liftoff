import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';
import '../l10n/l10n.dart';
import '../stores/config_store.dart';
import '../util/observer_consumers.dart';
import 'bottom_modal.dart';

class _SortSelection {
  final IconData icon;
  final String term;

  const _SortSelection(this.icon, this.term);
}

/// Dropdown filters where you can change sorting or viewing type
class CommentListOptions extends StatelessWidget {
  final ValueChanged<CommentSortType> onSortChanged;
  final CommentSortType sortValue;
  final bool styleButton;

  static const sortPairs = {
    CommentSortType.hot: _SortSelection(Icons.whatshot, L10nStrings.hot),
    CommentSortType.new_: _SortSelection(Icons.new_releases, L10nStrings.new_),
    CommentSortType.old: _SortSelection(Icons.calendar_today, L10nStrings.old),
    CommentSortType.top: _SortSelection(Icons.trending_up, L10nStrings.top),
    // CommentSortType.chat: _SortSelection(Icons.chat, L10nStrings.chat),
  };

  const CommentListOptions({
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
                  OutlinedButton(
                    onPressed: () {
                      showBottomModal(
                        title: 'sort by',
                        context: context,
                        builder: (context) => Column(
                          children: [
                            for (final e in sortPairs.entries)
                              ListTile(
                                leading: Icon(e.value.icon),
                                title: Text(e.value.term.tr(context)),
                                trailing: sortValue == e.key
                                    ? const Icon(Icons.check)
                                    : null,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  onSortChanged(e.key);
                                },
                              )
                          ],
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(sortPairs[sortValue]!.term.tr(context)),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                  // if (styleButton)
                  // add optional buttons in the comment list section
                  // IconButton(
                  //   icon: store.compactPostView
                  //       ? const Icon(Icons.view_stream)
                  //       : const Icon(Icons.square_rounded),
                  //   onPressed: () {
                  //     store.compactPostView = !store.compactPostView;
                  //   },
                  // ),
                ],
              ),
            ));
  }
}

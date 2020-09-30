import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import 'bottom_modal.dart';

/// Dropdown filters where you can change sorting or viewing type
class PostListOptions extends HookWidget {
  final void Function(SortType sort) onChange;
  final SortType defaultSort;
  final bool styleButton;

  PostListOptions({
    @required this.onChange,
    this.styleButton = true,
    this.defaultSort = SortType.active,
  });

  @override
  Widget build(BuildContext context) {
    final sort = useState(defaultSort);

    void selectSortType(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomModal(
            title: 'sort by',
            child: Column(
              children: [
                for (final x in SortType.values)
                  RadioListTile<SortType>(
                    value: x,
                    groupValue: sort.value,
                    title: Text(x.value),
                    onChanged: (val) {
                      sort.value = val;
                      onChange(val);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            )),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          OutlineButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onPressed: () => selectSortType(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(sort.value.value),
                const SizedBox(width: 8),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          Spacer(),
          if (styleButton)
            IconButton(
              icon: Icon(Icons.view_stream),
              // TODO: create compact post and dropdown for selecting
              onPressed: () => print('TBD'),
            ),
        ],
      ),
    );
  }
}

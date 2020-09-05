import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmur/widgets/bottom_modal.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

class SortPostsPicker extends HookWidget {
  final Function(SortType sort) onChange;
  final SortType defaultSort;

  SortPostsPicker({
    @required this.onChange,
    this.defaultSort = SortType.active,
  });

  @override
  Widget build(BuildContext context) {
    var sort = useState(defaultSort);

    void selectSortType(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => BottomModal(
            title: 'sort by',
            child: Column(
              children: [
                for (var x in SortType.values)
                  RadioListTile<SortType>(
                    value: x,
                    groupValue: sort.value,
                    title: Text(x.toString()),
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
                Text(sort.value.toString()),
                const SizedBox(width: 8),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.view_stream),
            onPressed: () => print('TBD'),
          )
        ],
      ),
    );
  }
}

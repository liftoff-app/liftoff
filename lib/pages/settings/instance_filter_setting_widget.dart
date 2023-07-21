import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../l10n/gen/l10n.dart';
import '../../stores/config_store.dart';
import '../../util/observer_consumers.dart';

/// Allows user to manage their instance filter list.
/// Creates its own reference to the ConfigStore, so can be
/// called easily from e.g. context menus if this is wanted.
class InstanceFilterSettingWidget extends HookWidget {
  const InstanceFilterSettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final controller = useTextEditingController();
    final termIsValid = useListenableSelector(controller,
        () => controller.text.isNotEmpty && !controller.text.contains(' '));

    updateFilter(ConfigStore store, String term) {
      if (!store.instanceFilter.contains(term.toLowerCase())) {
        // Create a new List as in-place modifications don't get notified.
        store.instanceFilter = store.instanceFilter.toList()
          ..add(term.toLowerCase());
      }
      controller.clear();
    }

    final emptyListMessage = Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Text(L10n.of(context).instance_filter_none,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
            )));

    return ObserverBuilder<ConfigStore>(builder: (context, store) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(L10n.of(context).instance_filter,
                style: TextStyle(fontSize: store.commentTitleSize)),
            Text(L10n.of(context).instance_filter_explanation),
            if (store.instanceFilter.isEmpty)
              emptyListMessage
            else
              Wrap(
                spacing: 5,
                children: store.instanceFilter
                    .map<InputChip>((e) => InputChip(
                          label: Text(e),
                          // Create a new List as in-place
                          // modifications don't get notified.
                          onDeleted: () => store.instanceFilter =
                              store.instanceFilter.toList()..remove(e),
                        ))
                    .toList(),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: TextField(
                      maxLength: 10,
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: () =>
                          updateFilter(store, controller.text),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                    onPressed: termIsValid
                        ? () => updateFilter(store, controller.text)
                        : null,
                    child: Text(L10n.of(context).instance_filter_add))
              ],
            ),
          ],
        ),
      );
    });
  }
}

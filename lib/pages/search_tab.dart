import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../util/goto.dart';
import '../widgets/radio_picker.dart';
import 'search_results.dart';

class SearchTab extends HookWidget {
  const SearchTab();

  @override
  Widget build(BuildContext context) {
    final searchInputController = useListenable(useTextEditingController());

    final accStore = useAccountsStore();
    // null if there are no added instances
    final instanceHost = useState(
      accStore.instances.firstWhere((_) => true, orElse: () => null),
    );

    if (instanceHost.value == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('You do not have any instances added'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTapDown: (_) => primaryFocus.unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            TextField(
              controller: searchInputController,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(hintText: 'search'),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text('instance:',
                      style: Theme.of(context).textTheme.subtitle1),
                ),
                Expanded(
                  child: RadioPicker<String>(
                    values: accStore.instances.toList(),
                    groupValue: instanceHost.value,
                    onChanged: (value) => instanceHost.value = value,
                  ),
                ),
              ],
            ),
            if (searchInputController.text.isNotEmpty)
              ElevatedButton(
                onPressed: () => goTo(
                    context,
                    (c) => SearchResultsPage(
                          instanceHost: instanceHost.value,
                          query: searchInputController.text,
                        )),
                child: const Text('search'),
              )
          ],
        ),
      ),
    );
  }
}

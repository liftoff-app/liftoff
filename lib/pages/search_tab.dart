import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/goto.dart';
import '../widgets/radio_picker.dart';
import 'search_results.dart';

class SearchTab extends HookWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    final searchInputController = useListenable(useTextEditingController());

    final accStore = useAccountsStore();
    final userData =
        useState(accStore.allUserData().firstWhereOrNull((_) => true));
    // null if there are no added instances
    final instanceHost = useState(userData.value == null
        ? accStore.anonymousInstances().firstWhereOrNull((_) => true)
        : null);

    if (instanceHost.value == null && userData.value == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('You do not have any instances added'),
        ),
      );
    }

    handleSearch() => searchInputController.text.isNotEmpty
        ? goTo(
            context,
            (context) => SearchResultsPage(
              instanceHost: instanceHost.value,
              userData: userData.value,
              query: searchInputController.text,
            ),
          )
        : null;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextField(
            controller: searchInputController,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.center,
            onSubmitted: (_) => handleSearch(),
            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },
            decoration: InputDecoration(
                hintText: L10n.of(context).search,
                suffixIcon: searchInputController.text.isNotEmpty
                    ? IconButton(
                        onPressed: searchInputController.clear,
                        icon: const Icon(Icons.highlight_remove_rounded),
                      )
                    : null),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text('account:',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              Expanded(
                child: RadioPicker<String>(
                  values: accStore
                      .allUserData()
                      .map((user) => user.toString())
                      .toList()
                    ..addAll(accStore.anonymousInstances()),
                  groupValue: (userData.value ?? instanceHost.value).toString(),
                  onChanged: (value) {
                    if (value.contains('@')) {
                      userData.value = accStore.userDataFromString(value);
                      instanceHost.value = null;
                    } else {
                      userData.value = null;
                      instanceHost.value = value;
                    }
                  },
                  buttonBuilder: (context, displayValue, onPressed) =>
                      FilledButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(displayValue),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (searchInputController.text.isNotEmpty)
            ElevatedButton(
              onPressed: handleSearch,
              child: Text(L10n.of(context).search),
            )
        ],
      ),
    );
  }
}

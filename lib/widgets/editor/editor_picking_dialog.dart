import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../../util/extensions/api.dart';
import '../../../widgets/avatar.dart';
import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import 'editor_toolbar_store.dart';

class PickPersonDialog extends StatelessWidget {
  final EditorToolbarStore store;

  const PickPersonDialog._(this.store);

  @override
  Widget build(BuildContext context) {
    final userData =
        context.read<AccountsStore>().defaultUserDataFor(store.instanceHost);

    return AlertDialog(
      title: Text(L10n.of(context).select_user),
      content: TypeAheadField<PersonViewSafe>(
        suggestionsCallback: (pattern) async {
          if (pattern.trim().isEmpty) return const Iterable.empty();
          return LemmyApiV3(store.instanceHost)
              .run(Search(
                q: pattern,
                auth: userData?.jwt.raw,
                type: SearchType.users,
                limit: 10,
              ))
              .then((value) => value.users);
        },
        itemBuilder: (context, user) {
          return ListTile(
            leading: Avatar(
              url: user.person.avatar,
              radius: 20,
            ),
            title: Text(user.person.originPreferredName),
          );
        },
        onSuggestionSelected: (suggestion) =>
            Navigator.of(context).pop(suggestion),
        loadingBuilder: (context) => const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ],
        ),
        keepSuggestionsOnLoading: false,
        noItemsFoundBuilder: (context) => const SizedBox(),
        hideOnEmpty: true,
        textFieldConfiguration: const TextFieldConfiguration(autofocus: true),
      ),
    );
  }

  static Future<PersonViewSafe?> show(BuildContext context) async {
    final store = context.read<EditorToolbarStore>();
    return showDialog(
      context: context,
      builder: (context) => PickPersonDialog._(store),
    );
  }
}

class PickCommunityDialog extends StatelessWidget {
  final EditorToolbarStore store;

  const PickCommunityDialog._(this.store);

  @override
  Widget build(BuildContext context) {
    final userData =
        context.read<AccountsStore>().defaultUserDataFor(store.instanceHost);

    return AlertDialog(
      title: Text(L10n.of(context).select_community),
      content: TypeAheadField<CommunityView>(
        suggestionsCallback: (pattern) async {
          if (pattern.trim().isEmpty) return const Iterable.empty();
          return LemmyApiV3(store.instanceHost)
              .run(Search(
                q: pattern,
                auth: userData?.jwt.raw,
                type: SearchType.communities,
                limit: 10,
              ))
              .then((value) => value.communities);
        },
        itemBuilder: (context, community) {
          return ListTile(
            leading: Avatar(
              url: community.community.icon,
              radius: 20,
            ),
            title: Text(community.community.originPreferredName),
          );
        },
        onSuggestionSelected: (suggestion) =>
            Navigator.of(context).pop(suggestion),
        loadingBuilder: (context) => const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator.adaptive(),
            ),
          ],
        ),
        keepSuggestionsOnLoading: false,
        noItemsFoundBuilder: (context) => const SizedBox(),
        hideOnEmpty: true,
        textFieldConfiguration: const TextFieldConfiguration(autofocus: true),
      ),
    );
  }

  static Future<CommunityView?> show(BuildContext context) async {
    final store = context.read<EditorToolbarStore>();
    return showDialog(
      context: context,
      builder: (context) => PickCommunityDialog._(store),
    );
  }
}

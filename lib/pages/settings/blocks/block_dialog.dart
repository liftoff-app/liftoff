import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../../util/extensions/api.dart';
import '../../../widgets/avatar.dart';
import 'blocks_store.dart';

class BlockPersonDialog extends StatelessWidget {
  const BlockPersonDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Expanded(child: Text('Block User')),
        ],
      ),
      content: TypeAheadField<PersonViewSafe>(
        suggestionsCallback: (pattern) async {
          if (pattern.trim().isEmpty) return const Iterable.empty();
          return LemmyApiV3(context.read<BlocksStore>().instanceHost)
              .run(Search(
                q: pattern,
                auth: context.read<BlocksStore>().token.raw,
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
        loadingBuilder: (context) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
    final store = context.read<BlocksStore>();
    return showDialog(
      context: context,
      builder: (context) => Provider.value(
        value: store,
        child: const BlockPersonDialog(),
      ),
    );
  }
}

class BlockCommunityDialog extends StatelessWidget {
  const BlockCommunityDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: const [
          Expanded(child: Text('Block Community')),
        ],
      ),
      content: TypeAheadField<CommunityView>(
        suggestionsCallback: (pattern) async {
          if (pattern.trim().isEmpty) return const Iterable.empty();
          return LemmyApiV3(context.read<BlocksStore>().instanceHost)
              .run(Search(
                q: pattern,
                auth: context.read<BlocksStore>().token.raw,
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
        loadingBuilder: (context) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
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
    final store = context.read<BlocksStore>();
    return showDialog(
      context: context,
      builder: (context) => Provider.value(
        value: store,
        child: const BlockCommunityDialog(),
      ),
    );
  }
}

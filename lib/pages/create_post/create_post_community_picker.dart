import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../l10n/l10n.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/api.dart';
import '../../util/extensions/context.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/avatar.dart';
import 'create_post_store.dart';

class CreatePostCommunityPicker extends HookWidget {
  const CreatePostCommunityPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = context.read<CreatePostStore>();
    final controller = useTextEditingController(
      text: store.selectedCommunity != null
          ? _communityString(store.selectedCommunity!)
          : '',
    );

    return AsyncStoreListener(
      asyncStore: context.read<CreatePostStore>().searchCommunitiesState,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && store.selectedCommunity == null) {
            controller.text = '';
          }
        },
        child: ObserverBuilder<CreatePostStore>(builder: (context, store) {
          return TypeAheadFormField<CommunityView>(
            textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              enabled: !store.isEdit,
              decoration: InputDecoration(
                hintText: L10n.of(context).community,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                suffixIcon: store.selectedCommunity == null
                    ? const Icon(Icons.arrow_drop_down)
                    : IconButton(
                        onPressed: () {
                          store.selectedCommunity = null;
                          controller.clear();
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              onChanged: (_) => store.selectedCommunity = null,
            ),
            validator: Validators.required(L10n.of(context).required_field),
            suggestionsCallback: (pattern) async {
              final communities = await store.searchCommunities(
                pattern,
                context.defaultJwt(store.instanceHost),
              );

              return communities ?? [];
            },
            itemBuilder: (context, community) {
              return ListTile(
                leading: Avatar(
                  url: community.community.icon,
                  radius: 20,
                ),
                title: Text(_communityString(community)),
              );
            },
            onSuggestionSelected: (community) {
              store.selectedCommunity = community;
              controller.text = _communityString(community);
            },
            noItemsFoundBuilder: (context) => SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  L10n.of(context).no_communities_found,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            loadingBuilder: (context) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator.adaptive(),
                ),
              ],
            ),
            debounceDuration: const Duration(milliseconds: 400),
          );
        }),
      ),
    );
  }
}

String _communityString(CommunityView communityView) {
  if (communityView.community.local) {
    return communityView.community.title;
  } else {
    return '${communityView.community.originInstanceHost}/${communityView.community.title}';
  }
}

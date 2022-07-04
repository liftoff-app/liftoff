import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../hooks/logged_in_action.dart';
import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/spaced.dart';
import '../../util/mobx_provider.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/editor/editor.dart';
import '../../widgets/markdown_mode_icon.dart';
import 'create_post_community_picker.dart';
import 'create_post_instance_picker.dart';
import 'create_post_store.dart';
import 'create_post_url_field.dart';

/// Modal for creating a post to some community in some instance
/// Pops the navigator stack with a [PostView]
class CreatePostPage extends HookWidget {
  const CreatePostPage();

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final loggedInAction = useLoggedInAction(
      useStore((CreatePostStore store) => store.instanceHost),
    );

    final titleFocusNode = useFocusNode();

    handleSubmit(Jwt token) async {
      if (formKey.currentState!.validate()) {
        await context.read<CreatePostStore>().submit(token);
      }
    }

    final title = ObserverBuilder<CreatePostStore>(
      builder: (context, store) => TextFormField(
        initialValue: store.title,
        focusNode: titleFocusNode,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        validator: Validators.required(L10n.of(context).required_field),
        onChanged: (title) => store.title = title,
        minLines: 1,
        maxLines: 2,
        decoration: InputDecoration(labelText: L10n.of(context).title),
      ),
    );

    final bodyController =
        useTextEditingController(text: context.read<CreatePostStore>().body);

    final body = ObserverBuilder<CreatePostStore>(
      builder: (context, store) => Editor(
        controller: bodyController,
        onChanged: (body) => store.body = body,
        labelText: L10n.of(context).body,
        instanceHost: store.instanceHost,
        fancy: store.showFancy,
      ),
    );

    return AsyncStoreListener<PostView>(
      asyncStore: context.read<CreatePostStore>().submitState,
      onSuccess: (context, data) {
        Navigator.of(context).pop(data);
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ObserverBuilder<CreatePostStore>(
              builder: (context, store) => IconButton(
                icon: markdownModeIcon(fancy: store.showFancy),
                onPressed: () => store.showFancy = !store.showFancy,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(5),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      if (!context.read<CreatePostStore>().isEdit) ...const [
                        CreatePostInstancePicker(),
                        CreatePostCommunityPicker(),
                      ],
                      CreatePostUrlField(titleFocusNode),
                      title,
                      body,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ObserverBuilder<CreatePostStore>(
                            builder: (context, store) => GestureDetector(
                              onTap: () => store.nsfw = !store.nsfw,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: store.nsfw,
                                    onChanged: (val) {
                                      if (val != null) store.nsfw = val;
                                    },
                                  ),
                                  Text(L10n.of(context).nsfw)
                                ],
                              ),
                            ),
                          ),
                          ObserverBuilder<CreatePostStore>(
                            builder: (context, store) => TextButton(
                              onPressed: store.submitState.isLoading
                                  ? () {}
                                  : loggedInAction(handleSubmit),
                              child: store.submitState.isLoading
                                  ? const CircularProgressIndicator.adaptive()
                                  : Text(
                                      store.isEdit
                                          ? L10n.of(context).edit
                                          : L10n.of(context).post,
                                    ),
                            ),
                          )
                        ],
                      ),
                      Toolbar.safeArea,
                    ].spaced(6),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Toolbar(bodyController),
                ],
              ),
            ),
            // Positioned(
            //   bottom: MediaQuery.of(context).viewInsets.bottom,
            //   left: 0,
            //   right: 0,
            //   child: Toolbar(bodyController),
            // )
          ],
        ),
      ),
    );
  }

  static Route<PostView> route() => MaterialPageRoute(
        builder: (context) => MobxProvider(
          create: (context) => CreatePostStore(
            instanceHost: context.read<AccountsStore>().loggedInInstances.first,
          ),
          child: const CreatePostPage(),
        ),
        fullscreenDialog: true,
      );

  static Route<PostView> toCommunityRoute(CommunityView community) =>
      MaterialPageRoute(
        builder: (context) => MobxProvider(
          create: (context) => CreatePostStore(
            instanceHost: community.instanceHost,
            selectedCommunity: community,
          ),
          child: const CreatePostPage(),
        ),
        fullscreenDialog: true,
      );

  static Route<PostView> editRoute(Post post) => MaterialPageRoute(
        builder: (context) => MobxProvider(
          create: (context) => CreatePostStore(
            instanceHost: post.instanceHost,
            postToEdit: post,
          ),
          child: const CreatePostPage(),
        ),
        fullscreenDialog: true,
      );
}

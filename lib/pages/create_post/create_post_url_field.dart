import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/logged_in_action.dart';
import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../util/observer_consumers.dart';
import '../pick_image.dart';
import 'create_post_store.dart';

class CreatePostUrlField extends HookWidget {
  final FocusNode titleFocusNode;

  const CreatePostUrlField(this.titleFocusNode, {super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.read<CreatePostStore>().url,
    );
    final loggedInAction = useLoggedInAction(
      useStore((CreatePostStore store) => store.instanceHost),
    );

    uploadImage(UserData userData) async {
      final pic = await Navigator.of(context).push(
        PickImagePage.route(),
      );

      // pic is null when the picker was cancelled
      if (pic != null && context.mounted) {
        await context.read<CreatePostStore>().uploadImage(pic.path, userData);
      }
    }

    return ObserverConsumer<CreatePostStore>(
      listener: (context, store) {
        // needed to keep the controller and store data in sync
        if (controller.text != store.url) {
          controller.text = store.url;
        }
      },
      builder: (context, store) => Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: !store.hasUploadedImage,
              autofillHints:
                  !store.hasUploadedImage ? const [AutofillHints.url] : null,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => titleFocusNode.requestFocus(),
              onChanged: (url) => store.url = url,
              decoration: InputDecoration(
                labelText: L10n.of(context).url,
                suffixIcon: const Icon(Icons.link),
              ),
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            icon: store.imageUploadState.isLoading
                ? const CircularProgressIndicator.adaptive()
                : Icon(
                    store.hasUploadedImage
                        ? Icons.close
                        : Icons.add_photo_alternate,
                  ),
            onPressed: store.hasUploadedImage
                ? () => store.removeImage()
                : loggedInAction(uploadImage),
          ),
        ],
      ),
    );
  }
}

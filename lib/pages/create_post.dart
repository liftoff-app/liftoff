import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lemmy_api_client/pictrs.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/image_picker.dart';
import '../hooks/logged_in_action.dart';
import '../hooks/memo_future.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/extensions/api.dart';
import '../util/extensions/spaced.dart';
import '../util/goto.dart';
import '../util/pictrs.dart';
import '../util/unawaited.dart';
import '../widgets/markdown_mode_icon.dart';
import '../widgets/markdown_text.dart';
import '../widgets/radio_picker.dart';
import 'full_post.dart';

/// Fab that triggers the [CreatePost] modal
class CreatePostFab extends HookWidget {
  final CommunityView community;

  const CreatePostFab({this.community});

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(null, any: true);

    return FloatingActionButton(
      onPressed: loggedInAction((_) => showCupertinoModalPopup(
          context: context,
          builder: (_) => CreatePostPage.toCommunity(community))),
      child: const Icon(Icons.add),
    );
  }
}

/// Modal for creating a post to some community in some instance
class CreatePostPage extends HookWidget {
  final CommunityView community;

  const CreatePostPage() : community = null;
  const CreatePostPage.toCommunity(this.community);

  @override
  Widget build(BuildContext context) {
    final urlController = useTextEditingController();
    final titleController = useTextEditingController();
    final bodyController = useTextEditingController();
    final accStore = useAccountsStore();
    final selectedInstance =
        useState(community?.instanceHost ?? accStore.loggedInInstances.first);
    final selectedCommunity = useState(community);
    final showFancy = useState(false);
    final nsfw = useState(false);
    final delayed = useDelayedLoading();
    final imagePicker = useImagePicker();
    final imageUploadLoading = useState(false);
    final pictrsDeleteToken = useState<PictrsUploadFile>(null);

    final allCommunitiesSnap = useMemoFuture(
      () => LemmyApiV3(selectedInstance.value)
          .run(ListCommunities(
        type: PostListingType.all,
        sort: SortType.hot,
        limit: 9999,
        auth: accStore.defaultTokenFor(selectedInstance.value).raw,
      ))
          .then(
        (value) {
          value.sort((a, b) => a.community.name.compareTo(b.community.name));
          return value;
        },
      ),
      [selectedInstance.value],
    );

    uploadPicture() async {
      try {
        final pic = await imagePicker.getImage(source: ImageSource.gallery);
        // pic is null when the picker was cancelled
        if (pic != null) {
          imageUploadLoading.value = true;

          final token = accStore.defaultTokenFor(selectedInstance.value);
          final pictrs = PictrsApi(selectedInstance.value);
          final upload =
              await pictrs.upload(filePath: pic.path, auth: token.raw);
          pictrsDeleteToken.value = upload.files[0];
          urlController.text =
              pathToPictrs(selectedInstance.value, upload.files[0].file);
        }
        print(urlController.text);
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')));
      } finally {
        imageUploadLoading.value = false;
      }
    }

    removePicture() {
      PictrsApi(selectedInstance.value)
          .delete(pictrsDeleteToken.value)
          .catchError((_) {});

      pictrsDeleteToken.value = null;
      urlController.text = '';
    }

    final instanceDropdown = RadioPicker<String>(
      values: accStore.loggedInInstances.toList(),
      groupValue: selectedInstance.value,
      onChanged: (value) => selectedInstance.value = value,
      buttonBuilder: (context, displayValue, onPressed) => TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(displayValue),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );

    DropdownMenuItem<int> communityDropDownItem(CommunityView e) =>
        DropdownMenuItem(
          value: e.community.id,
          child: Text(e.community.local
              ? e.community.name
              : '${e.community.originInstanceHost}/${e.community.name}'),
        );

    List<DropdownMenuItem<int>> communitiesList() {
      if (allCommunitiesSnap.hasData) {
        return allCommunitiesSnap.data.map(communityDropDownItem).toList();
      } else {
        if (selectedCommunity.value != null) {
          return [communityDropDownItem(selectedCommunity.value)];
        } else {
          return const [
            DropdownMenuItem(
              value: -1,
              child: CircularProgressIndicator(),
            )
          ];
        }
      }
    }

    // TODO: use lazy autocomplete
    final communitiesDropdown = InputDecorator(
      decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedCommunity.value?.community?.id,
          hint: Text(L10n.of(context).community),
          onChanged: (communityId) => selectedCommunity.value =
              allCommunitiesSnap.data
                  ?.firstWhere((e) => e.community.id == communityId),
          items: communitiesList(),
        ),
      ),
    );

    final url = Row(children: [
      Expanded(
        child: TextField(
          enabled: pictrsDeleteToken.value == null,
          controller: urlController,
          decoration: InputDecoration(
            labelText: L10n.of(context).url,
            suffixIcon: const Icon(Icons.link),
          ),
        ),
      ),
      const SizedBox(width: 5),
      IconButton(
        icon: imageUploadLoading.value
            ? const CircularProgressIndicator()
            : Icon(pictrsDeleteToken.value == null
                ? Icons.add_photo_alternate
                : Icons.close),
        onPressed:
            pictrsDeleteToken.value == null ? uploadPicture : removePicture,
        tooltip:
            pictrsDeleteToken.value == null ? 'Add picture' : 'Delete picture',
      )
    ]);

    final title = TextField(
      controller: titleController,
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(labelText: L10n.of(context).title),
    );

    final body = IndexedStack(
      index: showFancy.value ? 1 : 0,
      children: [
        TextField(
          controller: bodyController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          minLines: 5,
          decoration: InputDecoration(labelText: L10n.of(context).body),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: MarkdownText(
            bodyController.text,
            instanceHost: selectedInstance.value,
          ),
        ),
      ],
    );

    handleSubmit() async {
      if (selectedCommunity.value == null || titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Choosing a community and a title is required'),
        ));
        return;
      }

      final api = LemmyApiV3(selectedInstance.value);

      final token = accStore.defaultTokenFor(selectedInstance.value);

      delayed.start();
      try {
        final res = await api.run(CreatePost(
          url: urlController.text.isEmpty ? null : urlController.text,
          body: bodyController.text.isEmpty ? null : bodyController.text,
          nsfw: nsfw.value,
          name: titleController.text,
          communityId: selectedCommunity.value.community.id,
          auth: token.raw,
        ));
        unawaited(goToReplace(context, (_) => FullPostPage.fromPostView(res)));
        return;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to post')));
      }
      delayed.cancel();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        actions: [
          IconButton(
            icon: markdownModeIcon(fancy: showFancy.value),
            onPressed: () => showFancy.value = !showFancy.value,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(5),
          children: [
            instanceDropdown,
            communitiesDropdown,
            url,
            title,
            body,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => nsfw.value = !nsfw.value,
                  child: Row(
                    children: [
                      Checkbox(
                        value: nsfw.value,
                        onChanged: (val) => nsfw.value = val,
                      ),
                      Text(L10n.of(context).nsfw)
                    ],
                  ),
                ),
                TextButton(
                  onPressed: delayed.pending ? () {} : handleSubmit,
                  child: delayed.loading
                      ? const CircularProgressIndicator()
                      : Text(L10n.of(context).post),
                )
              ],
            ),
          ].spaced(6),
        ),
      ),
    );
  }
}

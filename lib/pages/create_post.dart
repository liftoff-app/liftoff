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
import '../widgets/editor.dart';
import '../widgets/markdown_mode_icon.dart';
import '../widgets/radio_picker.dart';
import 'full_post.dart';

/// Fab that triggers the [CreatePost] modal
/// After creation it will navigate to the newly created post
class CreatePostFab extends HookWidget {
  final CommunityView? community;

  const CreatePostFab({this.community});

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useAnyLoggedInAction();

    return FloatingActionButton(
      onPressed: loggedInAction((_) async {
        final postView = await showCupertinoModalPopup<PostView>(
          context: context,
          builder: (_) => community == null
              ? const CreatePostPage()
              : CreatePostPage.toCommunity(community!),
        );

        if (postView != null) {
          await goTo(
            context,
            (_) => FullPostPage.fromPostView(postView),
          );
        }
      }),
      child: const Icon(Icons.add),
    );
  }
}

/// Modal for creating a post to some community in some instance
/// Pops the navigator stack with a [PostView]
class CreatePostPage extends HookWidget {
  final CommunityView? community;

  final bool _isEdit;
  final Post? post;

  const CreatePostPage()
      : community = null,
        _isEdit = false,
        post = null;
  const CreatePostPage.toCommunity(CommunityView this.community)
      : _isEdit = false,
        post = null;
  const CreatePostPage.edit(this.post)
      : _isEdit = true,
        community = null;

  @override
  Widget build(BuildContext context) {
    final urlController =
        useTextEditingController(text: _isEdit ? post?.url : null);
    final titleController =
        useTextEditingController(text: _isEdit ? post?.name : null);
    final bodyController =
        useTextEditingController(text: _isEdit ? post?.body : null);
    final accStore = useAccountsStore();
    final selectedInstance = useState(_isEdit
        ? post!.instanceHost
        : community?.instanceHost ?? accStore.loggedInInstances.first);
    final selectedCommunity = useState(community);
    final showFancy = useState(false);
    final nsfw = useState(_isEdit && post!.nsfw);
    final delayed = useDelayedLoading();
    final imagePicker = useImagePicker();
    final imageUploadLoading = useState(false);
    final pictrsDeleteToken = useState<PictrsUploadFile?>(null);
    final loggedInAction = useLoggedInAction(selectedInstance.value);

    final titleFocusNode = useFocusNode();
    final bodyFocusNode = useFocusNode();

    final allCommunitiesSnap = useMemoFuture(
      () => LemmyApiV3(selectedInstance.value)
          .run(ListCommunities(
        type: PostListingType.all,
        sort: SortType.hot,
        limit: 9999,
        auth: accStore.defaultUserDataFor(selectedInstance.value)?.jwt.raw,
      ))
          .then(
        (value) {
          value.sort((a, b) => a.community.name.compareTo(b.community.name));
          return value;
        },
      ),
      [selectedInstance.value],
    );

    uploadPicture(Jwt token) async {
      try {
        final pic = await imagePicker.pickImage(source: ImageSource.gallery);
        // pic is null when the picker was cancelled
        if (pic != null) {
          imageUploadLoading.value = true;

          final pictrs = PictrsApi(selectedInstance.value);
          final upload =
              await pictrs.upload(filePath: pic.path, auth: token.raw);
          pictrsDeleteToken.value = upload.files[0];
          urlController.text =
              pathToPictrs(selectedInstance.value, upload.files[0].file);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')));
      } finally {
        imageUploadLoading.value = false;
      }
    }

    removePicture(PictrsUploadFile deleteToken) {
      PictrsApi(selectedInstance.value).delete(deleteToken).catchError((_) {});

      pictrsDeleteToken.value = null;
      urlController.text = '';
    }

    final instanceDropdown = RadioPicker<String>(
      values: accStore.loggedInInstances.toList(),
      groupValue: selectedInstance.value,
      onChanged: _isEdit ? null : (value) => selectedInstance.value = value,
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
        return allCommunitiesSnap.data!.map(communityDropDownItem).toList();
      } else {
        if (selectedCommunity.value != null) {
          return [communityDropDownItem(selectedCommunity.value!)];
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

    handleSubmit(Jwt token) async {
      if ((!_isEdit && selectedCommunity.value == null) ||
          titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Choosing a community and a title is required'),
        ));
        return;
      }

      final api = LemmyApiV3(selectedInstance.value);

      delayed.start();
      try {
        final res = await () {
          if (_isEdit) {
            return api.run(EditPost(
              url: urlController.text.isEmpty ? null : urlController.text,
              body: bodyController.text.isEmpty ? null : bodyController.text,
              nsfw: nsfw.value,
              name: titleController.text,
              postId: post!.id,
              auth: token.raw,
            ));
          } else {
            return api.run(CreatePost(
              url: urlController.text.isEmpty ? null : urlController.text,
              body: bodyController.text.isEmpty ? null : bodyController.text,
              nsfw: nsfw.value,
              name: titleController.text,
              communityId: selectedCommunity.value!.community.id,
              auth: token.raw,
            ));
          }
        }();
        Navigator.of(context).pop(res);
        return;
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to post')));
      }
      delayed.cancel();
    }

    // TODO: use lazy autocomplete
    final communitiesDropdown = InputDecorator(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedCommunity.value?.community.id,
          hint: Text(L10n.of(context)!.community),
          onChanged: _isEdit
              ? null
              : (communityId) {
                  selectedCommunity.value = allCommunitiesSnap.data
                      ?.firstWhere((e) => e.community.id == communityId);
                },
          items: communitiesList(),
        ),
      ),
    );

    final enabledUrlField = pictrsDeleteToken.value == null;

    final url = Row(children: [
      Expanded(
        child: TextField(
          enabled: enabledUrlField,
          controller: urlController,
          autofillHints: enabledUrlField ? const [AutofillHints.url] : null,
          keyboardType: TextInputType.url,
          onSubmitted: (_) => titleFocusNode.requestFocus(),
          decoration: InputDecoration(
            labelText: L10n.of(context)!.url,
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
        onPressed: pictrsDeleteToken.value == null
            ? loggedInAction(uploadPicture)
            : () => removePicture(pictrsDeleteToken.value!),
        tooltip:
            pictrsDeleteToken.value == null ? 'Add picture' : 'Delete picture',
      )
    ]);

    final title = TextField(
      controller: titleController,
      focusNode: titleFocusNode,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      onSubmitted: (_) => bodyFocusNode.requestFocus(),
      minLines: 1,
      maxLines: 2,
      decoration: InputDecoration(labelText: L10n.of(context)!.title),
    );

    final body = Editor(
      controller: bodyController,
      focusNode: bodyFocusNode,
      onSubmitted: (_) =>
          delayed.pending ? () {} : loggedInAction(handleSubmit),
      labelText: L10n.of(context)!.body,
      instanceHost: selectedInstance.value,
      fancy: showFancy.value,
    );

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
            if (!_isEdit) communitiesDropdown,
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
                        onChanged: (val) {
                          if (val != null) nsfw.value = val;
                        },
                      ),
                      Text(L10n.of(context)!.nsfw)
                    ],
                  ),
                ),
                TextButton(
                  onPressed:
                      delayed.pending ? () {} : loggedInAction(handleSubmit),
                  child: delayed.loading
                      ? const CircularProgressIndicator()
                      : Text(_isEdit
                          ? L10n.of(context)!.edit
                          : L10n.of(context)!.post),
                )
              ],
            ),
          ].spaced(6),
        ),
      ),
    );
  }
}

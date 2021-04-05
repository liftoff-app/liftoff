import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lemmy_api_client/pictrs.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/image_picker.dart';
import '../hooks/ref.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../util/pictrs.dart';
import '../widgets/bottom_safe.dart';
import '../widgets/radio_picker.dart';

/// Page for managing things like username, email, avatar etc
/// This page will assume the manage account is logged in and
/// its token is in AccountsStore
class ManageAccountPage extends HookWidget {
  final String instanceHost;
  final String username;

  const ManageAccountPage(
      {@required this.instanceHost, @required this.username})
      : assert(instanceHost != null),
        assert(username != null);

  @override
  Widget build(BuildContext context) {
    final accountStore = useAccountsStore();

    final userFuture = useMemoized(() async {
      final site = await LemmyApiV3(instanceHost).run(
          GetSite(auth: accountStore.tokenFor(instanceHost, username).raw));

      return site.myUser;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('@$instanceHost@$username'),
      ),
      body: FutureBuilder<LocalUserSettingsView>(
        future: userFuture,
        builder: (_, userSnap) {
          if (userSnap.hasError) {
            return Center(child: Text('Error: ${userSnap.error?.toString()}'));
          }
          if (!userSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return _ManageAccount(user: userSnap.data);
        },
      ),
    );
  }
}

class _ManageAccount extends HookWidget {
  const _ManageAccount({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  final LocalUserSettingsView user;

  @override
  Widget build(BuildContext context) {
    final accountsStore = useAccountsStore();
    final theme = Theme.of(context);
    final saveDelayedLoading = useDelayedLoading();
    final deleteDelayedLoading = useDelayedLoading();

    final displayNameController =
        useTextEditingController(text: user.person.preferredUsername);
    final bioController = useTextEditingController(text: user.person.bio);
    final emailController =
        useTextEditingController(text: user.localUser.email);
    final matrixUserController =
        useTextEditingController(text: user.person.matrixUserId);
    final avatar = useRef(user.person.avatar);
    final banner = useRef(user.person.banner);
    final showAvatars = useState(user.localUser.showAvatars);
    final showNsfw = useState(user.localUser.showNsfw);
    final sendNotificationsToEmail =
        useState(user.localUser.sendNotificationsToEmail);
    final defaultListingType = useState(user.localUser.defaultListingType);
    final defaultSortType = useState(user.localUser.defaultSortType);
    final newPasswordController = useTextEditingController();
    final newPasswordVerifyController = useTextEditingController();
    final oldPasswordController = useTextEditingController();

    final informAcceptedAvatarRef = useRef<VoidCallback>(null);
    final informAcceptedBannerRef = useRef<VoidCallback>(null);

    final deleteAccountPasswordController = useTextEditingController();

    final token = accountsStore.tokenFor(user.instanceHost, user.person.name);

    handleSubmit() async {
      saveDelayedLoading.start();

      try {
        await LemmyApiV3(user.instanceHost).run(SaveUserSettings(
          showNsfw: showNsfw.value,
          theme: user.localUser.theme,
          defaultSortType: defaultSortType.value,
          defaultListingType: defaultListingType.value,
          lang: user.localUser.lang,
          showAvatars: showAvatars.value,
          sendNotificationsToEmail: sendNotificationsToEmail.value,
          auth: token.raw,
          avatar: avatar.current,
          banner: banner.current,
          newPassword: newPasswordController.text.isEmpty
              ? null
              : newPasswordController.text,
          newPasswordVerify: newPasswordVerifyController.text.isEmpty
              ? null
              : newPasswordVerifyController.text,
          oldPassword: oldPasswordController.text.isEmpty
              ? null
              : oldPasswordController.text,
          matrixUserId: matrixUserController.text.isEmpty
              ? null
              : matrixUserController.text,
          preferredUsername: displayNameController.text.isEmpty
              ? null
              : displayNameController.text,
          bio: bioController.text.isEmpty ? null : bioController.text,
          email: emailController.text.isEmpty ? null : emailController.text,
        ));

        informAcceptedAvatarRef.current();
        informAcceptedBannerRef.current();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User settings saved'),
        ));
      } on Exception catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      } finally {
        saveDelayedLoading.cancel();
      }
    }

    deleteAccountDialog() async {
      final confirmDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  '${L10n.of(context).delete_account} @${user.instanceHost}@${user.person.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(L10n.of(context).delete_account_confirm),
                  const SizedBox(height: 10),
                  TextField(
                    controller: deleteAccountPasswordController,
                    obscureText: true,
                    decoration:
                        InputDecoration(hintText: L10n.of(context).password),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(L10n.of(context).yes),
                ),
              ],
            ),
          ) ??
          false;

      if (confirmDelete) {
        deleteDelayedLoading.start();

        try {
          await LemmyApiV3(user.instanceHost).run(DeleteAccount(
            password: deleteAccountPasswordController.text,
            auth: token.raw,
          ));

          await accountsStore.removeAccount(
              user.instanceHost, user.person.name);
          Navigator.of(context).pop();
        } on Exception catch (err) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(err.toString()),
          ));
        }

        deleteDelayedLoading.cancel();
      } else {
        deleteAccountPasswordController.clear();
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        _ImagePicker(
          user: user,
          name: L10n.of(context).avatar,
          initialUrl: avatar.current,
          onChange: (value) => avatar.current = value,
          informAcceptedRef: informAcceptedAvatarRef,
        ),
        const SizedBox(height: 8),
        _ImagePicker(
          user: user,
          name: L10n.of(context).banner,
          initialUrl: banner.current,
          onChange: (value) => banner.current = value,
          informAcceptedRef: informAcceptedBannerRef,
        ),
        const SizedBox(height: 8),
        Text(L10n.of(context).display_name, style: theme.textTheme.headline6),
        TextField(controller: displayNameController),
        const SizedBox(height: 8),
        Text(L10n.of(context).bio, style: theme.textTheme.headline6),
        TextField(
          controller: bioController,
          minLines: 4,
          maxLines: 10,
        ),
        const SizedBox(height: 8),
        Text(L10n.of(context).email, style: theme.textTheme.headline6),
        TextField(controller: emailController),
        const SizedBox(height: 8),
        Text(L10n.of(context).matrix_user, style: theme.textTheme.headline6),
        TextField(controller: matrixUserController),
        const SizedBox(height: 8),
        Text(L10n.of(context).new_password, style: theme.textTheme.headline6),
        TextField(
          controller: newPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        Text(L10n.of(context).verify_password,
            style: theme.textTheme.headline6),
        TextField(
          controller: newPasswordVerifyController,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        Text(L10n.of(context).old_password, style: theme.textTheme.headline6),
        TextField(
          controller: oldPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10n.of(context).type),
                const Text(
                  'This has currently no effect on lemmur',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            RadioPicker<PostListingType>(
              values: const [
                PostListingType.all,
                PostListingType.local,
                PostListingType.subscribed,
              ],
              groupValue: defaultListingType.value,
              onChanged: (value) => defaultListingType.value = value,
              mapValueToString: (value) => value.value,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(L10n.of(context).sort_type),
                const Text(
                  'This has currently no effect on lemmur',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            RadioPicker<SortType>(
              values: SortType.values,
              groupValue: defaultSortType.value,
              onChanged: (value) => defaultSortType.value = value,
              mapValueToString: (value) => value.value,
            ),
          ],
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: showAvatars.value,
          onChanged: (checked) => showAvatars.value = checked,
          title: Text(L10n.of(context).show_avatars),
          subtitle: const Text('This has currently no effect on lemmur'),
          dense: true,
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: showNsfw.value,
          onChanged: (checked) => showNsfw.value = checked,
          title: Text(L10n.of(context).show_nsfw),
          subtitle: const Text('This has currently no effect on lemmur'),
          dense: true,
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: sendNotificationsToEmail.value,
          onChanged: (checked) => sendNotificationsToEmail.value = checked,
          title: Text(L10n.of(context).send_notifications_to_email),
          dense: true,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: saveDelayedLoading.loading ? null : handleSubmit,
          child: saveDelayedLoading.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : Text(L10n.of(context).save),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: deleteAccountDialog,
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: Text(L10n.of(context).delete_account.toUpperCase()),
        ),
        const BottomSafe(),
      ],
    );
  }
}

/// Picker and cleanuper for local images uploaded to pictrs
class _ImagePicker extends HookWidget {
  final String name;
  final String initialUrl;
  final LocalUserSettingsView user;
  final ValueChanged<String> onChange;

  /// _ImagePicker will set the ref to a callback that can inform _ImagePicker
  /// that the current picture is accepted
  /// and should no longer allow for deletion of it
  final Ref<VoidCallback> informAcceptedRef;

  const _ImagePicker({
    Key key,
    @required this.initialUrl,
    @required this.name,
    @required this.user,
    @required this.onChange,
    @required this.informAcceptedRef,
  })  : assert(name != null),
        assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // this is in case the passed initialUrl is changed,
    // basically saves the very first initialUrl
    final initialUrl = useRef(this.initialUrl);
    final theme = Theme.of(context);
    final url = useState(initialUrl.current);
    final pictrsDeleteToken = useState<PictrsUploadFile>(null);

    final imagePicker = useImagePicker();
    final accountsStore = useAccountsStore();
    final delayedLoading = useDelayedLoading();

    uploadImage() async {
      try {
        final pic = await imagePicker.getImage(source: ImageSource.gallery);
        // pic is null when the picker was cancelled
        if (pic != null) {
          delayedLoading.start();

          final upload = await PictrsApi(user.instanceHost).upload(
            filePath: pic.path,
            auth:
                accountsStore.tokenFor(user.instanceHost, user.person.name).raw,
          );
          pictrsDeleteToken.value = upload.files[0];
          url.value =
              pathToPictrs(user.instanceHost, pictrsDeleteToken.value.file);

          onChange?.call(url.value);
        }
      } on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to upload image')));
      }

      delayedLoading.cancel();
    }

    removePicture({bool updateState = true}) {
      PictrsApi(user.instanceHost)
          .delete(pictrsDeleteToken.value)
          .catchError((_) {});

      if (updateState) {
        pictrsDeleteToken.value = null;
        url.value = initialUrl.current;
        onChange?.call(url.value);
      }
    }

    useEffect(() {
      informAcceptedRef.current = () {
        pictrsDeleteToken.value = null;
        initialUrl.current = url.value;
      };

      return () {
        // remove picture from pictrs when exiting
        if (pictrsDeleteToken.value != null) {
          removePicture(updateState: false);
        }
      };
    }, []);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: theme.textTheme.headline6),
            if (pictrsDeleteToken.value == null)
              ElevatedButton(
                onPressed: delayedLoading.loading ? null : uploadImage,
                child: delayedLoading.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator())
                    : Row(
                        children: const [Text('upload'), Icon(Icons.publish)],
                      ),
              )
            else
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: removePicture,
              )
          ],
        ),
        if (url.value != null)
          CachedNetworkImage(
            imageUrl: url.value,
            errorWidget: (_, __, ___) => const Icon(Icons.error),
          ),
      ],
    );
  }
}

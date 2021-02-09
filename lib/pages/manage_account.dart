import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lemmy_api_client/pictrs.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/image_picker.dart';
import '../hooks/ref.dart';
import '../hooks/stores.dart';
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
      final site = await LemmyApiV2(instanceHost).run(
          GetSite(auth: accountStore.tokenFor(instanceHost, username).raw));

      return site.myUser;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('@$instanceHost@$username'),
      ),
      body: FutureBuilder<UserSafeSettings>(
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

  final UserSafeSettings user;

  @override
  Widget build(BuildContext context) {
    final accountsStore = useAccountsStore();
    final theme = Theme.of(context);
    final saveDelayedLoading = useDelayedLoading();
    final deleteDelayedLoading = useDelayedLoading();

    final displayNameController =
        useTextEditingController(text: user.preferredUsername);
    final bioController = useTextEditingController(text: user.bio);
    final emailController = useTextEditingController(text: user.email);
    final matrixUserController =
        useTextEditingController(text: user.matrixUserId);
    final avatar = useRef(user.avatar);
    final banner = useRef(user.banner);
    final showAvatars = useState(user.showAvatars);
    final showNsfw = useState(user.showNsfw);
    final sendNotificationsToEmail = useState(user.sendNotificationsToEmail);
    final defaultListingType = useState(user.defaultListingType);
    final defaultSortType = useState(user.defaultSortType);
    final newPasswordController = useTextEditingController();
    final newPasswordVerifyController = useTextEditingController();
    final oldPasswordController = useTextEditingController();

    final informAcceptedAvatarRef = useRef<VoidCallback>(null);
    final informAcceptedBannerRef = useRef<VoidCallback>(null);

    final deleteAccountPasswordController = useTextEditingController();

    final token = accountsStore.tokenFor(user.instanceHost, user.name);

    handleSubmit() async {
      saveDelayedLoading.start();

      try {
        await LemmyApiV2(user.instanceHost).run(SaveUserSettings(
          showNsfw: showNsfw.value,
          theme: user.theme,
          defaultSortType: defaultSortType.value,
          defaultListingType: defaultListingType.value,
          lang: user.lang,
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

        Scaffold.of(context).showSnackBar(const SnackBar(
          content: Text('User settings saved'),
        ));
      } on Exception catch (err) {
        Scaffold.of(context).showSnackBar(SnackBar(
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
              title: const Text('Remove account?'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to remove @${user.instanceHost}@${user.name}? '
                    'WARNING: this removes your account COMPLETELY, not from lemmur only',
                  ),
                  TextField(
                    controller: deleteAccountPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('no'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('yes'),
                ),
              ],
            ),
          ) ??
          false;

      if (confirmDelete) {
        deleteDelayedLoading.start();

        try {
          await LemmyApiV2(user.instanceHost).run(DeleteAccount(
            password: deleteAccountPasswordController.text,
            auth: token.raw,
          ));

          accountsStore.removeAccount(user.instanceHost, user.name);
          Navigator.of(context).pop();
        } on Exception catch (err) {
          Scaffold.of(context).showSnackBar(SnackBar(
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
          name: 'Avatar',
          initialUrl: avatar.current,
          onChange: (value) => avatar.current = value,
          informAcceptedRef: informAcceptedAvatarRef,
        ),
        const SizedBox(height: 8),
        _ImagePicker(
          user: user,
          name: 'Banner',
          initialUrl: banner.current,
          onChange: (value) => banner.current = value,
          informAcceptedRef: informAcceptedBannerRef,
        ),
        const SizedBox(height: 8),
        Text('Display Name', style: theme.textTheme.headline6),
        TextField(controller: displayNameController),
        const SizedBox(height: 8),
        Text('Bio', style: theme.textTheme.headline6),
        TextField(
          controller: bioController,
          minLines: 4,
          maxLines: 10,
        ),
        const SizedBox(height: 8),
        Text('Email', style: theme.textTheme.headline6),
        TextField(controller: emailController),
        const SizedBox(height: 8),
        Text('Matrix User', style: theme.textTheme.headline6),
        TextField(controller: matrixUserController),
        const SizedBox(height: 8),
        Text('New password', style: theme.textTheme.headline6),
        TextField(
          controller: newPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        Text('Verify password', style: theme.textTheme.headline6),
        TextField(
          controller: newPasswordVerifyController,
          obscureText: true,
        ),
        const SizedBox(height: 8),
        Text('Old password', style: theme.textTheme.headline6),
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
              children: const [
                Text('Sort type'),
                Text(
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
              children: const [
                Text('Type'),
                Text(
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
          title: const Text('Show avatars'),
          subtitle: const Text('This has currently no effect on lemmur'),
          dense: true,
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: showNsfw.value,
          onChanged: (checked) => showNsfw.value = checked,
          title: const Text('Show NSFW content'),
          subtitle: const Text('This has currently no effect on lemmur'),
          dense: true,
        ),
        const SizedBox(height: 8),
        CheckboxListTile(
          value: sendNotificationsToEmail.value,
          onChanged: (checked) => sendNotificationsToEmail.value = checked,
          title: const Text('Send notifications to Email'),
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
              : const Text('save'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: deleteAccountDialog,
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: const Text('DELETE ACCOUNT'),
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
  final UserSafeSettings user;
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
            auth: accountsStore.tokenFor(user.instanceHost, user.name).raw,
          );
          pictrsDeleteToken.value = upload.files[0];
          url.value =
              pathToPictrs(user.instanceHost, pictrsDeleteToken.value.file);

          onChange?.call(url.value);
        }
      } on Exception catch (_) {
        Scaffold.of(context).showSnackBar(
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

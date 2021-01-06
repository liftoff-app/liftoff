import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/image_picker.dart';
import '../hooks/ref.dart';
import '../hooks/stores.dart';
import '../util/pictrs.dart';

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
    final theme = Theme.of(context);

    final userFuture = useMemoized(() async {
      final site = await LemmyApi(instanceHost)
          .v1
          .getSite(auth: accountStore.tokens[instanceHost][username].raw);

      return site.myUser;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        brightness: theme.brightness,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        title:
            Text('$instanceHost@$username', style: theme.textTheme.headline6),
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
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

  final User user;

  @override
  Widget build(BuildContext context) {
    final accountStore = useAccountsStore();
    final theme = Theme.of(context);
    final delayedLoading = useDelayedLoading();

    final displayNameController =
        useTextEditingController(text: user.preferredUsername);
    final bioController = useTextEditingController(text: user.bio);
    final emailController = useTextEditingController(text: user.email);
    final avatar = useRef(user.avatar);
    final banner = useRef(user.banner);

    final token = accountStore.tokens[user.instanceHost][user.name];

    handleSubmit() async {
      delayedLoading.start();

      try {
        await LemmyApi(user.instanceHost).v1.saveUserSettings(
              showNsfw: user.showNsfw,
              theme: user.theme,
              defaultSortType: user.defaultSortType,
              defaultListingType: user.defaultListingType,
              lang: user.lang,
              showAvatars: user.showAvatars,
              sendNotificationsToEmail: user.sendNotificationsToEmail,
              auth: token.raw,
              avatar: avatar.current,
              banner: banner.current,
              preferredUsername: displayNameController.text.isEmpty
                  ? null
                  : displayNameController.text,
              bio: bioController.text.isEmpty ? null : bioController.text,
              email: emailController.text.isEmpty ? null : emailController.text,
            );
      } on Exception catch (err) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }

      delayedLoading.cancel();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        _ImagePicker(
          user: user,
          name: 'Avatar',
          initialUrl: avatar.current,
          onChange: (value) => avatar.current = value,
        ),
        const SizedBox(height: 8),
        _ImagePicker(
          user: user,
          name: 'Banner',
          initialUrl: banner.current,
          onChange: (value) => banner.current = value,
        ),
        const SizedBox(height: 8),
        Text('Display Name', style: theme.textTheme.headline6),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Bio', style: theme.textTheme.headline6),
        TextField(
          controller: bioController,
          minLines: 4,
          maxLines: 10,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('Email', style: theme.textTheme.headline6),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: delayedLoading.loading ? null : handleSubmit,
          style: ElevatedButton.styleFrom(
            // primary: Colors.red,
            visualDensity: VisualDensity.comfortable,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: delayedLoading.loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : const Text('save'),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            visualDensity: VisualDensity.comfortable,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('DELETE ACCOUNT'),
        ),
      ],
    );
  }
}

/// Picker and cleanuper for local images uploaded to pictrs
class _ImagePicker extends HookWidget {
  final String name;
  final String initialUrl;
  final User user;
  final ValueChanged<String> onChange;

  const _ImagePicker({
    Key key,
    @required this.initialUrl,
    @required this.name,
    @required this.user,
    @required this.onChange,
  })  : assert(name != null),
        assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final url = useState(initialUrl);
    final pictrsDeleteToken = useState<PictrsUploadFile>(null);

    final imagePicker = useImagePicker();
    final accountsStore = useAccountsStore();

    uploadImage() async {
      try {
        final pic = await imagePicker.getImage(source: ImageSource.gallery);
        // pic is null when the picker was cancelled
        if (pic != null) {
          final upload = await LemmyApi(user.instanceHost).pictrs.upload(
                filePath: pic.path,
                auth: accountsStore.tokens[user.instanceHost][user.name].raw,
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
    }

    removePicture({bool updateState = true}) {
      LemmyApi(user.instanceHost)
          .pictrs
          .delete(pictrsDeleteToken.value)
          .catchError((_) {});

      if (updateState) {
        pictrsDeleteToken.value = null;
        url.value = initialUrl;
      }
    }

    useEffect(
      () => () {
        // remove picture from pictrs when exiting
        if (pictrsDeleteToken.value != null) removePicture(updateState: false);
      },
      [],
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: theme.textTheme.headline6),
            if (pictrsDeleteToken.value == null)
              ElevatedButton(
                onPressed: uploadImage,
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.comfortable,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
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

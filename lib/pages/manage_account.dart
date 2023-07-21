import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/pictrs.dart';
import 'package:lemmy_api_client/v3.dart';

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../l10n/l10n.dart';
import '../url_launcher.dart';
import '../util/icons.dart';
import '../util/pictrs.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/bottom_safe.dart';
import '../widgets/cached_network_image.dart';
import '../widgets/editor/editor.dart';
import 'pick_image.dart';

// FIXME: Remove this when linting fix for this rule is in Flutter SDK
// See: https://github.com/dart-lang/linter/issues/4007
// ignore_for_file: use_build_context_synchronously

/// Page for managing things like username, email, avatar etc
/// This page will assume the manage account is logged in and
/// its token is in AccountsStore
class ManageAccountPage extends HookWidget {
  final String instanceHost;
  final String username;

  const ManageAccountPage(
      {super.key, required this.instanceHost, required this.username});

  @override
  Widget build(BuildContext context) {
    final accountStore = useAccountsStore();

    final userFuture = useMemoized(() async {
      final site = await LemmyApiV3(instanceHost).run(GetSite(
          auth: accountStore.userDataFor(instanceHost, username)!.jwt.raw));

      return site.myUser!.localUserView;
    });

    void privateOpenMoreMenu() {
      showBottomModal(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.open_in_browser),
              title: Text(L10n.of(context).open_in_browser),
              onTap: () async {
                final userProfileUrl =
                    await userFuture.then((e) => e.person.actorId);

                final didLaunch = await launchLink(
                  link: userProfileUrl,
                  context: context,
                );
                if (didLaunch) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$username@$instanceHost'),
        actions: [
          IconButton(icon: Icon(moreIcon), onPressed: privateOpenMoreMenu),
        ],
      ),
      body: FutureBuilder<LocalUserSettingsView>(
        future: userFuture,
        builder: (_, userSnap) {
          if (userSnap.hasError) {
            return Center(
                child: Text(L10n.of(context).error('${userSnap.error}')));
          }
          if (!userSnap.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          return _ManageAccount(user: userSnap.data!);
        },
      ),
    );
  }
}

class _ManageAccount extends HookWidget {
  const _ManageAccount({required this.user});

  final LocalUserSettingsView user;

  @override
  Widget build(BuildContext context) {
    final accountsStore = useAccountsStore();
    final theme = Theme.of(context);
    final saveDelayedLoading = useDelayedLoading();
    final removeDelayedLoading = useDelayedLoading();
    final deleteDelayedLoading = useDelayedLoading();

    final displayNameController =
        useTextEditingController(text: user.person.displayName);
    final emailController =
        useTextEditingController(text: user.localUser.email);
    final matrixUserController =
        useTextEditingController(text: user.person.matrixUserId);
    final avatar = useRef(user.person.avatar);
    final banner = useRef(user.person.banner);
    final showNsfw = useState(user.localUser.showNsfw);
    final botAccount = useState(user.person.botAccount);
    final showBotAccounts = useState(user.localUser.showBotAccounts);
    final showReadPosts = useState(user.localUser.showReadPosts);
    final sendNotificationsToEmail =
        useState(user.localUser.sendNotificationsToEmail);
    // TODO: bring back changing password
    // final newPasswordController = useTextEditingController();
    // final newPasswordVerifyController = useTextEditingController();
    // final oldPasswordController = useTextEditingController();

    final informAcceptedAvatarRef = useRef<VoidCallback?>(null);
    final informAcceptedBannerRef = useRef<VoidCallback?>(null);

    final removeAccountPasswordController = useTextEditingController();
    final deleteAccountPasswordController = useTextEditingController();

    final emailFocusNode = useFocusNode();
    final matrixUserFocusNode = useFocusNode();
    final newPasswordFocusNode = useFocusNode();
    // final verifyPasswordFocusNode = useFocusNode();
    // final oldPasswordFocusNode = useFocusNode();

    final bioController = useEditorController(
        instanceHost: user.instanceHost, text: user.person.bio);

    final token =
        accountsStore.userDataFor(user.instanceHost, user.person.name)?.jwt;

    handleSubmit() async {
      saveDelayedLoading.start();

      try {
        await LemmyApiV3(user.instanceHost).run(SaveUserSettings(
          showNsfw: showNsfw.value,
          theme: user.localUser.theme,
          /* Temp: disable saving these prefs until servers are all on >v0.18.x
          defaultSortType: user.localUser.defaultSortType,
          defaultListingType: user.localUser.defaultListingType,
          */
          interfaceLanguage: user.localUser.interfaceLanguage,
          showAvatars: user.localUser.showAvatars,
          botAccount: botAccount.value,
          showBotAccounts: showBotAccounts.value,
          showReadPosts: showReadPosts.value,
          sendNotificationsToEmail: sendNotificationsToEmail.value,
          auth: token!.raw,
          avatar: avatar.value,
          banner: banner.value,
          // Following values must all be set to value or '',
          // sending null just leaves any existing value unchanged.
          matrixUserId: matrixUserController.text,
          displayName: displayNameController.text,
          bio: bioController.textEditingController.text,
          email: emailController.text,
        ));

        informAcceptedAvatarRef.value?.call();
        informAcceptedBannerRef.value?.call();

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

    removeAccountDialog() async {
      final confirmRemove = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                  '${L10n.of(context).remove_account} @${user.instanceHost}@${user.person.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(L10n.of(context).remove_account_confirm),
                  const SizedBox(height: 10),
                  // TextField(
                  //   controller: removeAccountPasswordController,
                  //   autofillHints: const [AutofillHints.password],
                  //   keyboardType: TextInputType.visiblePassword,
                  //   obscureText: true,
                  //   decoration:
                  //       InputDecoration(hintText: L10n.of(context).password),
                  // )
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(L10n.of(context).yes),
                ),
              ],
            ),
          ) ??
          false;

      if (confirmRemove) {
        removeDelayedLoading.start();

        try {
          await accountsStore.removeAccount(
              user.instanceHost, user.person.name);
          Navigator.of(context).pop();
        } on Exception catch (err) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(err.toString()),
          ));
        }

        removeDelayedLoading.cancel();
      } else {
        removeAccountPasswordController.clear();
      }
    }

    // MYKL TODO: decide if we really want this functionality in a client.
    // ignore: unused_element
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
                    autofillHints: const [AutofillHints.password],
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration:
                        InputDecoration(hintText: L10n.of(context).password),
                  )
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                FilledButton(
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
          // MYKL - let's not do this just yet, even though we've warned the user that we will....
          // await LemmyApiV3(user.instanceHost).run(DeleteAccount(
          //   password: deleteAccountPasswordController.text,
          //   auth: token.raw,
          // ));

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

    if (token == null) {
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text('Account does not exist'),
      //   ));
      // });
      return Column(
        children: [Text(L10n.of(context).couldnt_find_that_account)],
      );
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          children: [
            _ImagePicker(
              user: user,
              name: L10n.of(context).avatar,
              initialUrl: avatar.value,
              onChange: (value) => avatar.value = value,
              informAcceptedRef: informAcceptedAvatarRef,
            ),
            const SizedBox(height: 8),
            _ImagePicker(
              user: user,
              name: L10n.of(context).banner,
              initialUrl: banner.value,
              onChange: (value) => banner.value = value,
              informAcceptedRef: informAcceptedBannerRef,
            ),
            const SizedBox(height: 8),
            Text(L10n.of(context).display_name,
                style: theme.textTheme.titleLarge),
            TextField(
              controller: displayNameController,
              onSubmitted: (_) => bioController.focusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            Text(L10n.of(context).bio, style: theme.textTheme.titleLarge),
            Editor(
              controller: bioController,
              onSubmitted: (_) => emailFocusNode.requestFocus(),
              maxLines: 10,
            ),
            const SizedBox(height: 8),
            Text(L10n.of(context).email, style: theme.textTheme.titleLarge),
            TextField(
              focusNode: emailFocusNode,
              controller: emailController,
              autofillHints: const [AutofillHints.email],
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (_) => matrixUserFocusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            Text(L10n.of(context).matrix_user,
                style: theme.textTheme.titleLarge),
            TextField(
              focusNode: matrixUserFocusNode,
              controller: matrixUserController,
              onSubmitted: (_) => newPasswordFocusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            // Text(L10n.of(context)!.new_password, style: theme.textTheme.headline6),
            // TextField(
            //   focusNode: newPasswordFocusNode,
            //   controller: newPasswordController,
            //   autofillHints: const [AutofillHints.newPassword],
            //   keyboardType: TextInputType.visiblePassword,
            //   obscureText: true,
            //   onSubmitted: (_) => verifyPasswordFocusNode.requestFocus(),
            // ),
            // const SizedBox(height: 8),
            // Text(L10n.of(context)!.verify_password,
            //     style: theme.textTheme.headline6),
            // TextField(
            //   focusNode: verifyPasswordFocusNode,
            //   controller: newPasswordVerifyController,
            //   autofillHints: const [AutofillHints.newPassword],
            //   keyboardType: TextInputType.visiblePassword,
            //   obscureText: true,
            //   onSubmitted: (_) => oldPasswordFocusNode.requestFocus(),
            // ),
            // const SizedBox(height: 8),
            // Text(L10n.of(context)!.old_password, style: theme.textTheme.headline6),
            // TextField(
            //   focusNode: oldPasswordFocusNode,
            //   controller: oldPasswordController,
            //   autofillHints: const [AutofillHints.password],
            //   keyboardType: TextInputType.visiblePassword,
            //   obscureText: true,
            // ),
            // const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: showNsfw.value,
              onChanged: (checked) {
                showNsfw.value = checked;
              },
              title: Text(L10n.of(context).show_nsfw),
              dense: true,
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: botAccount.value,
              onChanged: (checked) {
                botAccount.value = checked;
              },
              title: Text(L10n.of(context).bot_account),
              dense: true,
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: showBotAccounts.value,
              onChanged: (checked) {
                showBotAccounts.value = checked;
              },
              title: Text(L10n.of(context).show_bot_accounts),
              dense: true,
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: showReadPosts.value,
              onChanged: (checked) {
                showReadPosts.value = checked;
              },
              title: Text(L10n.of(context).show_read_posts),
              dense: true,
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              value: sendNotificationsToEmail.value,
              onChanged: (checked) {
                sendNotificationsToEmail.value = checked;
              },
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
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Text(L10n.of(context).save),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: removeAccountDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(L10n.of(context).remove_account.toUpperCase()),
            ),
            // MYKL - Hide the DELETE button for now...
            // ElevatedButton(
            //   onPressed: deleteAccountDialog,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //   ),
            //   child: Text(L10n.of(context).delete_account.toUpperCase()),
            // ),
            const BottomSafe(),
          ],
        ),
        BottomSticky(
          child: EditorToolbar(bioController),
        )
      ],
    );
  }
}

/// Picker and cleanuper for local images uploaded to pictrs
class _ImagePicker extends HookWidget {
  final String name;
  final String? initialUrl;
  final LocalUserSettingsView user;
  final ValueChanged<String?>? onChange;

  /// _ImagePicker will set the ref to a callback that can inform _ImagePicker
  /// that the current picture is accepted
  /// and should no longer allow for deletion of it
  final ObjectRef<VoidCallback?> informAcceptedRef;

  const _ImagePicker({
    required this.initialUrl,
    required this.name,
    required this.user,
    required this.onChange,
    required this.informAcceptedRef,
  });

  @override
  Widget build(BuildContext context) {
    // this is in case the passed initialUrl is changed,
    // basically saves the very first initialUrl
    final initialUrl = useRef(this.initialUrl);
    final theme = Theme.of(context);
    final url = useState(initialUrl.value);
    final pictrsDeleteToken = useState<PictrsUploadFile?>(null);

    final accountsStore = useAccountsStore();
    final delayedLoading = useDelayedLoading();

    uploadImage() async {
      try {
        final pic = await Navigator.of(context).push(
          PickImagePage.route(),
        );
        // pic is null when the picker was cancelled
        if (pic != null) {
          delayedLoading.start();

          final upload = await PictrsApi(user.instanceHost).upload(
            filePath: pic.path,
            auth: accountsStore
                .userDataFor(user.instanceHost, user.person.name)!
                .jwt
                .raw,
          );
          pictrsDeleteToken.value = upload.files[0];
          url.value =
              pathToPictrs(user.instanceHost, pictrsDeleteToken.value!.file);

          onChange?.call(url.value);
        }
      } on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(L10n.of(context).failed_to_upload_image)));
      }

      delayedLoading.cancel();
    }

    removePicture({
      bool updateState = true,
      required PictrsUploadFile pictrsToken,
    }) {
      PictrsApi(user.instanceHost).delete(pictrsToken).catchError((_) {});

      if (updateState) {
        pictrsDeleteToken.value = null;
        url.value = initialUrl.value;
        onChange?.call(url.value);
      }
    }

    useEffect(() {
      informAcceptedRef.value = () {
        pictrsDeleteToken.value = null;
        initialUrl.value = url.value;
      };

      return () {
        // remove picture from pictrs when exiting
        if (pictrsDeleteToken.value != null) {
          removePicture(
            updateState: false,
            pictrsToken: pictrsDeleteToken.value!,
          );
        }
      };
    }, []);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: theme.textTheme.titleLarge),
            if (pictrsDeleteToken.value == null)
              ElevatedButton(
                onPressed: delayedLoading.loading ? null : uploadImage,
                child: delayedLoading.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive())
                    : Row(
                        children: [Text(L10n.of(context).pick_a_photo)],
                      ),
              )
            else
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () =>
                    removePicture(pictrsToken: pictrsDeleteToken.value!),
              )
          ],
        ),
        if (url.value != null)
          CachedNetworkImage(
            imageUrl: url.value!,
            errorBuilder: (_, ___) => const Icon(Icons.error),
          ),
      ],
    );
  }
}

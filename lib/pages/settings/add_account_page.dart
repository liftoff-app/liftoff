import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';

import '../../hooks/delayed_loading.dart';
import '../../hooks/memo_future.dart';
import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../stores/config_store.dart';
import '../../url_launcher.dart';
import '../../util/text_color.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/fullscreenable_image.dart';
import '../../widgets/radio_picker.dart';
import '../display_document.dart';
import 'add_instance_page.dart';

/// A modal where an account can be added for a given instance
class AddAccountPage extends HookWidget {
  final String instanceHost;

  const AddAccountPage({required this.instanceHost});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final usernameController = useListenable(useTextEditingController());
    final passwordController = useListenable(useTextEditingController());
    final passwordFocusNode = useFocusNode();
    final totpController = useListenable(useTextEditingController());
    final totpFocusNode = useFocusNode();
    final accountsStore = useAccountsStore();
    final clickThroughFontSize =
        useStore((ConfigStore store) => store.postHeaderFontSize);
    final assetBundle = DefaultAssetBundle.of(context);
    final codeOfConductSnap =
        useMemoFuture(() => assetBundle.loadString('CODE_OF_CONDUCT.md'));
    final codeOfConduct = codeOfConductSnap.data ?? '';

    final loading = useDelayedLoading();
    final selectedInstance = useState(instanceHost);
    final icon = useState<String?>(null);

    useEffect(() {
      LemmyApiV3(selectedInstance.value)
          .run(const GetSite())
          .then((site) => icon.value = site.siteView?.site.icon);
      return null;
    }, [selectedInstance.value]);

    handleOnAdd() async {
      try {
        final isFirstAccount = accountsStore.hasNoAccount;

        // Let the addAccount() run and then check to see if it
        // succeeded. This means that a users' very first account creation will
        // run properly.
        if (isFirstAccount) {
          await accountsStore.setDefaultAccount(
              selectedInstance.value, usernameController.text);
        }

        loading.start();
        await accountsStore.addAccount(
          selectedInstance.value,
          usernameController.text,
          passwordController.text,
          totpController.text,
        );

        // addAccount() run failed, so clear the account.
        if (isFirstAccount && accountsStore.hasNoAccount) {
          await accountsStore.clearDefaultAccount();
        }

        // if first account try to import settings
        if (isFirstAccount) {
          try {
            await context.read<ConfigStore>().importLemmyUserSettings(
                accountsStore
                    .userDataFor(
                        selectedInstance.value, usernameController.text)!
                    .jwt);
            // ignore: empty_catches
          } catch (e) {}
        }

        Navigator.of(context).pop();
      } on VerifyEmailException {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(L10n.of(context).verification_email_sent),
        ));
      } on RegistrationApplicationSentException {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(L10n.of(context).registration_application_sent),
        ));
      } on Exception catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
      loading.cancel();
    }

    final handleSubmit =
        usernameController.text.isEmpty || passwordController.text.isEmpty
            ? null
            : loading.pending
                ? () {}
                : handleOnAdd;

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(L10n.of(context).add_account),
      ),
      body: AutofillGroup(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                  DisplayDocumentPage.route('Code of Conduct', codeOfConduct)),
              child: Text(L10n.of(context).code_of_conduct_clickthrough,
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: clickThroughFontSize,
                      decoration: TextDecoration.underline)),
            ),
            if (icon.value == null)
              const SizedBox(height: 150)
            else
              SizedBox(
                height: 150,
                child: FullscreenableImage(
                  url: icon.value!,
                  child: CachedNetworkImage(
                    imageUrl: icon.value!,
                    errorBuilder: (_, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            RadioPicker<String>(
              title: L10n.of(context).select_instance,
              values: accountsStore.instances.toList(),
              groupValue: selectedInstance.value,
              onChanged: (value) => selectedInstance.value = value,
              buttonBuilder: (context, displayValue, onPressed) => FilledButton(
                onPressed: onPressed,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(displayValue),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              trailing: ListTile(
                leading: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add),
                ),
                title: Text(L10n.of(context).select_instance),
                onTap: () async {
                  final value =
                      await Navigator.of(context).push(AddInstancePage.route());
                  Navigator.of(context).pop(value);
                },
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              autofocus: true,
              controller: usernameController,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username
              ],
              onTapOutside: (_) =>
                  usernameController.text = usernameController.text.trim(),
              onSubmitted: (_) {
                usernameController.text = usernameController.text.trim();
                passwordFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                  labelText: L10n.of(context).email_or_username),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              maxLength: 60,
              obscureText: true,
              focusNode: passwordFocusNode,
              onSubmitted: (_) => totpFocusNode.requestFocus(),
              autofillHints: const [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(labelText: L10n.of(context).password),
            ),
            const SizedBox(height: 5),
            TextField(
              autofocus: true,
              controller: totpController,
              focusNode: totpFocusNode,
              autofillHints: const [AutofillHints.oneTimeCode],
              onSubmitted: (_) => handleSubmit?.call(),
              decoration:
                  InputDecoration(labelText: L10n.of(context).totp_2fa_token),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: handleSubmit,
              child: !loading.loading
                  ? Text(L10n.of(context).sign_in)
                  : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            textColorBasedOnBackground(
                                theme.colorScheme.primary)),
                      ),
                    ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: () {
                launchLink(
                  // TODO: extract to LemmyUrls or something
                  link: 'https://${selectedInstance.value}/login',
                  context: context,
                );
              },
              child: Text(L10n.of(context).register),
            ),
          ],
        ),
      ),
    );
  }

  static Route<String> route(String instanceHost) => MaterialPageRoute(
        builder: (context) => AddAccountPage(instanceHost: instanceHost),
        fullscreenDialog: true,
      );
}

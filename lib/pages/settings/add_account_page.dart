import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../../hooks/delayed_loading.dart';
import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../stores/config_store.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/fullscreenable_image.dart';
import '../../widgets/radio_picker.dart';
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
    final accountsStore = useAccountsStore();

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

        loading.start();
        await accountsStore.addAccount(
          selectedInstance.value,
          usernameController.text,
          passwordController.text,
        );

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
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Verification email sent'),
        ));
      } on RegistrationApplicationSentException {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration application sent'),
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
        title: const Text('Add account'),
      ),
      body: AutofillGroup(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
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
              title: 'select instance',
              values: accountsStore.instances.toList(),
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
              trailing: ListTile(
                leading: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add),
                ),
                title: const Text('Add instance'),
                onTap: () async {
                  final value =
                      await Navigator.of(context).push(AddInstancePage.route());
                  Navigator.of(context).pop(value);
                },
              ),
            ),
            TextField(
              autofocus: true,
              controller: usernameController,
              autofillHints: const [
                AutofillHints.email,
                AutofillHints.username
              ],
              onSubmitted: (_) => passwordFocusNode.requestFocus(),
              decoration: InputDecoration(
                  labelText: L10n.of(context).email_or_username),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: true,
              focusNode: passwordFocusNode,
              onSubmitted: (_) => handleSubmit?.call(),
              autofillHints: const [AutofillHints.password],
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(labelText: L10n.of(context).password),
            ),
            ElevatedButton(
              onPressed: handleSubmit,
              child: !loading.loading
                  ? const Text('Sign in')
                  : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.canvasColor),
                      ),
                    ),
            ),
            TextButton(
              onPressed: () {
                // TODO: extract to LemmyUrls or something
                ul.launch('https://${selectedInstance.value}/login');
              },
              child: const Text('Register'),
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

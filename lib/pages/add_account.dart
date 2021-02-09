import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../widgets/fullscreenable_image.dart';
import '../widgets/radio_picker.dart';
import 'add_instance.dart';

/// A modal where an account can be added for a given instance
class AddAccountPage extends HookWidget {
  final String instanceHost;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AddAccountPage({@required this.instanceHost}) : assert(instanceHost != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final usernameController = useListenable(useTextEditingController());
    final passwordController = useListenable(useTextEditingController());
    final accountsStore = useAccountsStore();

    final loading = useDelayedLoading();
    final selectedInstance = useState(instanceHost);
    final icon = useState<String>(null);

    useEffect(() {
      LemmyApiV2(selectedInstance.value)
          .run(GetSite())
          .then((site) => icon.value = site.siteView.site.icon);
      return null;
    }, [selectedInstance.value]);

    handleOnAdd() async {
      try {
        loading.start();
        await accountsStore.addAccount(
          selectedInstance.value,
          usernameController.text,
          passwordController.text,
        );
        Navigator.of(context).pop();
      } on Exception catch (err) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
      loading.cancel();
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Add account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          if (icon.value == null)
            const SizedBox(height: 150)
          else
            SizedBox(
              height: 150,
              child: FullscreenableImage(
                url: icon.value,
                child: CachedNetworkImage(
                  imageUrl: icon.value,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
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
                final value = await showCupertinoModalPopup<String>(
                  context: context,
                  builder: (context) => AddInstancePage(),
                );
                Navigator.of(context).pop(value);
              },
            ),
          ),
          // TODO: add support for password managers
          TextField(
            autofocus: true,
            controller: usernameController,
            decoration: const InputDecoration(labelText: 'Username or email'),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: usernameController.text.isEmpty ||
                    passwordController.text.isEmpty
                ? null
                : loading.pending
                    ? () {}
                    : handleOnAdd,
            child: !loading.loading
                ? const Text('Sign in')
                : SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(theme.canvasColor),
                    ),
                  ),
          ),
          TextButton(
            onPressed: () {
              ul.launch('https://${selectedInstance.value}/login');
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}

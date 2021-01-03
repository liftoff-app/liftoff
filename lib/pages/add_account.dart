import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../widgets/bottom_modal.dart';
import '../widgets/fullscreenable_image.dart';
import 'add_instance.dart';

/// A modal where an account can be added for a given instance
class AddAccountPage extends HookWidget {
  final String instanceHost;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AddAccountPage({@required this.instanceHost}) : assert(instanceHost != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    useValueListenable(usernameController);
    useValueListenable(passwordController);
    final accountsStore = useAccountsStore();

    final loading = useDelayedLoading();
    final selectedInstance = useState(instanceHost);
    final icon = useState<String>(null);
    useEffect(() {
      LemmyApi(selectedInstance.value)
          .v1
          .getSite()
          .then((site) => icon.value = site.site.icon);
      return null;
    }, [selectedInstance.value]);

    /// show a modal with a list of instance checkboxes
    selectInstance() async {
      final val = await showModalBottomSheet<String>(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (context) => BottomModal(
          title: 'select instance',
          child: Column(children: [
            for (final i in accountsStore.instances)
              RadioListTile<String>(
                value: i,
                groupValue: selectedInstance.value,
                onChanged: (val) {
                  Navigator.of(context).pop(val);
                },
                title: Text(i),
              ),
            ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(Icons.add),
              ),
              title: Text('Add instance'),
              onTap: () async {
                final val = await showCupertinoModalPopup<String>(
                  context: context,
                  builder: (context) => AddInstancePage(),
                );
                Navigator.of(context).pop(val);
              },
            ),
          ]),
        ),
      );
      if (val != null) {
        selectedInstance.value = val;
      }
    }

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
        leading: CloseButton(),
        actionsIconTheme: theme.iconTheme,
        iconTheme: theme.iconTheme,
        textTheme: theme.textTheme,
        brightness: theme.brightness,
        centerTitle: true,
        title: Text('Add account'),
        backgroundColor: theme.canvasColor,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            if (icon.value == null)
              SizedBox(height: 150)
            else
              SizedBox(
                height: 150,
                child: FullscreenableImage(
                  url: icon.value,
                  child: CachedNetworkImage(
                    imageUrl: icon.value,
                    errorWidget: (_, __, ___) => SizedBox.shrink(),
                  ),
                ),
              ),
            FlatButton(
              onPressed: selectInstance,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(selectedInstance.value),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
            // TODO: add support for password managers
            TextField(
              autofocus: true,
              controller: usernameController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Username or email',
              ),
            ),
            const SizedBox(height: 5),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
              ),
            ),
            RaisedButton(
              color: theme.accentColor,
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: usernameController.text.isEmpty ||
                      passwordController.text.isEmpty
                  ? null
                  : loading.pending
                      ? () {}
                      : handleOnAdd,
              child: !loading.loading
                  ? Text('Sign in')
                  : SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.canvasColor),
                      ),
                    ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                ul.launch('https://${selectedInstance.value}/login');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/debounce.dart';
import '../hooks/delayed_loading.dart';
import '../hooks/stores.dart';
import '../widgets/fullscreenable_image.dart';

class AddInstancePage extends HookWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  AddInstancePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceController = useTextEditingController();
    useValueListenable(instanceController);
    final accountsStore = useAccountsStore();
    final delayedLoading = useDelayedLoading(Duration(milliseconds: 500));

    final isSite = useState<bool>(null);
    final loading = useState(false);
    final icon = useState<String>(null);
    final prevInput = usePrevious<String>(instanceController.text);
    final debounce = useDebounce(() async {
      if (prevInput == instanceController.text) return;
      if (instanceController.text.isEmpty) {
        isSite.value = null;
        return;
      }

      try {
        icon.value =
            (await LemmyApi(instanceController.text).v1.getSite()).site.icon;
        isSite.value = true;
      } catch (e) {
        isSite.value = false;
      }
    });

    instanceController.addListener(debounce);

    handleOnAdd() async {
      delayedLoading.start();
      try {
        loading.value = true;
        await accountsStore.addInstance(instanceController.text,
            assumeValid: true);
        Navigator.of(context).pop(instanceController.text);
      } on Exception catch (err) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
      delayedLoading.cancel();
      loading.value = false;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        brightness: theme.brightness,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        centerTitle: true,
        leading: CloseButton(),
        actionsIconTheme: theme.iconTheme,
        textTheme: theme.textTheme,
        title: Text('Add instance'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: SafeArea(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          if (isSite.value == true)
            SizedBox(
                height: 150,
                child: FullscreenableImage(
                  child: CachedNetworkImage(
                    imageUrl: icon.value,
                    errorWidget: (_, __, ___) => Container(),
                  ),
                  url: icon.value,
                ))
          else if (isSite.value == false)
            SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close, color: Colors.red),
                  Text('instance not found')
                ],
              ),
            )
          else
            SizedBox(height: 150),
          SizedBox(height: 15),
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                autofocus: true,
                controller: instanceController,
                autocorrect: false,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'instance url',
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 40,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: theme.accentColor,
                child: !debounce.loading
                    ? Text('Add')
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(theme.canvasColor),
                        ),
                      ),
                onPressed: isSite.value == true ? handleOnAdd : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

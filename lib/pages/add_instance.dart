import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';

import '../hooks/debounce.dart';
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

    final isSite = useState<bool>(null);
    final icon = useState<String>(null);
    final prevInput = usePrevious(instanceController.text);
    final debounce = useDebounce(() async {
      if (prevInput == instanceController.text) return;

      final inst = _fixInstanceUrl(instanceController.text);
      if (inst.isEmpty) {
        isSite.value = null;
        return;
      }
      try {
        icon.value = (await LemmyApi(inst).v1.getSite()).site.icon;
        isSite.value = true;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        isSite.value = false;
      }
    });

    useEffect(() {
      instanceController.addListener(debounce);

      return () {
        debounce.dispose();
        instanceController.removeListener(debounce);
      };
    }, []);

    handleOnAdd() async {
      try {
        await accountsStore.addInstance(
            _fixInstanceUrl(instanceController.text),
            assumeValid: true);
        Navigator.of(context).pop(instanceController.text);
      } on Exception catch (err) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
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

String _fixInstanceUrl(String inst) {
  if (inst.startsWith('https://')) {
    inst = inst.substring(8);
  }

  if (inst.startsWith('http://')) {
    inst = inst.substring(7);
  }

  if (inst.endsWith('/')) inst = inst.substring(0, inst.length - 1);

  return inst;
}

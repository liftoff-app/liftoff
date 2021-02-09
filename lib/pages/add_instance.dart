import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v2.dart';

import '../hooks/debounce.dart';
import '../hooks/stores.dart';
import '../util/cleanup_url.dart';
import '../widgets/fullscreenable_image.dart';

/// A page that let's user add a new instance. Pops a url of the added instance
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

      final inst = cleanUpUrl(instanceController.text);
      if (inst.isEmpty) {
        isSite.value = null;
        return;
      }
      try {
        icon.value = (await LemmyApiV2(inst).run(GetSite())).siteView.site.icon;
        isSite.value = true;
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        isSite.value = false;
      }
    });

    useEffect(() {
      instanceController.addListener(debounce);

      return () {
        instanceController.removeListener(debounce);
      };
    }, []);
    final inst = cleanUpUrl(instanceController.text);
    handleOnAdd() async {
      try {
        await accountsStore.addInstance(inst, assumeValid: true);
        Navigator.of(context).pop(inst);
      } on Exception catch (err) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Add instance'),
      ),
      body: ListView(
        children: [
          if (isSite.value == true && icon.value != null)
            SizedBox(
                height: 150,
                child: FullscreenableImage(
                  url: icon.value,
                  child: CachedNetworkImage(
                    imageUrl: icon.value,
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ))
          else if (isSite.value == false)
            SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.close, color: Colors.red),
                  Text('instance not found')
                ],
              ),
            )
          else
            const SizedBox(height: 150),
          const SizedBox(height: 15),
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                autofocus: true,
                controller: instanceController,
                autocorrect: false,
                decoration: const InputDecoration(labelText: 'instance url'),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: isSite.value == true ? handleOnAdd : null,
                child: !debounce.loading
                    ? const Text('Add')
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(theme.canvasColor),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

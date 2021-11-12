import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/debounce.dart';
import '../../hooks/stores.dart';
import '../../util/cleanup_url.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/fullscreenable_image.dart';

/// A page that let's user add a new instance. Pops a url of the added instance
class AddInstancePage extends HookWidget {
  const AddInstancePage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceController = useTextEditingController();
    useValueListenable(instanceController);
    final accountsStore = useAccountsStore();

    final isSite = useState<bool?>(null);
    final icon = useState<String?>(null);
    final prevInput = usePrevious(instanceController.text);
    final debounce = useDebounce(() async {
      if (prevInput == instanceController.text) return;

      final inst = normalizeInstanceHost(instanceController.text);
      if (inst.isEmpty) {
        isSite.value = null;
        return;
      }
      try {
        icon.value =
            (await LemmyApiV3(inst).run(const GetSite())).siteView?.site.icon;
        isSite.value = true;
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

    final inst = normalizeInstanceHost(instanceController.text);

    handleOnAdd() async {
      try {
        await accountsStore.addInstance(inst, assumeValid: true);
        Navigator.of(context).pop(inst);
      } on Exception catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
    }

    final handleAdd = isSite.value == true ? handleOnAdd : null;

    return Scaffold(
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
                  url: icon.value!,
                  child: CachedNetworkImage(
                    imageUrl: icon.value!,
                    errorBuilder: (_, ___) => const SizedBox.shrink(),
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
                autofillHints: const [AutofillHints.url],
                keyboardType: TextInputType.url,
                onSubmitted: (_) => handleAdd?.call(),
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
                onPressed: handleAdd,
                child: !debounce.loading
                    ? const Text('Add')
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
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

  static Route<String> route() => MaterialPageRoute(
        builder: (context) => const AddInstancePage(),
        fullscreenDialog: true,
      );
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/debounce.dart';
import '../../hooks/stores.dart';
import '../../l10n/gen/l10n.dart';
import '../../util/cleanup_url.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/fullscreenable_image.dart';

/// A page that let's user add a new instance. Pops a url of the added instance
class AddInstancePage extends HookWidget {
  const AddInstancePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        if (context.mounted) {
          Navigator.of(context).pop(inst);
        }
      } on Exception catch (err) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(err.toString()),
          ));
        }
      }
    }

    final handleAdd = isSite.value == true ? handleOnAdd : null;

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(L10n.of(context).add_instance),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(L10n.of(context).kbin_instances_not_supported),
          ),
          ListView(
            shrinkWrap: true,
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
                    children: [
                      const Icon(Icons.close, color: Colors.red),
                      Text(L10n.of(context).instance_not_found)
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
                    decoration: InputDecoration(
                        labelText: L10n.of(context).instance_url),
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
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator.adaptive(),
                          ),
                  ),
                ),
              ),
            ],
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

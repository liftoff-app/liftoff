import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../hooks/stores.dart';

class AddInstancePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final instanceController = useTextEditingController();
    useValueListenable(instanceController);
    final accountsStore = useAccountsStore();

    final loading = useState(false);

    handleOnAdd() async {
      try {
        loading.value = true;
        await accountsStore.addInstance(instanceController.text);
        Navigator.of(context).pop(instanceController.text);
      } on Exception catch (err) {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
        ));
      }
      loading.value = false;
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        iconTheme: theme.iconTheme,
        leading: CloseButton(),
        actionsIconTheme: theme.iconTheme,
        textTheme: theme.textTheme,
        title: Text('Add instance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            if (false)
              CachedNetworkImage(height: 150, width: 150)
            else
              SizedBox(height: 150),
            TextField(
              autofocus: true,
              controller: instanceController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'instance url',
              ),
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Spacer(),
                RaisedButton(
                  child: !loading.value
                      ? Text('Add')
                      : CircularProgressIndicator(),
                  onPressed:
                      instanceController.text.isEmpty ? null : handleOnAdd,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

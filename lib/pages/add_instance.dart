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
          if (false)
            CachedNetworkImage(height: 150, width: 150)
          else
            SizedBox(height: 150),
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                autofocus: true,
                controller: instanceController,
                decoration: InputDecoration(
                  isDense: true,
                  // contentPadding:
                  //     EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                child:
                    !loading.value ? Text('Add') : CircularProgressIndicator(),
                onPressed: instanceController.text.isEmpty ? null : handleOnAdd,
              ),
            ),
          ),
          // Row(
          //   children: <Widget>[
          //     Spacer(),
          //   ],
          // )
        ],
      ),
    );
  }
}

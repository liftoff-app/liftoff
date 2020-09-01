import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'stores/accounts_store.dart';
import 'stores/config_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var configStore = ConfigStore();
  await configStore.load();

  var accountsStore = AccountsStore();
  await accountsStore.load();

  runApp(
    MultiProvider(
      providers: [
        Provider<ConfigStore>(
          create: (_) => configStore,
          dispose: (_, store) => store.dispose(),
        ),
        Provider<AccountsStore>(
          create: (_) => accountsStore,
          dispose: (_, store) => store.dispose(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(
        builder: (ctx) => MaterialApp(
          title: 'Flutter Demo',
          themeMode: ctx.watch<ConfigStore>().theme,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter hello world'),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ),
      );
}

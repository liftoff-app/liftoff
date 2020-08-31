import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lemmy_api_client/lemmy_api_client.dart';
import 'package:provider/provider.dart';

import 'pages/profile_tab.dart';
import 'stores/config_store.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ConfigStore>(
          create: (_) => ConfigStore()..load(),
          dispose: (_, store) => store.dispose(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (ctx) {
        return MaterialApp(
          title: 'Flutter Demo',
          themeMode: ctx.watch<ConfigStore>().theme,
          darkTheme: ThemeData.dark(),
          theme: ThemeData(
            primarySwatch: ctx.watch<ConfigStore>().accentColor,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: UserProfileTab(User.fromJson(jsonDecode(
              '''{"id":13917,"name":"shilangyu","preferred_username":null,"password_encrypted":"","email":"xmarcinmarcin@gmail.com","avatar":null,"admin":false,"banned":false,"published":"2020-08-23T07:13:23.229279","updated":"2020-08-29T21:11:11.508707","show_nsfw":true,"theme":"minty","default_sort_type":0,"default_listing_type":1,"lang":"browser","show_avatars":true,"send_notifications_to_email":false,"matrix_user_id":null,"actor_id":"https://dev.lemmy.ml/u/shilangyu","bio":null,"local":true,"private_key":null,"public_key":null,"last_refreshed_at":"2020-08-23T07:13:23.229279","banner":null}'''))),
        );
      },
    );
  }
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

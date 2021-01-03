import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InboxPage extends HookWidget {
  const InboxPage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🚧 WORK IN PROGRESS 🚧',
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          ),
        ),
      );
}

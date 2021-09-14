import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SelectCommunityPage extends HookWidget {
  const SelectCommunityPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 60),
            child: TextField(),
          ),
        ),
        body: ListView(
          children: const [],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'stores/accounts_store.dart';

Future<void> urlLauncher(BuildContext c, String url) async {
  final instances = c.read<AccountsStore>().users.keys.toList();
  print(instances);

  // CHECK IF LINK TO USER

  // TODO: link to user

  // CHECK IF LINK TO COMMUNITY

  // TODO; link to community

  // CHECK IF REDIRECTS TO A PAGE ON ONE OF ADDED INSTANCES

  final instanceRegex = RegExp(r'^(?:https?:\/\/)?([\w\.-]+)(.+)$');
  final match = instanceRegex.firstMatch(url);

  final matchedDomain = match.group(1);
  final rest = match.group(2);

  print('matched domain: $matchedDomain, rest: $rest');
  print(rest.length);

  if (instances.any((e) => e == match.group(1))) {
    switch (rest.split('/')[1]) {
      case 'c':
        print('comunity');
        return;
      case 'u':
        print('user');
        return;
      case 'post':
        print('post');
        return;
      case 'pictrs':
        print('pictures');
        return;
      case 'communities':
        print('communities');
        return;
      case 'modlog':
        print('modlog');
        return;
      case 'inbox':
        print('inbox');
        return;
      case 'create_post':
      case 'create_community':
      case 'sponsors':
      case 'instances':
      case 'docs':
        openInBrowser(url);
        return;
      default:
    }
  }

  // REGULAR LINK STUFF

  openInBrowser(url);
}

void openInBrowser(String url) async {
  if (await ul.canLaunch(url)) {
    await ul.launch(url);
  } else {
    throw Exception();
    // TODO: handle opening links to stuff in app
  }
}

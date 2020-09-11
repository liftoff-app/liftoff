import 'package:flutter/material.dart';
import 'package:lemmur/pages/community.dart';
import 'package:lemmur/pages/full_post.dart';
import 'package:lemmur/pages/user.dart';
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

  final matchedInstance = match.group(1);
  final rest = match.group(2);

  print('matched domain: $matchedInstance, rest: $rest');
  print(rest.length);

  if (instances.any((e) => e == match.group(1))) {
    push(Widget Function(BuildContext) builder) {
      Navigator.of(c).push(MaterialPageRoute(builder: builder));
    }

    final split = rest.split('/');
    switch (split[1]) {
      case 'c':
        return push((_) => CommunityPage.fromName(
            communityName: split[2], instanceUrl: matchedInstance));

      case 'u':
        return push((_) => UserPage.fromName(
            instanceUrl: matchedInstance, username: split[2]));

      case 'post':
        return push((_) => FullPostPage(
            id: int.parse(split[2]), instanceUrl: matchedInstance));

      case 'pictrs':
        // TODO: put here push to media view
        return;

      case 'communities':
        // TODO: put here push to communities page
        return;

      case 'modlog':
        // TODO: put here push to modlog
        print('modlog');
        return;
      case 'inbox':
        // TODO: put here push to inbox
        print('inbox');
        return;
      case 'search':
        // TODO: *maybe* put here push to search. we'll see
        //        how much web version differs form the app
        print('search');
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

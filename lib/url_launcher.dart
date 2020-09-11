import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'pages/community.dart';
import 'pages/full_post.dart';
import 'pages/user.dart';
import 'stores/accounts_store.dart';

Future<void> urlLauncher({
  @required BuildContext context,
  @required String url,
  @required String instanceUrl,
}) async {
  push(Widget Function(BuildContext) builder) {
    Navigator.of(context).push(MaterialPageRoute(builder: builder));
  }

  final instances = context.read<AccountsStore>().users.keys.toList();

  final chonks = url.split('/');

  // CHECK IF LINK TO USER
  if (chonks[1] == 'u') {
    return push((_) =>
        UserPage.fromName(instanceUrl: instanceUrl, username: chonks[2]));
  }

  // CHECK IF LINK TO COMMUNITY
  if (chonks[1] == 'c') {
    return push((_) => CommunityPage.fromName(
        communityName: chonks[2], instanceUrl: instanceUrl));
  }

  // CHECK IF REDIRECTS TO A PAGE ON ONE OF ADDED INSTANCES

  final instanceRegex = RegExp(r'^(?:https?:\/\/)?([\w\.-]+)(.+)$');
  final match = instanceRegex.firstMatch(url);

  final matchedInstance = match.group(1);
  final rest = match.group(2);

  print('matched domain: $matchedInstance, rest: $rest');
  print(rest.length);

  if (instances.any((e) => e == match.group(1))) {
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

  // FALLBACK TO REGULAR LINK STUFF

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

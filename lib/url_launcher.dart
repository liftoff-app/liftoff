import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'pages/community.dart';
import 'pages/instance.dart';
import 'pages/media_view.dart';
import 'pages/user.dart';
import 'stores/accounts_store.dart';
import 'util/goto.dart';

Future<void> linkLauncher({
  @required BuildContext context,
  @required String url,
  @required String instanceUrl,
}) async {
  push(Widget Function() builder) {
    goTo(context, (c) => builder());
  }

  final instances = context.read<AccountsStore>().instances;

  final chonks = url.split('/');
  if (chonks.length == 1) return openInBrowser(url);

  // CHECK IF LINK TO USER
  if (url.startsWith('/u/')) {
    return push(
        () => UserPage.fromName(instanceUrl: instanceUrl, username: chonks[2]));
  }

  // CHECK IF LINK TO COMMUNITY
  if (url.startsWith('/c/')) {
    return push(() => CommunityPage.fromName(
        communityName: chonks[2], instanceUrl: instanceUrl));
  }

  // CHECK IF REDIRECTS TO A PAGE ON ONE OF ADDED INSTANCES

  final instanceRegex = RegExp(r'^(?:https?:\/\/)?([\w\.-]+)(.*)$');
  final match = instanceRegex.firstMatch(url);

  final matchedInstance = match?.group(1);
  final rest = match?.group(2);

  if (matchedInstance != null && instances.any((e) => e == match.group(1))) {
    if (rest.isEmpty || rest == '/') {
      return push(() => InstancePage(instanceUrl: matchedInstance));
    }
    final split = rest.split('/');
    switch (split[1]) {
      case 'c':
        return goToCommunity.byName(context, matchedInstance, split[2]);

      case 'u':
        return goToUser.byName(context, matchedInstance, split[2]);

      case 'post':
        if (split.length == 3) {
          return goToPost(context, matchedInstance, int.parse(split[2]));
        } else if (split.length == 5) {
          // TODO: post with focus on comment thread
          print('comment in post');
          return goToPost(context, matchedInstance, int.parse(split[2]));
        }
        break;

      case 'pictrs':
        return push(() => MediaViewPage(url));

      case 'communities':
        // TODO: put here push to communities page
        print('communities');
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
        break;
      default:
        break;
    }
  }

  // FALLBACK TO REGULAR LINK STUFF

  return openInBrowser(url);
}

Future<void> openInBrowser(String url) async {
  if (await ul.canLaunch(url)) {
    return await ul.launch(url);
  } else {
    throw Exception();
    // TODO: handle opening links to stuff in app
  }
}

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'l10n/l10n.dart';
import 'pages/community/community.dart';
import 'pages/instance/instance.dart';
import 'pages/media_view.dart';
import 'pages/user.dart';
import 'stores/accounts_store.dart';
import 'util/goto.dart';

/// Decides where does a link link to. Either somewhere in-app:
/// opens the correct page, or outside of the app: opens in a browser
Future<void> linkLauncher({
  required BuildContext context,
  required String url,
  required String instanceHost,
}) async {
  void push(Widget Function() builder) {
    goTo(context, (c) => builder());
  }

  final instances = context.read<AccountsStore>().instances;

  final chonks = url.split('/');
  if (chonks.length == 1) {
    await launchLink(link: url, context: context);
    return;
  }

  // CHECK IF LINK TO USER
  if (url.startsWith('/u/')) {
    return push(() =>
        UserPage.fromName(instanceHost: instanceHost, username: chonks[2]));
  }

  // CHECK IF LINK TO COMMUNITY
  if (url.startsWith('/c/')) {
    await Navigator.of(context)
        .push(CommunityPage.fromNameRoute(instanceHost, chonks[2]));
    return;
  }

  // CHECK IF REDIRECTS TO A PAGE ON ONE OF ADDED INSTANCES

  final instanceRegex = RegExp(r'^(?:https?:\/\/)?([\w\.-]+)(.*)$');
  final match = instanceRegex.firstMatch(url);

  final matchedInstance = match?.group(1);
  final rest = match?.group(2);

  if (matchedInstance != null && instances.any((e) => e == match?.group(1))) {
    if (rest == null || rest.isEmpty || rest == '/') {
      return Navigator.of(context).push<void>(InstancePage.route(instanceHost));
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
          return goToPost(context, matchedInstance, int.parse(split[2]));
        }
        break;

      case 'pictrs':
        return push(() => MediaViewPage(url));

      case 'communities':
        // TODO: put here push to communities page
        return;

      case 'modlog':
        // TODO: put here push to modlog
        return;
      case 'inbox':
        // TODO: put here push to inbox
        return;
      case 'search':
        // TODO: *maybe* put here push to search. we'll see
        //        how much web version differs form the app
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

  await launchLink(link: url, context: context);
}

final _logger = Logger('launchLink');

/// Returns whether launching was successful.
Future<bool> launchLink({
  required String link,
  required BuildContext context,
}) async {
  final uri = Uri.tryParse(link);
  if (uri != null) {
    // Only http and https links should be opened in-app
    final mode = uri.scheme == 'http' || uri.scheme == 'https'
        ? ul.LaunchMode.platformDefault
        : ul.LaunchMode.externalApplication;
    await ul.launchUrl(uri, mode: mode);
    return true;
  } else {
    _logger.warning('Failed to launch a link: $link');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10n.of(context).cannot_open_in_browser)),
    );
    return false;
  }
}

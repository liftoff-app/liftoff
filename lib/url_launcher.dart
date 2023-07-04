import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import 'l10n/l10n.dart';
import 'pages/community/community.dart';
import 'pages/instance/instance.dart';
import 'pages/media_view.dart';
import 'pages/user.dart';
import 'stores/accounts_store.dart';
import 'stores/config_store.dart';
import 'util/goto.dart';
import 'util/text_color.dart';

///Launches a Chrome Custom Tab on Android or Safari View Controller on iOS
Future<void> _launchCustomTab(BuildContext context, String link) async {
  try {
    await launch(
      link,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).canvasColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).canvasColor,
        preferredControlTintColor:
            textColorBasedOnBackground(Theme.of(context).canvasColor),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
    await ul.launchUrl(Uri.parse(link),
        mode: ul.LaunchMode.externalApplication);
  }
}

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

  // CHECK IF EMAIL STYLE LINK TO COMMUNITY
  // Format: !liftoff@lemmy.world
  if (url.startsWith('!')) {
    final splitCommunityName = url.replaceAll(RegExp('!'), '').split('@');
    await Navigator.of(context).push(CommunityPage.fromNameRoute(
        splitCommunityName[1], splitCommunityName[0]));
    return;
  }

  // CHECK IF EMAIL STYLE LINK TO USER
  // Format: @user@lemmy.world
  if (url.startsWith('@')) {
    final usernameSplit = url.replaceFirst(RegExp('@'), '').split('@');
    push(() => UserPage.fromName(
        instanceHost: usernameSplit[1], username: usernameSplit[0]));
    return;
  }

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
    if (Platform.isAndroid || Platform.isIOS) {
      if (context.read<ConfigStore>().useInAppBrowser) {
        await _launchCustomTab(context, link);
      } else {
        await ul.launchUrl(uri, mode: ul.LaunchMode.externalApplication);
      }
    } else {
      await ul.launchUrl(uri,
          mode: context.read<ConfigStore>().useInAppBrowser
              ? ul.LaunchMode.platformDefault
              : ul.LaunchMode.externalApplication);
    }
    return true;
  } else {
    _logger.warning('Failed to launch a link: $link');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10n.of(context).cannot_open_in_browser)),
    );
    return false;
  }
}

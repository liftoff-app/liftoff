import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './util/goto.dart';

/// Wrapper widget that handles app links / universal links / deep links.
/// It currently supports:
/// - Communities
/// - Users
/// - Posts
///
/// The link format is the same as the web app, with liftoff:// as the scheme.
/// For example:
///  - liftoff://iusearchlinux.fyi/post/33195
///  - liftoff://programming.dev/c/programmer_humor
///  - liftoff://lemmy.world/u/zachatrocity
class AppLinkHandler extends HookWidget {
  AppLinkHandler(this.child, {super.key});

  final Widget child;
  final _appLinks = AppLinks();

  @override
  Widget build(BuildContext context) {
    // The subscription listener only needs to be initialized once.
    // useEffect() caused weird crashes, so I'm using state
    final initialized = useState(false);
    if (!initialized.value) {
      // Wait till the app has initialized.
      // Otherwise Navigator.of(context) will throw an error.
      Future.delayed(Duration.zero, () {
        _appLinks.allUriLinkStream.listen((uri) {
          final [operation, target] = uri.pathSegments;
          switch (operation) {
            case 'c':
              goToCommunity.byName(context, uri.host, target);
              break;
            case 'u':
              goToUser.byName(context, uri.host, target);
              break;
            case 'post':
              goToPost(context, uri.host, int.parse(target));
              break;
            default:
            // not supported -- ignore it.
          }
        });
      });
      initialized.value = true;
    }

    return child;
  }
}

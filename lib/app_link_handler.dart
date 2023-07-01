import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import './util/goto.dart';

class AppLinkHandler extends HookWidget {
  AppLinkHandler(this.child);

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
          }
        });
      });
      initialized.value = true;
    }

    return child;
  }
}

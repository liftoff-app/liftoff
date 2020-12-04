import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info/package_info.dart';

import '../hooks/memo_future.dart';
import '../url_launcher.dart';
import 'bottom_modal.dart';

/// Title that opens a dialog with information about Lemmur.
/// Licenses, changelog, version etc.
class AboutTile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final packageInfoSnap = useMemoFuture(PackageInfo.fromPlatform);
    final assetBundle = DefaultAssetBundle.of(context);
    final changelogSnap =
        useMemoFuture(() => assetBundle.loadString('CHANGELOG.md'));

    if (!packageInfoSnap.hasData || !changelogSnap.hasData) {
      return const SizedBox.shrink();
    }

    final packageInfo = packageInfoSnap.data;
    final changelog = changelogSnap.data;

    // TODO: add app icon
    return AboutListTile(
      icon: Icon(Icons.info),
      aboutBoxChildren: [
        FlatButton.icon(
          icon: Icon(Icons.subject),
          label: Text('changelog'),
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (_) => BottomModal(
              child: MarkdownBody(data: changelog),
            ),
          ),
        ),
        FlatButton.icon(
          icon: Icon(Icons.code),
          label: Text('source code'),
          onPressed: () => openInBrowser('https://github.com/krawieck/lemmur'),
        ),
        FlatButton.icon(
          icon: Icon(Icons.monetization_on),
          label: Text('support development'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlatButton(
                      child: Text('Patreon'),
                      onPressed: () =>
                          openInBrowser('https://patreon.com/lemmur'),
                    ),
                    FlatButton(
                      child: Text('Buy Me a Coffee'),
                      onPressed: () =>
                          openInBrowser('https://buymeacoff.ee/lemmur'),
                    ),
                  ],
                ),
              ),
            );
          }, // TODO: link to some donation site
        ),
      ],
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/app_icon.png',
          width: 54,
        ),
      ),
      applicationVersion: packageInfo.version,
    );
  }
}

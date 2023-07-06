import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../gen/assets.gen.dart';
import '../hooks/memo_future.dart';
import '../pages/log_console/log_console.dart';
import '../resources/links.dart';
import '../url_launcher.dart';
import 'bottom_safe.dart';

/// Title that opens a dialog with information about Liftoff.
/// Licenses, changelog, version etc.
class AboutTile extends HookWidget {
  const AboutTile();

  @override
  Widget build(BuildContext context) {
    final packageInfoSnap = useMemoFuture(PackageInfo.fromPlatform);
    final assetBundle = DefaultAssetBundle.of(context);
    final changelogSnap =
        useMemoFuture(() => assetBundle.loadString('CHANGELOG.md'));

    final packageInfo = packageInfoSnap.data;
    final changelog = changelogSnap.data;

    if (!packageInfoSnap.hasData ||
        !changelogSnap.hasData ||
        packageInfo == null ||
        changelog == null) {
      return const SizedBox.shrink();
    }

    return AboutListTile(
      icon: const Icon(Icons.info),
      aboutBoxChildren: [
        const Text(
            'A client for Lemmy, written in Flutter.\n\nBased on the Lemmur project.'),
        const SizedBox(height: 40),
        FilledButton.icon(
            icon: const Icon(Icons.subject),
            label: const Text('changelog'),
            onPressed: () =>
                Navigator.of(context).push(ChangelogPage.route(changelog))),
        FilledButton.icon(
          icon: const Icon(Icons.code),
          label: const Text('source code'),
          onPressed: () =>
              launchLink(link: liftoffRepositoryUrl, context: context),
        ),
        FilledButton.icon(
          icon: const Icon(Icons.list_alt),
          label: const Text('logs'),
          onPressed: () {
            Navigator.of(context).push(LogConsolePage.route());
          },
        ),
      ],
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Assets.appIcon.image(width: 54),
      ),
      applicationVersion: packageInfo.version,
    );
  }
}

class ChangelogPage extends StatelessWidget {
  final String changelog;

  const ChangelogPage(this.changelog, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Changelog')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MarkdownBody(data: changelog),
            const BottomSafe(),
          ],
        ));
  }

  static Route route(String changelog) => MaterialPageRoute(
        builder: (context) => ChangelogPage(changelog),
      );
}

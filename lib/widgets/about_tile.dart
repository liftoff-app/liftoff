import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../gen/assets.gen.dart';
import '../hooks/memo_future.dart';
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
    final codeOfConductSnap =
        useMemoFuture(() => assetBundle.loadString('CODE_OF_CONDUCT.md'));
    final privacySnap =
        useMemoFuture(() => assetBundle.loadString('PRIVACY_POLICY.md'));

    final packageInfo = packageInfoSnap.data;
    final changelog = changelogSnap.data;
    final codeOfConduct = codeOfConductSnap.data;
    final privacyPolicy = privacySnap.data;

    if (!packageInfoSnap.hasData ||
        !changelogSnap.hasData ||
        packageInfo == null ||
        changelog == null ||
        codeOfConduct == null ||
        privacyPolicy == null) {
      return const SizedBox.shrink();
    }

    return AboutListTile(
      icon: const Icon(Icons.info),
      aboutBoxChildren: [
        const Text(
            'A client for Lemmy, written in Flutter.\n\nBased on the Lemmur project.'),
        const SizedBox(height: 40),
        FilledButton.icon(
            icon: const Icon(Icons.rule_rounded),
            label: const Text('Code of Conduct'),
            onPressed: () => Navigator.of(context).push(
                DisplayDocumentPage.route('Code of Conduct', codeOfConduct))),
        FilledButton.icon(
            icon: const Icon(Icons.policy_outlined),
            label: const Text('Privacy Policy'),
            onPressed: () => Navigator.of(context).push(
                DisplayDocumentPage.route('Privacy Policy', privacyPolicy))),
        FilledButton.icon(
            icon: const Icon(Icons.subject),
            label: const Text('changelog'),
            onPressed: () => Navigator.of(context)
                .push(DisplayDocumentPage.route('changelog', changelog))),
        FilledButton.icon(
          icon: const Icon(Icons.code),
          label: const Text('source code'),
          onPressed: () =>
              launchLink(link: liftoffRepositoryUrl, context: context),
        ),
        // Never seen a log entry, so let's not bother with this right now.
        // FilledButton.icon(
        //   icon: const Icon(Icons.list_alt),
        //   label: const Text('logs'),
        //   onPressed: () {
        //     Navigator.of(context).push(LogConsolePage.route());
        //   },
        // ),
      ],
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Assets.appIcon.image(width: 54),
      ),
      applicationVersion: packageInfo.version,
    );
  }
}

class DisplayDocumentPage extends StatelessWidget {
  final String title;
  final String contents;

  const DisplayDocumentPage(this.title, this.contents, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MarkdownBody(
              data: contents,
              onTapLink: (text, href, title) async {
                final didLaunch = await launchLink(
                  link: href!,
                  context: context,
                );
                if (didLaunch) {
                  Navigator.of(context).pop();
                }
              },
            ),
            const BottomSafe(),
          ],
        ));
  }

  static Route route(String title, String contents) => MaterialPageRoute(
        builder: (context) => DisplayDocumentPage(title, contents),
      );
}

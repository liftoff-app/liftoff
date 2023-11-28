import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../url_launcher.dart';
import '../widgets/bottom_safe.dart';
import '../widgets/liftoff_app_bar.dart';

/// Displays a markdown document full-screen, and allows the user
/// to click on links within that document for opening in the
/// browser.
class DisplayDocumentPage extends StatelessWidget {
  final String title;
  final String contents;

  const DisplayDocumentPage(this.title, this.contents, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LiftoffAppBar(title: Text(title)),
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
                if (didLaunch && context.mounted) {
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

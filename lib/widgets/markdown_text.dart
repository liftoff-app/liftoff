import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../url_launcher.dart';

Widget MarkdownText(String text, BuildContext context) {
  return MarkdownBody(
    data: text,
    extensionSet: md.ExtensionSet.gitHubWeb,
    onTapLink: (href) {
      urlLauncher(href)
          .catchError((e) => Scaffold.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.warning),
                    Text('couldn\'t open link'),
                  ],
                ),
              )));
    },
  );
}

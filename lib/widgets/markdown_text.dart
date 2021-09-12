import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../url_launcher.dart';
import 'fullscreenable_image.dart';

/// A Markdown renderer with link/image handling
class MarkdownText extends StatelessWidget {
  final String instanceHost;
  final String text;
  final bool selectable;

  const MarkdownText(this.text,
      {required this.instanceHost, this.selectable = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MarkdownBody(
      selectable: selectable,
      data: text,
      extensionSet: md.ExtensionSet.gitHubWeb,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        blockquoteDecoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          border: Border(
            left: BorderSide(width: 2, color: theme.colorScheme.secondary),
          ),
        ),
        code: theme.textTheme.bodyText1
            // TODO: use a font from google fonts maybe? the defaults aren't very pretty
            ?.copyWith(fontFamily: Platform.isIOS ? 'Courier' : 'monospace'),
      ),
      onTapLink: (text, href, title) {
        if (href == null) return;
        linkLauncher(context: context, url: href, instanceHost: instanceHost)
            .catchError(
                (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.warning),
                          Text("couldn't open link, ${e.toString()}"),
                        ],
                      ),
                    )));
      },
      imageBuilder: (uri, title, alt) => FullscreenableImage(
        url: uri.toString(),
        child: CachedNetworkImage(
          imageUrl: uri.toString(),
          errorWidget: (context, url, error) => Row(
            children: [
              const Icon(Icons.warning),
              Text("couldn't load image, ${error.toString()}")
            ],
          ),
        ),
      ),
    );
  }
}

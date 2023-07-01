import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../url_launcher.dart';
import '../util/cleanup_url.dart';
import 'cached_network_image.dart';
import 'fullscreenable_image.dart';

/// Accepted formats:
/// !community@server.com
/// /c/community@server.com
/// /m/community@server.com
/// /u/username@server.com
/// @username@server.com

class LemmyLinkSyntax extends md.InlineSyntax {
  // https://github.com/LemmyNet/lemmy-ui/blob/61255bf01a8d2acdbb77229838002bf8067ada70/src/shared/config.ts#L38
  static const String _pattern =
      r'(\/[cmu]\/|@|!)([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})';

  LemmyLinkSyntax() : super(_pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final modifier = match[1]!;
    final name = match[2]!;
    final url = match[3]!;
    final anchor = md.Element.text('a', '$modifier$name@$url');

    anchor.attributes['href'] = '$modifier$name@$url';
    parser.addNode(anchor);

    return true;
  }
}

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
      key: ValueKey(Object.hashAll([selectable, text, instanceHost])),
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
        a: TextStyle(
          color: theme.colorScheme.secondary,
        ),
        code: theme.textTheme.bodyLarge
            // TODO: use a font from google fonts maybe? the defaults aren't very pretty
            ?.copyWith(fontFamily: Platform.isIOS ? 'Courier' : 'monospace'),
      ),
      inlineSyntaxes: [LemmyLinkSyntax()],
      onTapLink: (text, href, title) {
        if (href == null) return;
        linkLauncher(context: context, url: href, instanceHost: instanceHost)
            .catchError(
                (e) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.warning),
                          Text("couldn't open link, $e"),
                        ],
                      ),
                    )));
      },
      imageBuilder: (uri, title, alt) => FullscreenableImage(
        url: uri.toString(),
        child: CachedNetworkImage(
          imageUrl: uri.toString(),
          errorBuilder: (context, error) => Row(
            children: [
              const Icon(Icons.warning),
              Text("couldn't load image, $error")
            ],
          ),
        ),
      ),
    );
  }
}

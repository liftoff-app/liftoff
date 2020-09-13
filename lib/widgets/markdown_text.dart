import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import '../url_launcher.dart';
import 'fullscreenable_image.dart';

class MarkdownText extends StatelessWidget {
  final String instanceUrl;
  final String text;
  MarkdownText(this.text, {@required this.instanceUrl})
      : assert(instanceUrl != null);

  @override
  Widget build(BuildContext context) => MarkdownBody(
        data: text,
        extensionSet: md.ExtensionSet.gitHubWeb,
        onTapLink: (href) {
          linkLauncher(context: context, url: href, instanceUrl: instanceUrl)
              .catchError((e) => Scaffold.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.warning),
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
                Icon(Icons.warning),
                Text("couldn't load image, ${error.toString()}")
              ],
            ),
          ),
        ),
      );
}

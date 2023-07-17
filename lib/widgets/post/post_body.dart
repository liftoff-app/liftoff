import 'package:flutter/material.dart';

import '../../stores/config_store.dart';
import '../../util/observer_consumers.dart';
import '../markdown_text.dart';
import 'post_status.dart';
import 'post_store.dart';

class PostBody extends StatelessWidget {
  const PostBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullPost = context.read<IsFullPost>();
    final bodyFontSize = context.read<ConfigStore>().postBodySize;

    return ObserverBuilder<PostStore>(builder: (context, store) {
      final body = store.postView.post.body;
      if (body == null) return const SizedBox();

      if (fullPost) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: MarkdownText(
            body,
            instanceHost: store.postView.instanceHost,
            selectable: true,
            fontSize: bodyFontSize,
          ),
        );
      } else {
        return LayoutBuilder(
          builder: (context, constraints) {
            final tp = TextPainter(
              text: TextSpan(text: body),
              maxLines: 8,
              textDirection: Directionality.of(context),
            )..layout(maxWidth: constraints.maxWidth - 20);

            if (tp.didExceedMaxLines) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: tp.height),
                child: Stack(
                  children: [
                    Positioned.fill(
                      bottom: null,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: MarkdownText(
                          body,
                          instanceHost: store.postView.instanceHost,
                          fontSize: bodyFontSize,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      top: null,
                      child: Container(
                        height: tp.preferredLineHeight * 2.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.cardColor.withAlpha(0),
                              theme.cardColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: SingleChildScrollView(
                    child: MarkdownText(
                      body,
                      instanceHost: store.postView.instanceHost,
                      fontSize: bodyFontSize,
                    ),
                  ),
                ),
              );
            }
          },
        );
      }
    });
  }
}

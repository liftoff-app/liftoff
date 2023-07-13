import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/stores.dart';
import '../../stores/config_store.dart';
import '../../url_launcher.dart';
import '../../util/observer_consumers.dart';
import '../cached_network_image.dart';
import '../fullscreenable_image.dart';
import 'post_store.dart';

class PostTitle extends HookWidget {
  const PostTitle();

  @override
  Widget build(BuildContext context) {
    final configStore = useStore((ConfigStore store) => store);

    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final post = store.postView.post;
        return Padding(
          padding: const EdgeInsets.all(10).copyWith(top: 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  post.name,
                  textAlign: TextAlign.left,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: configStore.titleFontSize,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

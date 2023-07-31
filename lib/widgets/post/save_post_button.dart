import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../util/observer_consumers.dart';
import 'post_store.dart';

class SavePostButton extends HookWidget {
  const SavePostButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        context.select<PostStore, bool>((store) => store.isAuthenticated);

    if (!isLoggedIn) {
      return Container();
    }

    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final savedIcon =
            store.postView.saved ? Icons.bookmark : Icons.bookmark_border;

        return IconButton(
          tooltip: 'Save post',
          icon: store.savingState.isLoading
              ? const CircularProgressIndicator.adaptive()
              : Icon(savedIcon),
          onPressed: store.save,
        );
      },
    );
  }
}

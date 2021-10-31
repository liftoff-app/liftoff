import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../hooks/logged_in_action.dart';
import '../../util/observer_consumers.dart';
import 'post_store.dart';

class SavePostButton extends HookWidget {
  const SavePostButton();

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(context
        .select<PostStore, String>((store) => store.postView.instanceHost));

    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        final savedIcon =
            store.postView.saved ? Icons.bookmark : Icons.bookmark_border;

        return IconButton(
          tooltip: 'Save post',
          icon: store.savingState.isLoading
              ? const CircularProgressIndicator.adaptive()
              : Icon(savedIcon),
          onPressed: loggedInAction(store.save),
        );
      },
    );
  }
}

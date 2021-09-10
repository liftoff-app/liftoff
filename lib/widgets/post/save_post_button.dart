import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../hooks/logged_in_action.dart';
import '../../util/async_store.dart';
import '../../util/observer_consumers.dart';
import 'post_store.dart';

// TODO: sync this button between post and fullpost. the same with voting

class SavePostButton extends HookWidget {
  const SavePostButton();

  @override
  Widget build(BuildContext context) {
    final loggedInAction = useLoggedInAction(context
        .select<PostStore, String>((store) => store.postView.instanceHost));

    return ObserverBuilder<PostStore>(
      builder: (context, store) {
        if (store.savingState is AsyncStateLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).iconTheme.color,
              ),
            ),
          );
        }

        final savedIcon =
            store.postView.saved ? Icons.bookmark : Icons.bookmark_border;

        return IconButton(
          tooltip: 'Save post',
          icon: Icon(savedIcon),
          onPressed: loggedInAction(store.save),
        );
      },
    );
  }
}

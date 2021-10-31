import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/logged_in_action.dart';
import '../../hooks/stores.dart';
import '../../stores/config_store.dart';
import '../../util/intl.dart';
import '../../util/observer_consumers.dart';
import 'post_store.dart';

class PostVoting extends HookWidget {
  const PostVoting();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showScores = useStore((ConfigStore store) => store.showScores);
    final loggedInAction = useLoggedInAction(context
        .select<PostStore, String>((store) => store.postView.instanceHost));

    return ObserverBuilder<PostStore>(builder: (context, store) {
      return Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_upward,
              color: store.postView.myVote == VoteType.up
                  ? theme.colorScheme.secondary
                  : null,
            ),
            onPressed: loggedInAction(store.upVote),
          ),
          if (store.votingState.isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator.adaptive(),
            )
          else if (showScores)
            Text(compactNumber(store.postView.counts.score)),
          IconButton(
            icon: Icon(
              Icons.arrow_downward,
              color: store.postView.myVote == VoteType.down ? Colors.red : null,
            ),
            onPressed: loggedInAction(store.downVote),
          ),
        ],
      );
    });
  }
}

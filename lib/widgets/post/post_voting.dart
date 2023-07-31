import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/logged_in_action.dart';
import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../stores/config_store.dart';
import '../../util/observer_consumers.dart';
import '../tile_toggle.dart';
import 'post_store.dart';

class PostVoting extends HookWidget {
  const PostVoting({super.key});

  @override
  Widget build(BuildContext context) {
    final showScores = useStore((ConfigStore store) => store.showScores);
    final isLoggedIn =
        context.select<PostStore, bool>((store) => store.isAuthenticated);
    final loggedInAction = loggedInMessage(
        context
            .select<PostStore, String>((store) => store.postView.instanceHost),
        loggedIn: isLoggedIn);

    return ObserverBuilder<PostStore>(builder: (context, store) {
      return Row(
        children: [
          TileToggle(
            icon: Icons.arrow_upward,
            activated: store.postView.myVote == VoteType.up,
            activeColor: Colors.blue,
            onPressed: loggedInAction(store.upVote),
            tooltip: 'upvote',
          ),
          if (store.votingState.isLoading)
            SizedBox(
              width: showScores ? 32 : 20,
              height: 15,
              child: const Center(
                  child: SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator.adaptive())),
            )
          else if (showScores)
            SizedBox(
              width: 32,
              height: 15,
              child: Center(
                  child: Text(store.postView.counts.score.compact(context))),
            )
          else
            const SizedBox(
              width: 20,
              height: 15,
            ),
          TileToggle(
            icon: Icons.arrow_downward,
            activated: store.postView.myVote == VoteType.down,
            activeColor: Colors.orange,
            onPressed: loggedInAction(store.downVote),
            tooltip: 'downvote',
          ),
        ],
      );
    });
  }
}

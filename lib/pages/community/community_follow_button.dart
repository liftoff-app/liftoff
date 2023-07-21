import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/logged_in_action.dart';
import '../../l10n/l10n.dart';
import '../../util/observer_consumers.dart';
import '../view_on_menu.dart';
import 'community_store.dart';

class CommunityFollowButton extends HookWidget {
  final CommunityView communityView;

  const CommunityFollowButton(this.communityView, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final loggedInAction = useLoggedInAction(
        context.read<CommunityStore>().instanceHost, fallback: () {
      ViewOnMenu.openForCommunity(context, communityView.community.actorId);
    });

    return ObserverBuilder<CommunityStore>(builder: (context, store) {
      return ElevatedButtonTheme(
        data: ElevatedButtonThemeData(
          style: theme.elevatedButtonTheme.style?.copyWith(
            shape: MaterialStateProperty.all(const StadiumBorder()),
            textStyle: MaterialStateProperty.all(theme.textTheme.titleMedium),
          ),
        ),
        child: Center(
          child: SizedBox(
              height: 27,
              width: 160,
              child: ElevatedButton(
                onPressed: store.subscribingState.isLoading
                    ? () {}
                    : loggedInAction(store.subscribe),
                child: store.subscribingState.isLoading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          if (communityView.subscribed ==
                              SubscribedType.subscribed)
                            const Icon(Icons.remove, size: 18)
                          else if (communityView.subscribed ==
                              SubscribedType.pending)
                            const Icon(Icons.timer, size: 18)
                          else
                            const Icon(Icons.add, size: 18),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(communityView.subscribed ==
                                    SubscribedType.subscribed
                                ? L10n.of(context).unsubscribe
                                : communityView.subscribed ==
                                        SubscribedType.pending
                                    ? L10n.of(context).pending
                                    : L10n.of(context).subscribe),
                          )
                        ],
                      ),
              )),
        ),
      );
    });
  }
}

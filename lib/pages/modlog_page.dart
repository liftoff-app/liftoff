import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmy_api_client/v3.dart';

import '../util/extensions/api.dart';
import '../util/extensions/datetime.dart';
import '../util/goto.dart';
import '../widgets/avatar.dart';
import '../widgets/bottom_safe.dart';

class ModlogPage extends HookWidget {
  final String instanceHost;
  final String name;
  final int? communityId;

  const ModlogPage.forInstance({
    required this.instanceHost,
  })  : communityId = null,
        name = instanceHost;

  const ModlogPage.forCommunity({
    required this.instanceHost,
    required int this.communityId,
    required String communityName,
  }) : name = '!$communityName';

  @override
  Widget build(BuildContext context) {
    final page = useState(1);
    // will be set true when a fetch returns 0 results
    final isDone = useState(false);

    final modlogFut = useMemoized(
      () => LemmyApiV3(instanceHost).run(
        GetModlog(
          communityId: communityId,
          page: page.value,
        ),
      ),
      [page.value],
    );

    return Scaffold(
      appBar: AppBar(title: Text("$name's modlog")),
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                FutureBuilder<Modlog>(
                  key: ValueKey(modlogFut),
                  future: modlogFut,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: ${snapshot.error?.toString()}'));
                    }
                    final modlog = snapshot.requireData;

                    if (modlog.added.length +
                            modlog.addedToCommunity.length +
                            modlog.banned.length +
                            modlog.bannedFromCommunity.length +
                            modlog.lockedPosts.length +
                            modlog.removedComments.length +
                            modlog.removedCommunities.length +
                            modlog.removedPosts.length +
                            modlog.stickiedPosts.length ==
                        0) {
                      WidgetsBinding.instance
                          ?.addPostFrameCallback((_) => isDone.value = true);

                      return const Center(child: Text('no more logs to show'));
                    }

                    return _ModlogTable(modlog: modlog);
                  },
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed:
                                page.value != 1 ? () => page.value-- : null,
                            child: const Icon(Icons.skip_previous),
                          ),
                          TextButton(
                            onPressed: isDone.value ? null : () => page.value++,
                            child: const Icon(Icons.skip_next),
                          ),
                        ],
                      ),
                    ),
                    const BottomSafe(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModlogTable extends StatelessWidget {
  const _ModlogTable({Key? key, required this.modlog}) : super(key: key);

  final Modlog modlog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    InlineSpan user(PersonSafe user) => TextSpan(
          children: [
            WidgetSpan(
              child: Avatar(
                url: user.avatar,
                noBlank: true,
                radius: 10,
              ),
            ),
            TextSpan(
              text: ' ${user.preferredName}',
              style: TextStyle(color: theme.colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => goToUser.byId(
                      context,
                      user.instanceHost,
                      user.id,
                    ),
            ),
          ],
        );

    InlineSpan community(CommunitySafe community) => TextSpan(
          children: [
            WidgetSpan(
              child: Avatar(
                url: community.icon,
                noBlank: true,
                radius: 10,
              ),
            ),
            TextSpan(
              text: ' !${community.name}',
              style: TextStyle(color: theme.colorScheme.secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () => goToCommunity.byId(
                      context,
                      community.instanceHost,
                      community.id,
                    ),
            ),
          ],
        );

    final modlogEntries = [
      for (final removedPost in modlog.removedPosts)
        _ModlogEntry.fromModRemovePostView(
          removedPost,
          RichText(
            text: TextSpan(
              children: [
                if (removedPost.modRemovePost.removed ?? false)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'restored'),
                const TextSpan(text: ' post '),
                TextSpan(
                  text: '"${removedPost.post.name}"',
                  style: TextStyle(color: theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToPost(
                          context,
                          removedPost.instanceHost,
                          removedPost.post.id,
                        ),
                ),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final lockedPost in modlog.lockedPosts)
        _ModlogEntry.fromModLockPostView(
          lockedPost,
          RichText(
            text: TextSpan(
              children: [
                if (lockedPost.modLockPost.locked ?? false)
                  const TextSpan(text: 'locked')
                else
                  const TextSpan(text: 'unlocked'),
                const TextSpan(text: ' post '),
                TextSpan(
                  text: '"${lockedPost.post.name}"',
                  style: TextStyle(color: theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToPost(
                          context,
                          lockedPost.instanceHost,
                          lockedPost.post.id,
                        ),
                ),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final stickiedPost in modlog.stickiedPosts)
        _ModlogEntry.fromModStickyPostView(
          stickiedPost,
          RichText(
            text: TextSpan(
              children: [
                if (stickiedPost.modStickyPost.stickied ?? false)
                  const TextSpan(text: 'stickied')
                else
                  const TextSpan(text: 'unstickied'),
                const TextSpan(text: ' post '),
                TextSpan(
                  text: '"${stickiedPost.post.name}"',
                  style: TextStyle(color: theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToPost(
                          context,
                          stickiedPost.instanceHost,
                          stickiedPost.post.id,
                        ),
                ),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final removedComment in modlog.removedComments)
        _ModlogEntry.fromModRemoveCommentView(
          removedComment,
          RichText(
            text: TextSpan(
              children: [
                if (removedComment.modRemoveComment.removed ?? false)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'restored'),
                const TextSpan(text: ' comment '),
                TextSpan(
                  text:
                      '"${removedComment.comment.content.replaceAll('\n', ' ')}"',
                  style: TextStyle(color: theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToPost(
                          context,
                          removedComment.instanceHost,
                          removedComment.post.id,
                        ),
                ),
                const TextSpan(text: ' by '),
                user(removedComment.commenter),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final removedCommunity in modlog.removedCommunities)
        _ModlogEntry.fromModRemoveCommunityView(
          removedCommunity,
          RichText(
            text: TextSpan(
              children: [
                if (removedCommunity.modRemoveCommunity.removed ?? false)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'restored'),
                const TextSpan(text: ' community '),
                community(removedCommunity.community),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final bannedFromCommunity in modlog.bannedFromCommunity)
        _ModlogEntry.fromModBanFromCommunityView(
          bannedFromCommunity,
          RichText(
            text: TextSpan(
              children: [
                if (bannedFromCommunity.modBanFromCommunity.banned ?? false)
                  const TextSpan(text: 'banned ')
                else
                  const TextSpan(text: 'unbanned '),
                user(bannedFromCommunity.bannedPerson),
                const TextSpan(text: ' from community '),
                community(bannedFromCommunity.community),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final banned in modlog.banned)
        _ModlogEntry.fromModBanView(
          banned,
          RichText(
            text: TextSpan(
              children: [
                if (banned.modBan.banned ?? false)
                  const TextSpan(text: 'banned ')
                else
                  const TextSpan(text: 'unbanned '),
                user(banned.bannedPerson),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final addedToCommunity in modlog.addedToCommunity)
        _ModlogEntry.fromModAddCommunityView(
          addedToCommunity,
          RichText(
            text: TextSpan(
              children: [
                if (addedToCommunity.modAddCommunity.removed ?? false)
                  const TextSpan(text: 'removed ')
                else
                  const TextSpan(text: 'appointed '),
                user(addedToCommunity.moddedPerson),
                const TextSpan(text: ' as mod of '),
                community(addedToCommunity.community),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final transferredToCommunity in modlog.transferredToCommunity)
        _ModlogEntry.fromModTransferCommunityView(
          transferredToCommunity,
          RichText(
            text: TextSpan(
              children: [
                if (transferredToCommunity.modTransferCommunity.removed ??
                    false)
                  const TextSpan(text: 'removed ')
                else
                  const TextSpan(text: 'transferred '),
                community(transferredToCommunity.community),
                const TextSpan(text: ' to '),
                user(transferredToCommunity.moddedPerson),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
      for (final added in modlog.added)
        _ModlogEntry.fromModAddView(
          added,
          RichText(
            text: TextSpan(
              children: [
                if (added.modAdd.removed ?? false)
                  const TextSpan(text: 'removed ')
                else
                  const TextSpan(text: 'apointed '),
                user(added.moddedPerson),
                const TextSpan(text: ' as admin'),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
    ]..sort((a, b) => b.when.compareTo(a.when));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 1000,
        child: Table(
          border: TableBorder.all(color: theme.colorScheme.onSurface),
          columnWidths: const {
            0: FixedColumnWidth(80),
            1: FixedColumnWidth(200),
            2: FlexColumnWidth(),
            3: FixedColumnWidth(200),
          },
          children: [
            const TableRow(
              children: [
                Center(child: Text('when')),
                Center(child: Text('mod')),
                Center(child: Text('action')),
                Center(child: Text('reason')),
              ],
            ),
            for (final modlogEntry in modlogEntries) modlogEntry.build(context)
          ],
        ),
      ),
    );
  }
}

class _ModlogEntry {
  final DateTime when;
  final PersonSafe mod;
  final Widget action;
  final String? reason;

  const _ModlogEntry({
    required this.when,
    required this.mod,
    required this.action,
    this.reason,
  });

  _ModlogEntry.fromModRemovePostView(
    ModRemovePostView removedPost,
    Widget action,
  ) : this(
          when: removedPost.modRemovePost.when,
          mod: removedPost.moderator,
          action: action,
          reason: removedPost.modRemovePost.reason,
        );

  _ModlogEntry.fromModLockPostView(
    ModLockPostView lockedPost,
    Widget action,
  ) : this(
          when: lockedPost.modLockPost.when,
          mod: lockedPost.moderator,
          action: action,
        );

  _ModlogEntry.fromModStickyPostView(
    ModStickyPostView stickiedPost,
    Widget action,
  ) : this(
          when: stickiedPost.modStickyPost.when,
          mod: stickiedPost.moderator,
          action: action,
        );

  _ModlogEntry.fromModRemoveCommentView(
    ModRemoveCommentView removedComment,
    Widget action,
  ) : this(
          when: removedComment.modRemoveComment.when,
          mod: removedComment.moderator,
          action: action,
          reason: removedComment.modRemoveComment.reason,
        );

  _ModlogEntry.fromModRemoveCommunityView(
    ModRemoveCommunityView removedCommunity,
    Widget action,
  ) : this(
          when: removedCommunity.modRemoveCommunity.when,
          mod: removedCommunity.moderator,
          action: action,
          reason: removedCommunity.modRemoveCommunity.reason,
        );

  _ModlogEntry.fromModBanFromCommunityView(
    ModBanFromCommunityView bannedFromCommunity,
    Widget action,
  ) : this(
          when: bannedFromCommunity.modBanFromCommunity.when,
          mod: bannedFromCommunity.moderator,
          action: action,
          reason: bannedFromCommunity.modBanFromCommunity.reason,
        );

  _ModlogEntry.fromModBanView(
    ModBanView banned,
    Widget action,
  ) : this(
          when: banned.modBan.when,
          mod: banned.moderator,
          action: action,
          reason: banned.modBan.reason,
        );

  _ModlogEntry.fromModAddCommunityView(
    ModAddCommunityView addedToCommunity,
    Widget action,
  ) : this(
          when: addedToCommunity.modAddCommunity.when,
          mod: addedToCommunity.moderator,
          action: action,
        );

  _ModlogEntry.fromModTransferCommunityView(
    ModTransferCommunityView transferCommunity,
    Widget action,
  ) : this(
          when: transferCommunity.modTransferCommunity.when,
          mod: transferCommunity.moderator,
          action: action,
        );

  _ModlogEntry.fromModAddView(
    ModAddView added,
    Widget action,
  ) : this(
          when: added.modAdd.when,
          mod: added.moderator,
          action: action,
        );

  TableRow build(BuildContext context) => TableRow(
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Center(
                      heightFactor: 1,
                      child: Text(when.toString()),
                    ),
                  ),
                ),
              );
            },
            child: Center(child: Text(when.fancyShort)),
          ),
          GestureDetector(
            onTap: () => goToUser.byId(
              context,
              mod.instanceHost,
              mod.id,
            ),
            child: Row(
              children: [
                Avatar(
                  url: mod.avatar,
                  noBlank: true,
                  radius: 10,
                ),
                Text(
                  ' ${mod.preferredName}',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
          action,
          if (reason == null) const Center(child: Text('-')) else Text(reason!),
        ]
            .map(
              (widget) => Padding(
                padding: const EdgeInsets.all(8),
                child: widget,
              ),
            )
            .toList(),
      );
}

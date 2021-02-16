import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lemmur/hooks/memo_future.dart';
import 'package:lemmur/util/extensions/api.dart';
import 'package:lemmur/util/extensions/datetime.dart';
import 'package:lemmur/util/goto.dart';
import 'package:lemmy_api_client/v2.dart';

class ModlogPage extends HookWidget {
  final String instanceHost;
  final String name;
  final int communityId;

  const ModlogPage.forInstance({
    @required this.instanceHost,
  })  : assert(instanceHost != null),
        communityId = null,
        name = instanceHost;

  const ModlogPage.forCommunity({
    @required this.instanceHost,
    @required this.communityId,
    @required String communityName,
  })  : assert(instanceHost != null),
        assert(communityId != null),
        assert(communityName != null),
        name = '!$communityName';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modlogSnap = useMemoFuture(() =>
        LemmyApiV2(instanceHost).run(GetModlog(communityId: communityId)));

    if (!modlogSnap.hasData) {
      return Scaffold();
    }

    final modlog = modlogSnap.data;

    final modlogEntries = [
      for (final removedPost in modlog.removedPosts)
        _ModlogEntry.fromModRemovePostView(
          removedPost,
          RichText(
            text: TextSpan(
              children: [
                if (removedPost.modRemovePost.removed)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'restored'),
                const TextSpan(text: ' post '),
                TextSpan(
                  text: '"${removedPost.post.name}"',
                  style: TextStyle(color: theme.accentColor),
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
                if (lockedPost.modLockPost.locked)
                  const TextSpan(text: 'locked')
                else
                  const TextSpan(text: 'unlocked'),
                const TextSpan(text: ' post '),
                TextSpan(
                  text: '"${lockedPost.post.name}"',
                  style: TextStyle(color: theme.accentColor),
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
                if (stickiedPost.modStickyPost.stickied)
                  const TextSpan(text: 'stickied')
                else
                  const TextSpan(text: 'unstickied'),
                const TextSpan(text: ' post '),
                TextSpan(
                  text: '"${stickiedPost.post.name}"',
                  style: TextStyle(color: theme.accentColor),
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
                if (removedComment.modRemoveComment.removed)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'restored'),
                const TextSpan(text: ' comment on '),
                TextSpan(
                  text: '"${removedComment.post.name}"',
                  style: TextStyle(color: theme.accentColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToPost(
                          context,
                          removedComment.instanceHost,
                          removedComment.post.id,
                        ),
                ),
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
                if (removedCommunity.modRemoveCommunity.removed)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'restored'),
                const TextSpan(text: ' community '),
                TextSpan(
                  text: '"${removedCommunity.community.name}"',
                  style: TextStyle(color: theme.accentColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToCommunity.byId(
                          context,
                          removedCommunity.instanceHost,
                          removedCommunity.community.id,
                        ),
                ),
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
                if (bannedFromCommunity.modBanFromCommunity.banned)
                  const TextSpan(text: 'banned')
                else
                  const TextSpan(text: 'unbanned'),
                const TextSpan(text: ' from community '),
                TextSpan(
                  text: '"${bannedFromCommunity.community.name}"',
                  style: TextStyle(color: theme.accentColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToCommunity.byId(
                          context,
                          bannedFromCommunity.instanceHost,
                          bannedFromCommunity.community.id,
                        ),
                ),
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
                if (banned.modBan.banned)
                  const TextSpan(text: 'banned')
                else
                  const TextSpan(text: 'unbanned'),
                const TextSpan(text: ' user '),
                TextSpan(
                  text: '"${banned.bannedUser.displayName}"',
                  style: TextStyle(color: theme.accentColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToUser.byId(
                          context,
                          banned.instanceHost,
                          banned.bannedUser.id,
                        ),
                ),
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
                if (addedToCommunity.modAddCommunity.removed)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'added'),
                const TextSpan(text: ' as mod '),
                TextSpan(
                  text: '"${addedToCommunity.moddedUser.displayName}"',
                  style: TextStyle(color: theme.accentColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToUser.byId(
                          context,
                          addedToCommunity.instanceHost,
                          addedToCommunity.moddedUser.id,
                        ),
                ),
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
                if (added.modAdd.removed)
                  const TextSpan(text: 'removed')
                else
                  const TextSpan(text: 'added'),
                const TextSpan(text: ' as admin '),
                TextSpan(
                  text: '"${added.moddedUser.displayName}"',
                  style: TextStyle(color: theme.accentColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToUser.byId(
                          context,
                          added.instanceHost,
                          added.moddedUser.id,
                        ),
                ),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
    ]..sort((a, b) => b.when.compareTo(a.when));

    return Scaffold(
      appBar: AppBar(
        title: Text("$name's modlog"),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            border: TableBorder.all(width: 1),
            columnWidths: {
              0: FixedColumnWidth(100),
              1: FixedColumnWidth(150),
              2: FixedColumnWidth(400),
              3: FixedColumnWidth(200),
            },
            children: [
              TableRow(
                children: [
                  Center(child: Text('when')),
                  Center(child: Text('mod')),
                  Center(child: Text('action')),
                  Center(child: Text('reason')),
                ],
              ),
              for (final modlogEntry in modlogEntries)
                modlogEntry.build(context)
            ],
          ),
        ),
      ),
    );
  }
}

class _ModlogEntry {
  final DateTime when;
  final UserSafe mod;
  final Widget action;
  final String reason;

  const _ModlogEntry({
    @required this.when,
    @required this.mod,
    @required this.action,
    this.reason,
  })  : assert(when != null),
        assert(mod != null),
        assert(action != null);

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
          Center(child: Text(when.fancyShort)),
          InkWell(
            onTap: () => goToUser.byId(context, mod.instanceHost, mod.id),
            child: Text(mod.displayName),
          ),
          action,
          if (reason == null) Center(child: Text('-')) else Text(reason ?? '-'),
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

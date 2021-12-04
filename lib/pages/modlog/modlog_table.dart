import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../util/extensions/api.dart';
import '../../util/goto.dart';
import '../../widgets/avatar.dart';
import 'modlog_entry.dart';

class ModlogTable extends StatelessWidget {
  const ModlogTable({Key? key, required this.modlog}) : super(key: key);

  final Modlog modlog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    InlineSpan user(PersonSafe user) {
      return TextSpan(
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
    }

    InlineSpan community(CommunitySafe community) {
      return TextSpan(
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
    }

    final modlogEntries = [
      for (final removedPost in modlog.removedPosts)
        ModlogEntry.fromModRemovePostView(
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
        ModlogEntry.fromModLockPostView(
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
        ModlogEntry.fromModStickyPostView(
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
        ModlogEntry.fromModRemoveCommentView(
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
        ModlogEntry.fromModRemoveCommunityView(
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
        ModlogEntry.fromModBanFromCommunityView(
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
        ModlogEntry.fromModBanView(
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
        ModlogEntry.fromModAddCommunityView(
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
        ModlogEntry.fromModTransferCommunityView(
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
        ModlogEntry.fromModAddView(
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

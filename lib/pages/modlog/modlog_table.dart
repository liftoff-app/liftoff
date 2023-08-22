import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/api.dart';
import '../../util/goto.dart';
import '../../widgets/avatar.dart';
import 'modlog_entry.dart';

class ModlogTable extends StatelessWidget {
  const ModlogTable({super.key, required this.modlog});

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
              originPreferredName: user.originPreferredName,
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
                    null,
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
              originPreferredName: community.originPreferredName,
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
                  TextSpan(text: L10n.of(context).modlog_removed)
                else
                  TextSpan(text: L10n.of(context).modlog_restored),
                TextSpan(text: ' ${L10n.of(context).modlog_post_separator} '),
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
                  TextSpan(text: L10n.of(context).modlog_locked)
                else
                  TextSpan(text: L10n.of(context).modlog_unlocked),
                TextSpan(text: ' ${L10n.of(context).modlog_post_separator} '),
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
      for (final featuredPost in modlog.featuredPosts)
        ModlogEntry.fromModStickyPostView(
          featuredPost,
          RichText(
            text: TextSpan(
              children: [
                if (featuredPost.post.featuredCommunity ||
                    featuredPost.post.featuredLocal)
                  TextSpan(text: L10n.of(context).modlog_stickied)
                else
                  TextSpan(text: L10n.of(context).modlog_unstickied),
                TextSpan(text: ' ${L10n.of(context).modlog_post_separator} '),
                TextSpan(
                  text: '"${featuredPost.post.name}"',
                  style: TextStyle(color: theme.colorScheme.secondary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => goToPost(
                          context,
                          featuredPost.instanceHost,
                          featuredPost.post.id,
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
                  TextSpan(text: L10n.of(context).modlog_removed)
                else
                  TextSpan(text: L10n.of(context).modlog_restored),
                TextSpan(
                    text: ' ${L10n.of(context).modlog_comment_separator} '),
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
                TextSpan(text: ' ${L10n.of(context).modlog_by} '),
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
                  TextSpan(text: L10n.of(context).modlog_removed)
                else
                  TextSpan(text: L10n.of(context).modlog_restored),
                TextSpan(
                    text: ' ${L10n.of(context).modlog_community_separator} '),
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
                  TextSpan(text: '${L10n.of(context).modlog_banned} ')
                else
                  TextSpan(text: '${L10n.of(context).modlog_unbanned} '),
                user(bannedFromCommunity.bannedPerson),
                TextSpan(
                    text: ' ${L10n.of(context).modlog_community_separator} '),
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
                  TextSpan(text: '${L10n.of(context).modlog_banned} ')
                else
                  TextSpan(text: '${L10n.of(context).modlog_unbanned} '),
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
                  TextSpan(text: '${L10n.of(context).modlog_removed} ')
                else
                  TextSpan(text: '${L10n.of(context).modlog_appointed} '),
                user(addedToCommunity.moddedPerson),
                TextSpan(
                    text: ' ${L10n.of(context).modlog_appointed_separator} '),
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
                  TextSpan(text: '${L10n.of(context).modlog_removed} ')
                else
                  TextSpan(text: '${L10n.of(context).modlog_transferred} '),
                community(transferredToCommunity.community),
                TextSpan(
                    text: ' ${L10n.of(context).modlog_transferred_separator} '),
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
                  TextSpan(text: '${L10n.of(context).modlog_removed} ')
                else
                  TextSpan(text: '${L10n.of(context).modlog_appointed} '),
                user(added.moddedPerson),
                TextSpan(text: ' ${L10n.of(context).modlog_admin_separator}'),
              ],
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
        ),
    ]..sort((a, b) => b.when.compareTo(a.when));

    return ListView(
      shrinkWrap: true,
      children: modlogEntries.map((e) => e.build(context)).toList(),
    );
  }
}

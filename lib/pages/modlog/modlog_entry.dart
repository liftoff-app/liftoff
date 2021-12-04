import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/api.dart';
import '../../util/goto.dart';
import '../../widgets/avatar.dart';

class ModlogEntry {
  final DateTime when;
  final PersonSafe mod;
  final Widget action;
  final String? reason;

  const ModlogEntry._({
    required this.when,
    required this.mod,
    required this.action,
    this.reason,
  });

  ModlogEntry.fromModRemovePostView(
    ModRemovePostView removedPost,
    Widget action,
  ) : this._(
          when: removedPost.modRemovePost.when,
          mod: removedPost.moderator,
          action: action,
          reason: removedPost.modRemovePost.reason,
        );

  ModlogEntry.fromModLockPostView(
    ModLockPostView lockedPost,
    Widget action,
  ) : this._(
          when: lockedPost.modLockPost.when,
          mod: lockedPost.moderator,
          action: action,
        );

  ModlogEntry.fromModStickyPostView(
    ModStickyPostView stickiedPost,
    Widget action,
  ) : this._(
          when: stickiedPost.modStickyPost.when,
          mod: stickiedPost.moderator,
          action: action,
        );

  ModlogEntry.fromModRemoveCommentView(
    ModRemoveCommentView removedComment,
    Widget action,
  ) : this._(
          when: removedComment.modRemoveComment.when,
          mod: removedComment.moderator,
          action: action,
          reason: removedComment.modRemoveComment.reason,
        );

  ModlogEntry.fromModRemoveCommunityView(
    ModRemoveCommunityView removedCommunity,
    Widget action,
  ) : this._(
          when: removedCommunity.modRemoveCommunity.when,
          mod: removedCommunity.moderator,
          action: action,
          reason: removedCommunity.modRemoveCommunity.reason,
        );

  ModlogEntry.fromModBanFromCommunityView(
    ModBanFromCommunityView bannedFromCommunity,
    Widget action,
  ) : this._(
          when: bannedFromCommunity.modBanFromCommunity.when,
          mod: bannedFromCommunity.moderator,
          action: action,
          reason: bannedFromCommunity.modBanFromCommunity.reason,
        );

  ModlogEntry.fromModBanView(
    ModBanView banned,
    Widget action,
  ) : this._(
          when: banned.modBan.when,
          mod: banned.moderator,
          action: action,
          reason: banned.modBan.reason,
        );

  ModlogEntry.fromModAddCommunityView(
    ModAddCommunityView addedToCommunity,
    Widget action,
  ) : this._(
          when: addedToCommunity.modAddCommunity.when,
          mod: addedToCommunity.moderator,
          action: action,
        );

  ModlogEntry.fromModTransferCommunityView(
    ModTransferCommunityView transferCommunity,
    Widget action,
  ) : this._(
          when: transferCommunity.modTransferCommunity.when,
          mod: transferCommunity.moderator,
          action: action,
        );

  ModlogEntry.fromModAddView(
    ModAddView added,
    Widget action,
  ) : this._(
          when: added.modAdd.when,
          mod: added.moderator,
          action: action,
        );

  TableRow build(BuildContext context) {
    return TableRow(
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
          child: Center(child: Text(when.timeagoShort(context))),
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
}

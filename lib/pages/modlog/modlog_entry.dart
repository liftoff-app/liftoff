import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/api.dart';
import '../../util/goto.dart';
import '../../widgets/avatar.dart';

class ModlogEntry {
  final DateTime when;
  final PersonSafe? mod;
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
    ModFeaturePostView featuredPost,
    Widget action,
  ) : this._(
          when: featuredPost.modFeaturePost.when,
          mod: featuredPost.moderator,
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
          mod: addedToCommunity.moddedPerson,
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

  // required List<ModHideCommunityView> hiddenCommunities,
  ModlogEntry.fromModHideView(
    ModHideCommunityView hidden,
    Widget action,
  ) : this._(
          when: hidden.modHideCommunity.when,
          mod: hidden.admin,
          action: action,
        );

  // required List<AdminPurgeCommentView> adminPurgedComments,
  ModlogEntry.fromModAdminPurgeCommentView(
    AdminPurgeCommentView purgedComment,
    Widget action,
  ) : this._(
          when: purgedComment.adminPurgeComment.when,
          mod: purgedComment.admin,
          action: action,
        );

  // required List<AdminPurgePersonView> adminPurgedPersons,
  ModlogEntry.fromModAdminPurgePersonView(
    AdminPurgePersonView purgedPerson,
    Widget action,
  ) : this._(
          when: purgedPerson.adminPurgePerson.when,
          mod: purgedPerson.admin,
          action: action,
        );

  // required List<AdminPurgeCommunityView> adminPurgedCommunities,
  ModlogEntry.fromModAdminPurgeCommunityView(
    AdminPurgeCommunityView purgedCommunity,
    Widget action,
  ) : this._(
          when: purgedCommunity.adminPurgeCommunity.when,
          mod: purgedCommunity.admin,
          action: action,
        );
  // required List<AdminPurgePostView> adminPurgedPosts,
  ModlogEntry.fromModAdminPurgePostView(
    AdminPurgePostView purgedPost,
    Widget action,
  ) : this._(
          when: purgedPost.adminPurgePost.when,
          mod: purgedPost.admin,
          action: action,
        );

  ListTile build(BuildContext context) {
    return ListTile(
      leading: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 50),
          child: Column(
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
                child: Center(
                    child: Chip(
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                        label: Text(
                          when.timeagoShort(context),
                        ))),
              ),
            ],
          )),
      title: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 75, maxWidth: 600),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              action,
              Row(
                children: [
                  if (mod != null)
                    GestureDetector(
                      onTap: () => goToUser.byId(
                          context, mod!.instanceHost, mod!.id, null),
                      child: Row(
                        children: [
                          Avatar(
                            url: mod!.avatar,
                            originPreferredName: mod!.originPreferredName,
                            noBlank: true,
                            radius: 10,
                          ),
                          Text(
                            ' ${mod!.preferredName}',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ],
                      ),
                    ),
                  if (reason != null)
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: Text('${L10n.of(context).modlog_reason} $reason',
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.fade),
                    ),
                ],
              ),
            ]),
      ),
    );
  }
}

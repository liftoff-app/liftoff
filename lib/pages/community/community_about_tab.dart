import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../stores/accounts_store.dart';
import '../../util/extensions/spaced.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/bottom_safe.dart';
import '../../widgets/markdown_text.dart';
import '../../widgets/pull_to_refresh.dart';
import '../../widgets/user_tile.dart';
import '../modlog/modlog.dart';
import 'community_store.dart';

class CommmunityAboutTab extends StatelessWidget {
  final FullCommunityView fullCommunityView;

  const CommmunityAboutTab(this.fullCommunityView, {super.key});

  @override
  Widget build(BuildContext context) {
    final community = fullCommunityView.communityView;
    final onlineUsers = fullCommunityView.online;
    final moderators = fullCommunityView.moderators;

    return PullToRefresh(
      onRefresh: () async {
        await context.read<CommunityStore>().refresh(context
            .read<AccountsStore>()
            .defaultUserDataFor(fullCommunityView.instanceHost));
      },
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          if (community.community.description != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: MarkdownText(
                community.community.description!,
                instanceHost: community.instanceHost,
              ),
            ),
            const _Divider(),
          ],
          SizedBox(
            height: 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: [
                Chip(
                    // TODO: v0.18.x migration
                    label: Text(L10n.of(context)
                        .number_of_users_online(onlineUsers ?? 0))),
                Chip(
                    label: Text('${L10n.of(context)
                        .number_of_users(community.counts.usersActiveDay)}'
                        ' / ${L10n.of(context).day}')),
                Chip(
                    label: Text('${L10n.of(context)
                        .number_of_users(community.counts.usersActiveWeek)}'
                        ' / ${L10n.of(context).week}')),
                Chip(
                    label: Text('${L10n.of(context)
                        .number_of_users(community.counts.usersActiveMonth)}'
                        ' / ${L10n.of(context).month}')),
                Chip(
                    label: Text('${L10n.of(context)
                        .number_of_users(community.counts.usersActiveHalfYear)}'
                        ' / 6 ${L10n.of(context).month}s')),
                Chip(
                    label: Text(L10n.of(context)
                        .number_of_subscribers(community.counts.subscribers))),
                Chip(
                    label: Text(L10n.of(context)
                        .number_of_posts(community.counts.posts ))),
                Chip(
                    label: Text(L10n.of(context)
                        .number_of_comments(community.counts.comments, 0))), // TODO why does this need 2 args???
              ].spaced(8),
            ),
          ),
          const _Divider(),
          if (moderators.isNotEmpty) ...[
            const ListTile(
              title: Center(
                child: Text('Mods:'),
              ),
            ),
            for (final mod in moderators)
              PersonTile(
                mod.moderator!,
                expanded: true,
              ),
          ],
          const _Divider(),
          ListTile(
            title: Center(
              child: Text(
                L10n.of(context).modlog,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            onTap: () => Navigator.of(context).push(
              ModlogPage.forCommunityRoute(
                instanceHost: community.instanceHost,
                communityId: community.community.id,
                communityName: community.community.name,
              ),
            ),
          ),
          const BottomSafe(),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Divider(),
      );
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../l10n/l10n.dart';
import '../../util/extensions/api.dart';
import '../../widgets/avatar.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/fullscreenable_image.dart';
import '../instance/instance.dart';
import 'community_follow_button.dart';

class CommunityOverview extends StatelessWidget {
  final FullCommunityView fullCommunityView;

  const CommunityOverview(this.fullCommunityView, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final community = fullCommunityView.communityView;

    final icon = community.community.icon != null
        ? Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.7),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              FullscreenableImage(
                url: community.community.icon!,
                child: Material(
                  color: Colors.transparent,
                  child: Avatar(
                    url: community.community.icon,
                    radius: 83 / 2,
                    alwaysShow: true,
                  ),
                ),
              ),
            ],
          )
        : null;

    return Stack(
      children: [
        if (community.community.banner != null)
          FullscreenableImage(
            url: community.community.banner!,
            child: CachedNetworkImage(
              imageUrl: community.community.banner!,
              errorBuilder: (_, ___) => const SizedBox.shrink(),
            ),
          ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              if (icon != null) icon,
              const SizedBox(height: 10),
              // NAME
              BlurBox(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: theme.textTheme.titleMedium,
                    children: [
                      const TextSpan(
                        text: '!',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: community.community.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(
                        text: '@',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                      TextSpan(
                        text: community.community.originInstanceHost,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).push(
                                InstancePage.route(
                                  community.community.originInstanceHost,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // TITLE/MOTTO
              const SizedBox(height: 8),
              BlurBox(
                child: Text(
                  '${community.community.title}${community.community.instanceHost != community.community.originInstanceHost ? ' (via ${community.community.instanceHost})' : ''}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
              const SizedBox(height: 15),
              Stack(
                alignment: Alignment.center,
                children: [
                  // INFO ICONS
                  Row(
                    children: [
                      const Spacer(),
                      BlurBox(
                          child: Row(children: [
                        const Icon(Icons.people, size: 20),
                        const SizedBox(width: 3),
                        Text(
                          community.counts.subscribers.compact(context),
                        ),
                      ])),
                      const Spacer(flex: 4),
                      BlurBox(
                          child: Row(children: [
                        const Icon(Icons.record_voice_over, size: 20),
                        const SizedBox(width: 3),
                        // TODO: v0.18.x migration
                        Text(
                          (fullCommunityView.online ?? 0).compact(context),
                        ),
                      ])),
                      const Spacer(),
                    ],
                  ),
                  CommunityFollowButton(community),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BlurBox extends StatelessWidget {
  final Widget child;

  const BlurBox({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: theme.canvasColor.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 1,
          )
        ],
        color: theme.canvasColor.withOpacity(0.3),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5), child: child),
    );
  }
}

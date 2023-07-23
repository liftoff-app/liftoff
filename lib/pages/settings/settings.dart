import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:lemmy_api_client/v3.dart';

import '../../hooks/stores.dart';
import '../../l10n/l10n.dart';
import '../../resources/app_theme.dart';
import '../../stores/config_store.dart';
import '../../util/async_store_listener.dart';
import '../../util/extensions/iterators.dart';
import '../../util/goto.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/about_tile.dart';
import '../../widgets/bottom_modal.dart';
import '../../widgets/post/post.dart';
import '../../widgets/radio_picker.dart';
import '../full_post/comment_section.dart';
import '../full_post/full_post_store.dart';
import '../manage_account.dart';
import 'add_account_page.dart';
import 'add_instance_page.dart';
import 'blocks/blocks.dart';
import 'mock_post.dart';

/// Page with a list of different settings sections
class SettingsPage extends HookWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hasAnyUsers = useAccountsStoreSelect((store) => !store.hasNoAccount);

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(L10n.of(context).general),
            onTap: () {
              goTo(context, (_) => const GeneralConfigPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(L10n.of(context).accounts),
            onTap: () {
              goTo(context, (_) => AccountsConfigPage());
            },
          ),
          if (hasAnyUsers)
            ListTile(
              leading: const Icon(Icons.block),
              title: Text(L10n.of(context).blocks),
              onTap: () {
                Navigator.of(context).push(BlocksPage.route());
              },
            ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(L10n.of(context).appearance),
            onTap: () {
              goTo(context, (_) => const AppearanceConfigPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_agenda),
            title: Text(L10n.of(context).post_style),
            onTap: () {
              goTo(context, (_) => const PostStyleConfigPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.comment),
            title: Text(L10n.of(context).comment_style),
            onTap: () {
              goTo(context, (_) => const CommentStyleConfigPage());
            },
          ),
          const AboutTile()
        ],
      ),
    );
  }
}

/// Settings for theme color, AMOLED switch
class AppearanceConfigPage extends StatelessWidget {
  const AppearanceConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).appearance)),
      body: Consumer<AppTheme>(
        builder: (context, state, child) {
          return ListView(
            children: [
              _SectionHeading(L10n.of(context).theme),
              for (final theme in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: theme,
                  title: Text(theme.name),
                  groupValue: state.theme,
                  onChanged: (selected) {
                    if (selected != null) {
                      state.switchtheme(selected);
                    }
                  },
                ),
              SwitchListTile.adaptive(
                title: Text(L10n.of(context).amoled_dark_mode),
                value: state.amoledWanted,
                onChanged: (checked) => state.switchamoled(),
              ),
              ListTile(
                title: Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(L10n.of(context).primary_color),
                    IconButton(
                      onPressed: () {
                        // Pull default values from the system themes
                        if (state.theme == ThemeMode.dark) {
                          state.setPrimaryColor(
                              ThemeData.dark().colorScheme.secondary);
                        } else {
                          state.setPrimaryColor(
                              ThemeData.light().colorScheme.primary);
                        }
                      },
                      icon: const Icon(Icons.restart_alt_outlined),
                      tooltip: L10n.of(context).reset_to_default,
                    ),
                  ],
                ),
                trailing: SizedBox(
                  width: 60,
                  child: RawMaterialButton(
                    onPressed: () {
                      showBottomModal(
                        context: context,
                        builder: (context) => Column(
                          children: [
                            MaterialPicker(
                              pickerColor: state.primaryColor,
                              onColorChanged: (Color color) {
                                state.setPrimaryColor(color);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    fillColor: state.primaryColor,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Settings for theme color, AMOLED switch
class PostStyleConfigPage extends StatelessWidget {
  const PostStyleConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    const decoder = JsonDecoder();
    final gradient = SizedBox(
      width: 250,
      height: 1,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Theme.of(context).primaryColorDark,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).primaryColorDark,
          ],
        )),
      ),
    );
    return Consumer<AppTheme>(builder: (context, state, child) {
      return Scaffold(
          appBar: AppBar(title: Text(L10n.of(context).post_style)),
          body: ObserverBuilder<ConfigStore>(
              builder: (context, store) => ListView(
                    children: [
                      _SectionHeading(L10n.of(context).post_view),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).post_style_compact),
                        value: store.compactPostView,
                        onChanged: (checked) {
                          store.compactPostView = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title:
                            Text(L10n.of(context).post_style_rounded_corners),
                        value: store.postRoundedCornersV2,
                        onChanged: (checked) {
                          store.postRoundedCornersV2 = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).post_style_shadow),
                        value: store.postCardShadowV2,
                        onChanged: (checked) {
                          store.postCardShadowV2 = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).show_avatars),
                        value: store.showAvatars,
                        onChanged: (checked) {
                          store.showAvatars = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).show_thumbnails),
                        value: store.showThumbnail,
                        onChanged: (checked) {
                          store.showThumbnail = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).show_scores),
                        value: store.showScores,
                        onChanged: (checked) {
                          store.showScores = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).auto_play_video),
                        value: store.autoPlayVideo,
                        onChanged: (checked) {
                          store.autoPlayVideo = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).auto_mute_video),
                        value: store.autoMuteVideo,
                        onChanged: (checked) {
                          store.autoMuteVideo = checked;
                        },
                      ),
                      const SizedBox(height: 12),
                      _SectionHeading(L10n.of(context).font),
                      ListTile(
                        title: Text(L10n.of(context).post_title_size),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              11,
                              12,
                              13,
                              14,
                              15,
                              16,
                              17,
                              18,
                              19,
                              20,
                              21,
                              22,
                              23
                            ],
                            groupValue: store.titleFontSize,
                            onChanged: (value) => store.titleFontSize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).post_header_size),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              11,
                              12,
                              13,
                              14,
                              15,
                              16,
                              17,
                              18,
                              19,
                              20,
                              21,
                              22,
                              23
                            ],
                            groupValue: store.postHeaderFontSize,
                            onChanged: (value) =>
                                store.postHeaderFontSize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).post_body_size),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              11,
                              12,
                              13,
                              14,
                              15,
                              16,
                              17,
                              18,
                              19,
                              20,
                              21,
                              22,
                              23
                            ],
                            groupValue: store.postBodySize,
                            onChanged: (value) => store.postBodySize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _SectionHeading(L10n.of(context).preview),
                      const SizedBox(height: 20),
                      IgnorePointer(
                          child: PostTile.fromPostView(PostView.fromJson(
                              decoder.convert(mockTextPostJson)))),
                      if (state.useAmoled) gradient,
                      SizedBox(height: store.compactPostView ? 2 : 10),
                      IgnorePointer(
                          child: PostTile.fromPostView(PostView.fromJson(
                              decoder.convert(mockMediaPost)))),
                      if (state.useAmoled) gradient,
                      SizedBox(height: store.compactPostView ? 2 : 10),
                      IgnorePointer(
                          child: PostTile.fromPostView(PostView.fromJson(
                              decoder.convert(mockLinkPost)))),
                    ],
                  )));
    });
  }
}

class CommentStyleConfigPage extends HookWidget {
  const CommentStyleConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final postStore =
        FullPostStore(postId: 51, instanceHost: 'stable.liftoff-app.org');
    // ignore: cascade_invocations
    postStore.sorting = CommentSortType.top;
    // ignore: cascade_invocations
    postStore.refresh();

    return Consumer<AppTheme>(builder: (context, state, child) {
      return Scaffold(
          appBar: AppBar(title: Text(L10n.of(context).comment_style)),
          body: ObserverBuilder<ConfigStore>(
              builder: (context, store) => ListView(
                    children: [
                      const SizedBox(height: 12),
                      _SectionHeading(L10n.of(context).font),
                      ListTile(
                        title: Text(L10n.of(context).comment_title_size),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              11,
                              12,
                              13,
                              14,
                              15,
                              16,
                              17,
                              18,
                              19,
                              20,
                              21,
                              22,
                              23
                            ],
                            groupValue: store.commentTitleSize,
                            onChanged: (value) =>
                                store.commentTitleSize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).comment_time_stamp),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              11,
                              12,
                              13,
                              14,
                              15,
                              16,
                              17,
                              18,
                              19,
                              20,
                              21,
                              22,
                              23
                            ],
                            groupValue: store.commentTimestampSize,
                            onChanged: (value) =>
                                store.commentTimestampSize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).comment_body_size),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              11,
                              12,
                              13,
                              14,
                              15,
                              16,
                              17,
                              18,
                              19,
                              20,
                              21,
                              22,
                              23
                            ],
                            groupValue: store.commentBodySize,
                            onChanged: (value) => store.commentBodySize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).comment_pill_size),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [8, 9, 10, 11, 12, 13, 14, 15, 16],
                            groupValue: store.commentPillSize,
                            onChanged: (value) => store.commentPillSize = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(L10n.of(context).comment_indent_width),
                        trailing: SizedBox(
                          width: 120,
                          child: RadioPicker<double>(
                            values: const [
                              2,
                              3,
                              4,
                              5,
                              6,
                              7,
                              8,
                            ],
                            groupValue: store.commentIndentWidth,
                            onChanged: (value) =>
                                store.commentIndentWidth = value,
                            mapValueToString: (value) =>
                                value.round().toString(),
                            buttonBuilder: (context, displayValue, onPressed) =>
                                FilledButton(
                              onPressed: onPressed,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(displayValue),
                                  const Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _SectionHeading(L10n.of(context).preview),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400,
                        child: ListView(
                          children:
                              CommentSection.buildComments(context, postStore)
                                  .mapWithIndex((e, i) => e)
                                  // i == 0 ? e : IgnorePointer(child: e))
                                  .toList(),
                        ),
                      ),
                    ],
                  )));
    });
  }
}

/// General settings
class GeneralConfigPage extends StatelessWidget {
  const GeneralConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L10n.of(context).general)),
      body: ObserverBuilder<ConfigStore>(
        builder: (context, store) => ListView(
          children: [
            ListTile(
              title: Text(L10n.of(context).sort_type),
              trailing: SizedBox(
                width: 120,
                child: RadioPicker<SortType>(
                  values: SortType.values,
                  groupValue: store.defaultSortType,
                  onChanged: (value) => store.defaultSortType = value,
                  mapValueToString: (value) => value.value,
                  buttonBuilder: (context, displayValue, onPressed) =>
                      FilledButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(displayValue),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).comment_sort_type),
              trailing: SizedBox(
                width: 120,
                child: RadioPicker<CommentSortType>(
                  values: CommentSortType.values
                      .sublist(0, CommentSortType.values.length - 1),
                  groupValue: store.defaultCommentSort,
                  onChanged: (value) => store.defaultCommentSort = value,
                  mapValueToString: (value) => value.value,
                  buttonBuilder: (context, displayValue, onPressed) =>
                      FilledButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(displayValue),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).type),
              trailing: SizedBox(
                width: 120,
                child: RadioPicker<PostListingType>(
                  values: const [
                    PostListingType.all,
                    PostListingType.local,
                    PostListingType.subscribed,
                  ],
                  groupValue: store.defaultListingType,
                  onChanged: (value) => store.defaultListingType = value,
                  mapValueToString: (value) => value.value,
                  buttonBuilder: (context, displayValue, onPressed) =>
                      FilledButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(displayValue),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(L10n.of(context).language),
              trailing: SizedBox(
                width: 120,
                child: RadioPicker<Locale>(
                  title: L10n.of(context).choose_language,
                  groupValue: store.locale,
                  values: L10n.supportedLocales,
                  mapValueToString: (locale) => locale.languageName,
                  onChanged: (selected) {
                    store.locale = selected;
                  },
                  buttonBuilder: (context, displayValue, onPressed) =>
                      FilledButton(
                    onPressed: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(displayValue),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SwitchListTile.adaptive(
              title: Text(L10n.of(context).show_everything_feed),
              subtitle: Text(L10n.of(context).show_everything_feed_explanation),
              value: store.showEverythingFeed,
              onChanged: (checked) {
                store.showEverythingFeed = checked;
              },
            ),
            SwitchListTile.adaptive(
              title: Text(L10n.of(context).use_in_app_browser),
              value: store.useInAppBrowser,
              onChanged: (checked) {
                store.useInAppBrowser = checked;
              },
            ),
            SwitchListTile.adaptive(
              title: Text(L10n.of(context).convert_webp_to_png),
              value: store.convertWebpToPng,
              onChanged: (checked) {
                store.convertWebpToPng = checked;
              },
            ),
            const SizedBox(height: 12),
            _SectionHeading(L10n.of(context).other_settings),
            SwitchListTile.adaptive(
              title: Text(L10n.of(context).disable_animations),
              value: store.disableAnimations,
              onChanged: (checked) {
                store.disableAnimations = checked;
              },
            ),
            SwitchListTile.adaptive(
              title: Text(L10n.of(context).hide_nsfw),
              subtitle: Text(L10n.of(context).hide_nsfw_explanation),
              value: store.blurNsfw,
              onChanged: (checked) {
                store.blurNsfw = checked;
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Popup for an account
class _AccountOptions extends HookWidget {
  final String instanceHost;
  final String username;

  const _AccountOptions({
    required this.instanceHost,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    final accountsStore = useAccountsStore();

    Future<void> removeUserDialog(String instanceHost, String username) async {
      if (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(L10n.of(context).remove_user_confirm),
              content: Text(L10n.of(context)
                  .remove_user_confirm_explanation('$username@$instanceHost')),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(L10n.of(context).yes),
                ),
              ],
            ),
          ) ??
          false) {
        await accountsStore.removeAccount(instanceHost, username);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    return Column(
      children: [
        if (accountsStore.defaultUsernameFor(instanceHost) != username)
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: Text(L10n.of(context).set_as_default),
            onTap: () {
              accountsStore.setDefaultAccountFor(instanceHost, username);
              Navigator.of(context).pop();
            },
          ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: Text(L10n.of(context).remove_account),
          onTap: () => removeUserDialog(instanceHost, username),
        ),
        AsyncStoreListener(
          asyncStore: context.read<ConfigStore>().lemmyImportState,
          successMessageBuilder: (context, data) =>
              L10n.of(context).import_successful,
          child: ObserverBuilder<ConfigStore>(
            builder: (context, store) => ListTile(
              leading: store.lemmyImportState.isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const Icon(Icons.cloud_download),
              title: Text(L10n.of(context).import_settings),
              onTap: () async {
                await context.read<ConfigStore>().importLemmyUserSettings(
                      accountsStore.userDataFor(instanceHost, username)!.jwt,
                    );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Settings for managing accounts
class AccountsConfigPage extends HookWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  AccountsConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    removeInstanceDialog(String instanceHost) async {
      if (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(L10n.of(context).remove_instance_confirm),
              content: Text(L10n.of(context)
                  .remove_instance_confirm_explanation(instanceHost)),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(L10n.of(context).yes),
                ),
              ],
            ),
          ) ??
          false) {
        await accountsStore.removeInstance(instanceHost);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }
    }

    void accountActions(String instanceHost, String username) {
      showBottomModal(
        context: context,
        builder: (context) => _AccountOptions(
          instanceHost: instanceHost,
          username: username,
        ),
      );
    }

    void instanceActions(String instanceHost) {
      showBottomModal(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(L10n.of(context).remove_instance),
              onTap: () => removeInstanceDialog(instanceHost),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(L10n.of(context).accounts),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close, // TODO: change to + => x
        curve: Curves.bounceIn,
        tooltip: L10n.of(context).add_user_or_instance,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.person_add),
            label: L10n.of(context).add_user,
            onTap: () => Navigator.of(context)
                .push(AddAccountPage.route(accountsStore.instances.last)),
          ),
          SpeedDialChild(
            child: const Icon(Icons.dns),
            label: L10n.of(context).add_instance,
            onTap: () => Navigator.of(context).push(AddInstancePage.route()),
          ),
        ],
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(L10n.of(context).accounts_explanation),
          ),
          if (accountsStore.instances.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: FilledButton.icon(
                    onPressed: () =>
                        Navigator.of(context).push(AddInstancePage.route()),
                    icon: const Icon(Icons.add),
                    label: Text(L10n.of(context).add_instance),
                  ),
                ),
              ],
            ),
          for (final instance in accountsStore.instances) ...[
            const SizedBox(height: 40),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              onLongPress: () => instanceActions(instance),
              title: _SectionHeading(instance),
            ),
            for (final username in accountsStore.usernamesFor(instance)) ...[
              ListTile(
                trailing: username == accountsStore.defaultUsernameFor(instance)
                    ? Icon(
                        Icons.check_circle_outline,
                        color: theme.colorScheme.secondary,
                      )
                    : null,
                title: Text(username),
                onLongPress: () => accountActions(instance, username),
                onTap: () {
                  goTo(
                      context,
                      (_) => ManageAccountPage(
                            instanceHost: instance,
                            username: username,
                          ));
                },
              ),
            ],
            if (accountsStore.usernamesFor(instance).isEmpty)
              ListTile(
                leading: const Icon(Icons.add),
                title: Text(L10n.of(context).add_user),
                onTap: () {
                  Navigator.of(context).push(AddAccountPage.route(instance));
                },
              ),
          ]
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;

  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(text.toUpperCase(),
          style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.colorScheme.secondary)),
    );
  }
}

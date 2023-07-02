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
import '../../util/goto.dart';
import '../../util/observer_consumers.dart';
import '../../widgets/about_tile.dart';
import '../../widgets/bottom_modal.dart';
import '../../widgets/post/post.dart';
import '../../widgets/radio_picker.dart';
import '../manage_account.dart';
import 'add_account_page.dart';
import 'add_instance_page.dart';
import 'blocks/blocks.dart';
import 'mock_post.dart';

/// Page with a list of different settings sections
class SettingsPage extends HookWidget {
  const SettingsPage();

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
            title: const Text('General'),
            onTap: () {
              goTo(context, (_) => const GeneralConfigPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Accounts'),
            onTap: () {
              goTo(context, (_) => AccountsConfigPage());
            },
          ),
          if (hasAnyUsers)
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Blocks'),
              onTap: () {
                Navigator.of(context).push(BlocksPage.route());
              },
            ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Appearance'),
            onTap: () {
              goTo(context, (_) => const AppearanceConfigPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_agenda),
            title: const Text('Post Style'),
            onTap: () {
              goTo(context, (_) => const PostStyleConfigPage());
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
  const AppearanceConfigPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: Consumer<AppTheme>(
        builder: (context, state, child) {
          return ListView(
            children: [
              const _SectionHeading('Theme'),
              for (final theme in ThemeMode.values)
                RadioListTile<ThemeMode>(
                  value: theme,
                  title: Text(theme.name),
                  groupValue: state.theme,
                  onChanged: (selected) {
                    if (selected != null) {
                      state.switchtheme(selected);
                      if (selected == ThemeMode.dark) {
                        state.setPrimaryColor(
                            ThemeData.dark().colorScheme.secondary);
                      } else {
                        state.setPrimaryColor(
                            ThemeData.light().colorScheme.primary);
                      }
                    }
                  },
                ),
              SwitchListTile.adaptive(
                title: const Text('AMOLED dark mode'),
                value: state.amoled,
                onChanged: (checked) => state.switchamoled(),
              ),
              ListTile(
                title: Wrap(
                  spacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('Primary Color'),
                    IconButton(
                      onPressed: () {
                        if (state.theme == ThemeMode.dark) {
                          state.setPrimaryColor(
                              ThemeData.dark().colorScheme.secondary);
                        } else {
                          state.setPrimaryColor(
                              ThemeData.light().colorScheme.primary);
                        }
                      },
                      icon: const Icon(Icons.restart_alt_outlined),
                      tooltip: 'Reset to Default',
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
  const PostStyleConfigPage();

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
          appBar: AppBar(title: const Text('Post Style')),
          body: ObserverBuilder<ConfigStore>(
              builder: (context, store) => ListView(
                    children: [
                      const _SectionHeading('Post View'),
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
                        value: store.postRoundedCorners,
                        onChanged: (checked) {
                          store.postRoundedCorners = checked;
                        },
                      ),
                      SwitchListTile.adaptive(
                        title: Text(L10n.of(context).post_style_shadow),
                        value: store.postCardShadow,
                        onChanged: (checked) {
                          store.postCardShadow = checked;
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
                        title: const Text('Show Scores'),
                        value: store.showScores,
                        onChanged: (checked) {
                          store.showScores = checked;
                        },
                      ),
                      const SizedBox(height: 12),
                      const _SectionHeading('Font'),
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
                                TextButton(
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
                                TextButton(
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
                      const _SectionHeading('Preview'),
                      const SizedBox(height: 20),
                      IgnorePointer(
                          child: PostTile.fromPostView(PostView.fromJson(
                              decoder.convert(mockTextPostJson)))),
                      if (state.amoled) gradient,
                      SizedBox(height: store.compactPostView ? 2 : 10),
                      IgnorePointer(
                          child: PostTile.fromPostView(PostView.fromJson(
                              decoder.convert(mockMediaPost)))),
                      if (state.amoled) gradient,
                      SizedBox(height: store.compactPostView ? 2 : 10),
                      IgnorePointer(
                          child: PostTile.fromPostView(PostView.fromJson(
                              decoder.convert(mockLinkPost)))),
                    ],
                  )));
    });
  }
}

/// General settings
class GeneralConfigPage extends StatelessWidget {
  const GeneralConfigPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('General')),
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
                      TextButton(
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
                      TextButton(
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
                      TextButton(
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
                  title: 'Choose language',
                  groupValue: store.locale,
                  values: L10n.supportedLocales,
                  mapValueToString: (locale) => locale.languageName,
                  onChanged: (selected) {
                    store.locale = selected;
                  },
                  buttonBuilder: (context, displayValue, onPressed) =>
                      TextButton(
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
              title: const Text('Show EVERYTHING feed'),
              subtitle:
                  const Text('This will combine content from all instances, '
                      "even those you're not signed into, so you may "
                      "see posts you can't vote on or reply to."),
              value: store.showEverythingFeed,
              onChanged: (checked) {
                store.showEverythingFeed = checked;
              },
            ),
            SwitchListTile.adaptive(
              title: const Text('Use in-app browser'),
              value: store.useInAppBrowser,
              onChanged: (checked) {
                store.useInAppBrowser = checked;
              },
            ),
            const SizedBox(height: 12),
            const _SectionHeading('Other'),
            SwitchListTile.adaptive(
              title: const Text('Disable Animations'),
              value: store.disableAnimations,
              onChanged: (checked) {
                store.disableAnimations = checked;
              },
            ),
            SwitchListTile.adaptive(
              title: const Text('Hide NSFW'),
              subtitle: const Text('Images in NSFW posts will be hidden.'),
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
              title: const Text('Remove user?'),
              content: Text(
                  'Are you sure you want to remove $username@$instanceHost?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(L10n.of(context).yes),
                ),
              ],
            ),
          ) ??
          false) {
        await accountsStore.removeAccount(instanceHost, username);
        Navigator.of(context).pop();
      }
    }

    return Column(
      children: [
        if (accountsStore.defaultUsernameFor(instanceHost) != username)
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Set as default'),
            onTap: () {
              accountsStore.setDefaultAccountFor(instanceHost, username);
              Navigator.of(context).pop();
            },
          ),
        ListTile(
          leading: const Icon(Icons.delete),
          title: const Text('Remove account'),
          onTap: () => removeUserDialog(instanceHost, username),
        ),
        AsyncStoreListener(
          asyncStore: context.read<ConfigStore>().lemmyImportState,
          successMessageBuilder: (context, data) => 'Import successful',
          child: ObserverBuilder<ConfigStore>(
            builder: (context, store) => ListTile(
              leading: store.lemmyImportState.isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : const Icon(Icons.cloud_download),
              title: const Text('Import settings to Liftoff'),
              onTap: () async {
                await context.read<ConfigStore>().importLemmyUserSettings(
                      accountsStore.userDataFor(instanceHost, username)!.jwt,
                    );
                Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accountsStore = useAccountsStore();

    removeInstanceDialog(String instanceHost) async {
      if (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Remove instance?'),
              content: Text('Are you sure you want to remove $instanceHost?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(L10n.of(context).no),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(L10n.of(context).yes),
                ),
              ],
            ),
          ) ??
          false) {
        await accountsStore.removeInstance(instanceHost);
        Navigator.of(context).pop();
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
              title: const Text('Remove instance'),
              onTap: () => removeInstanceDialog(instanceHost),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close, // TODO: change to + => x
        curve: Curves.bounceIn,
        tooltip: 'Add account or instance',
        children: [
          SpeedDialChild(
            child: const Icon(Icons.person_add),
            label: 'Add account',
            onTap: () => Navigator.of(context)
                .push(AddAccountPage.route(accountsStore.instances.last)),
          ),
          SpeedDialChild(
            child: const Icon(Icons.dns),
            label: 'Add instance',
            onTap: () => Navigator.of(context).push(AddInstancePage.route()),
          ),
        ],
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          if (accountsStore.instances.isEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: TextButton.icon(
                    onPressed: () =>
                        Navigator.of(context).push(AddInstancePage.route()),
                    icon: const Icon(Icons.add),
                    label: const Text('Add instance'),
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
                title: const Text('Add account'),
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

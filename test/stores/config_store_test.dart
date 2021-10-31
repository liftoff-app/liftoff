import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemmur/stores/config_store.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lemmyUserSettings = LocalUserSettings(
  id: 1,
  personId: 1,
  showNsfw: true,
  theme: 'browser',
  defaultSortType: SortType.active,
  defaultListingType: PostListingType.local,
  lang: 'en',
  showAvatars: true,
  showScores: true,
  sendNotificationsToEmail: true,
  showReadPosts: true,
  showBotAccounts: true,
  showNewPostNotifs: true,
  instanceHost: '',
);

void main() {
  group('ConfigStore', () {
    late SharedPreferences prefs;
    late ConfigStore store;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    setUp(() async {
      store = ConfigStore.load(prefs);
      await prefs.clear();
    });

    test('Store defaults match json defaults', () {
      final store = ConfigStore();
      final loaded = ConfigStore.load(prefs);

      expect(store.theme, loaded.theme);
      expect(store.amoledDarkMode, loaded.amoledDarkMode);
      expect(store.locale, loaded.locale);
      expect(store.showAvatars, loaded.showAvatars);
      expect(store.showScores, loaded.showScores);
      expect(store.defaultSortType, loaded.defaultSortType);
      expect(store.defaultListingType, loaded.defaultListingType);
    });

    test('Changes are saved', () {
      store.amoledDarkMode = false;
      var loaded = ConfigStore.load(prefs);
      expect(loaded.amoledDarkMode, false);

      store.amoledDarkMode = true;
      loaded = ConfigStore.load(prefs);
      expect(loaded.amoledDarkMode, true);
    });

    test('Changes are not saved after disposing', () {
      store.amoledDarkMode = false;
      var loaded = ConfigStore.load(prefs);
      expect(loaded.amoledDarkMode, false);

      store
        ..dispose()
        ..amoledDarkMode = true;
      loaded = ConfigStore.load(prefs);
      expect(loaded.amoledDarkMode, false);
    });

    group('Copying LemmyUserSettings', () {
      test('works', () {
        store
          ..theme = ThemeMode.dark
          ..amoledDarkMode = false
          ..locale = const Locale('pl')
          ..showAvatars = false
          ..showScores = false
          ..defaultSortType = SortType.topYear
          ..defaultListingType = PostListingType.all
          ..copyLemmyUserSettings(_lemmyUserSettings);

        expect(store.theme, ThemeMode.system);
        expect(store.amoledDarkMode, false);
        expect(store.locale, const Locale('en'));
        expect(store.showAvatars, true);
        expect(store.showScores, true);
        expect(store.defaultSortType, SortType.active);
        expect(store.defaultListingType, PostListingType.local);
      });

      test('detects dark theme', () {
        store
          ..theme = ThemeMode.light
          ..copyLemmyUserSettings(_lemmyUserSettings.copyWith(theme: 'darkly'));

        expect(store.theme, ThemeMode.dark);
      });

      test('lang ignores unrecognized', () {
        store
          ..locale = const Locale('en')
          ..copyLemmyUserSettings(
              _lemmyUserSettings.copyWith(lang: 'qweqweqwe'));

        expect(store.locale, const Locale('en'));
      });

      test('detects browser theme', () {
        store
          ..theme = ThemeMode.light
          ..copyLemmyUserSettings(
              _lemmyUserSettings.copyWith(theme: 'browser'));

        expect(store.theme, ThemeMode.system);
      });
    });
  });
}

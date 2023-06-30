import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:liftoff/stores/config_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _lemmyUserSettings = LocalUserSettings(
  id: 1,
  personId: 1,
  showNsfw: true,
  theme: 'browser',
  defaultSortType: SortType.active,
  defaultListingType: PostListingType.local,
  interfaceLanguage: 'en',
  showAvatars: true,
  showScores: true,
  sendNotificationsToEmail: true,
  showReadPosts: true,
  showBotAccounts: true,
  showNewPostNotifs: true,
  instanceHost: '',
  emailVerified: true,
  acceptedApplication: true,
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

      expect(store.locale, loaded.locale);
      expect(store.showAvatars, loaded.showAvatars);
      expect(store.showScores, loaded.showScores);
      expect(store.defaultSortType, loaded.defaultSortType);
      expect(store.defaultListingType, loaded.defaultListingType);
    });

    test('Changes are saved', () {
      store.blurNsfw = false;
      var loaded = ConfigStore.load(prefs);
      expect(loaded.blurNsfw, false);

      store.blurNsfw = true;
      loaded = ConfigStore.load(prefs);
      expect(loaded.blurNsfw, true);
    });

    test('Changes are not saved after disposing', () {
      store.blurNsfw = false;
      var loaded = ConfigStore.load(prefs);
      expect(loaded.blurNsfw, false);

      store
        ..dispose()
        ..blurNsfw = true;
      loaded = ConfigStore.load(prefs);
      expect(loaded.blurNsfw, false);
    });

    group('Copying LemmyUserSettings', () {
      test('works', () {
        store
          ..blurNsfw = true
          ..locale = const Locale('pl')
          ..showAvatars = false
          ..showScores = false
          ..defaultSortType = SortType.topYear
          ..defaultListingType = PostListingType.all
          ..copyLemmyUserSettings(_lemmyUserSettings);

        expect(store.blurNsfw, true);
        expect(store.locale, const Locale('en'));
        expect(store.showAvatars, true);
        expect(store.showScores, true);
        expect(store.defaultSortType, SortType.active);
        expect(store.defaultListingType, PostListingType.local);
      });

      test('lang ignores unrecognized', () {
        store
          ..locale = const Locale('en')
          ..copyLemmyUserSettings(
              _lemmyUserSettings.copyWith(interfaceLanguage: 'qweqweqwe'));

        expect(store.locale, const Locale('en'));
      });
    });
  });
}

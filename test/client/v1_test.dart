import 'package:flutter_test/flutter_test.dart';
import 'package:lemmur/client/client.dart';

// these are mock exceptions
// should be removed as soon as the real one is implemented
class NotLoggedInException implements Exception {
  final String _message;

  NotLoggedInException(this._message);

  @override
  String toString() => _message;
}

void main() {
  group("lemmy API v1", () {
    final lemmy = LemmyAPI('dev.lemmy.ml').v1;

    group("getPosts", () {
      test("correctly fetches", () async {
        final res = await lemmy.getPosts(
            type: PostListingType.all, sort: SortType.active);
        expect(res.length, 10);
      });

      test("forbids illegal numbers", () async {
        expect(() async {
          await lemmy.getPosts(
              type: PostListingType.all, sort: SortType.active, page: 0);
        }, throwsA(isInstanceOf<AssertionError>()));

        expect(() async {
          await lemmy.getPosts(
              type: PostListingType.all, sort: SortType.active, limit: -1);
        }, throwsA(isInstanceOf<AssertionError>()));
      });
    });

    group("listCategories", () {
      test("correctly fetches", () async {
        await lemmy.listCategories();
      });
    });

    group("search", () {
      test("correctly fetches", () async {
        final res = await lemmy.search(
            type: SearchType.all, q: "asd", sort: SortType.active);

        expect(res.type, SortType.active.value);
      });

      test("forbids illegal numbers", () async {
        expect(() async {
          await lemmy.search(
              type: SearchType.all, q: "asd", sort: SortType.active, page: 0);
        }, throwsA(isInstanceOf<AssertionError>()));

        expect(() async {
          await lemmy.search(
              type: SearchType.all, q: "asd", sort: SortType.active, limit: -1);
        }, throwsA(isInstanceOf<AssertionError>()));
      });

      test("handles invalid tokens", () async {
        expect(() async {
          await lemmy.search(
            type: SearchType.all,
            q: "asd",
            sort: SortType.active,
            auth: "asd",
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });
  });
}

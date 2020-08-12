import 'package:flutter_test/flutter_test.dart';
import 'package:lemmur/client/client.dart';

// this is a mock exception
// should be removed as soon as the real one is implemented
class LemmyAPIException implements Exception {
  final String _message;

  LemmyAPIException(this._message);

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

      test("gracefully fails", () async {
        try {
          await lemmy.getPosts(
              type: PostListingType.all, sort: SortType.active, page: -1);
        } on LemmyAPIException catch (_) {
          return;
        }

        throw TestFailure("Did not catch the error");
      });
    });
  });
}

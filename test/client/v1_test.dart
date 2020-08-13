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

class UsernameTakenException implements Exception {
  final String _message;

  UsernameTakenException(this._message);

  @override
  String toString() => _message;
}

void main() {
  group('lemmy API v1', () {
    final lemmy = LemmyAPI('dev.lemmy.ml').v1;

    group('listCategories', () {
      test('correctly fetches', () async {
        await lemmy.listCategories();
      });
    });

    group('search', () {
      test('correctly fetches', () async {
        final res = await lemmy.search(
            type: SearchType.all, q: 'asd', sort: SortType.active);

        expect(res.type, SortType.active.value);
      });

      test('forbids illegal numbers', () async {
        expect(() async {
          await lemmy.search(
              type: SearchType.all, q: 'asd', sort: SortType.active, page: 0);
        }, throwsA(isInstanceOf<AssertionError>()));

        expect(() async {
          await lemmy.search(
              type: SearchType.all, q: 'asd', sort: SortType.active, limit: -1);
        }, throwsA(isInstanceOf<AssertionError>()));
      });

      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.search(
            type: SearchType.all,
            q: 'asd',
            sort: SortType.active,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('createComment', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.createComment(
            content: '123',
            postId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('editComment', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.editComment(
            content: '123',
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('deleteComment', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.deleteComment(
            deleted: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('removeComment', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.removeComment(
            removed: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('markCommentAsRead', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.markCommentAsRead(
            read: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('saveComment', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.saveComment(
            save: true,
            commentId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('createCommentLike', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.createCommentLike(
            score: Vote.up,
            commentId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('createPost', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.createPost(
            name: 'asd',
            nsfw: false,
            communityId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('getPost', () {
      test('correctly fetches', () async {
        await lemmy.getPost(id: 38936);
      });

      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.getPost(
            id: 1,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('getPosts', () {
      test('correctly fetches', () async {
        final res = await lemmy.getPosts(
            type: PostListingType.all, sort: SortType.active);
        expect(res.length, 10);
      });

      test('forbids illegal numbers', () async {
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

    group('createPostLike', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.createPostLike(
            postId: 1,
            score: Vote.up,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('editPost', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.editPost(
            name: 'asd',
            nsfw: false,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('deletePost', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.deletePost(
            deleted: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('removePost', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.removePost(
            removed: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('login', () {
      test('handles invalid credentials', () async {
        expect(() async {
          await lemmy.login(
            usernameOrEmail: '123',
            password: '123',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('register', () {
      // TODO(krawieck): the signature seems to be wrong, waiting for correction
      // test('handles already existing account', () async {
      //   expect(() async {
      //     await lemmy.register(
      //       usernameOrEmail: '123',
      //       password: '123',
      //     );
      //   }, throwsA(isInstanceOf<UsernameTakenException>()));
      // });
    });

    group('getCaptcha', () {
      test('correctly fetches', () async {
        await lemmy.getCaptcha();
      });
    });

    group('getUserDetails', () {
      test('correctly fetches', () async {
        await lemmy.getUserDetails(sort: SortType.active, username: 'krawieck');
      });

      test('forbids illegal numbers', () async {
        expect(() async {
          await lemmy.getUserDetails(sort: SortType.active, page: 0);
        }, throwsA(isInstanceOf<AssertionError>()));

        expect(() async {
          await lemmy.getUserDetails(sort: SortType.active, limit: -1);
        }, throwsA(isInstanceOf<AssertionError>()));
      });

      test('forbids both username and userId being passed at once', () async {
        expect(() async {
          await lemmy.getUserDetails(
            sort: SortType.active,
            username: 'asd',
            userId: 123,
          );
        }, throwsA(isInstanceOf<AssertionError>()));
      });

      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.getUserDetails(
            sort: SortType.active,
            auth: '123',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('saveUserSettings', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.saveUserSettings(
            showNsfw: true,
            theme: 'asd',
            defaultSortType: SortType.active,
            defaultListingType: PostListingType.all,
            auth: '123',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('getReplies', () {
      test('forbids illegal numbers', () async {
        expect(() async {
          await lemmy.getReplies(
            sort: SortType.active,
            unreadOnly: false,
            auth: 'asd',
            page: 0,
          );
        }, throwsA(isInstanceOf<AssertionError>()));

        expect(() async {
          await lemmy.getReplies(
            sort: SortType.active,
            unreadOnly: false,
            auth: 'asd',
            limit: -1,
          );
        }, throwsA(isInstanceOf<AssertionError>()));
      });

      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.getReplies(
            sort: SortType.active,
            unreadOnly: false,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('getUserMentions', () {
      // TODO(krawieck): the signature seems to be wrong, waiting for correction
      // test('forbids illegal numbers', () async {
      //   expect(() async {
      // await lemmy.getUserMentions(
      //   sort: SortType.active,
      //   unreadOnly: false,
      //   auth: 'asd',
      //   page: 0,
      // );
      //   }, throwsA(isInstanceOf<AssertionError>()));

      //   expect(() async {
      //     await lemmy.getUserMentions(
      //       sort: SortType.active,
      //       unreadOnly: false,
      //       auth: 'asd',
      //       limit: -1,
      //     );
      //   }, throwsA(isInstanceOf<AssertionError>()));
      // });

      // test('handles invalid tokens', () async {
      //   expect(() async {
      //     await lemmy.getUserMentions(
      //       sort: SortType.active,
      //       unreadOnly: false,
      //       auth: 'asd',
      //     );
      //   }, throwsA(isInstanceOf<NotLoggedInException>()));
      // });
    });

    group('markUserMentionAsRead', () {
      test('handles invalid credentials', () async {
        expect(() async {
          await lemmy.markUserMentionAsRead(
            userMentionId: 123,
            read: true,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('getPrivateMessages', () {
      test('forbids illegal numbers', () async {
        expect(() async {
          await lemmy.getPrivateMessages(
            unreadOnly: false,
            auth: 'asd',
            page: 0,
          );
        }, throwsA(isInstanceOf<AssertionError>()));

        expect(() async {
          await lemmy.getPrivateMessages(
            unreadOnly: false,
            auth: 'asd',
            limit: -1,
          );
        }, throwsA(isInstanceOf<AssertionError>()));
      });

      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.getPrivateMessages(
            unreadOnly: false,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('createPrivateMessage', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.createPrivateMessage(
            content: 'asd',
            recipientId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('editPrivateMessage', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.editPrivateMessage(
            content: 'asd',
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('deletePrivateMessage', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.deletePrivateMessage(
            deleted: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('markPrivateMessageAsRead', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.markPrivateMessageAsRead(
            read: true,
            editId: 123,
            auth: 'asd',
          );
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('markAllAsRead', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.markAllAsRead(auth: 'asd');
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });

    group('deleteAccount', () {
      test('handles invalid tokens', () async {
        expect(() async {
          await lemmy.deleteAccount(password: 'asd', auth: 'asd');
        }, throwsA(isInstanceOf<NotLoggedInException>()));
      });
    });
  });
}

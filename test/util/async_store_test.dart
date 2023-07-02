import 'package:flutter_test/flutter_test.dart';
import 'package:lemmy_api_client/v3.dart';
import 'package:liftoff/util/async_store.dart';

void main() {
  group('AsyncStore', () {
    const instanceHost = 'lemmy.world';
    const badInstanceHost = 'does.not.exist';

    test('runLemmy works properly all the way through', () async {
      final store = AsyncStore<FullPostView>();

      expect(store.asyncState, isA<AsyncStateInitial>());
      expect(store.isLoading, false);
      expect(store.errorTerm, null);

      final fut = store.runLemmy(instanceHost, const GetPost(id: 1));

      expect(store.asyncState, isA<AsyncStateLoading>());
      expect(store.isLoading, true);
      expect(store.errorTerm, null);

      final res = await fut;

      expect(store.asyncState, isA<AsyncStateData>());
      expect(store.isLoading, false);
      expect(store.errorTerm, null);
      expect(store.asyncState, AsyncState.data(res!));
    });

    test('fails properly 1', () async {
      final store = AsyncStore<FullPostView>();

      expect(store.asyncState, isA<AsyncStateInitial>());
      expect(store.isLoading, false);
      expect(store.errorTerm, null);

      final fut = store.runLemmy(instanceHost, const GetPost(id: 0));

      expect(store.asyncState, isA<AsyncStateLoading>());
      expect(store.isLoading, true);
      expect(store.errorTerm, null);

      await fut;

      expect(store.asyncState, isA<AsyncStateError>());
      expect(store.isLoading, false);
      expect(store.errorTerm, 'Record not found');
    });

    test('fails properly 2', () async {
      final store = AsyncStore<FullPostView>();

      expect(store.asyncState, isA<AsyncStateInitial>());
      expect(store.isLoading, false);
      expect(store.errorTerm, null);

      final fut = store.runLemmy(badInstanceHost, const GetPost(id: 0));

      expect(store.asyncState, isA<AsyncStateLoading>());
      expect(store.isLoading, true);
      expect(store.errorTerm, null);

      await fut;

      expect(store.asyncState, isA<AsyncStateError>());
      expect(store.isLoading, false);
      expect(store.errorTerm, 'network_error');
    });

    test('succeeds then fails on refresh, and then succeeds', () async {
      final store = AsyncStore<FullPostView>();

      final res = await store.runLemmy(instanceHost, const GetPost(id: 1));

      expect(store.asyncState, isA<AsyncStateData>());
      expect(store.errorTerm, null);

      expect(store.asyncState, AsyncState.data(res!));

      await store.runLemmy(
        badInstanceHost,
        const GetPost(id: 3711),
        refresh: true,
      );

      expect(store.asyncState, isA<AsyncStateData>());
      expect(store.errorTerm, 'network_error');
      expect(store.asyncState, AsyncState.data(res, 'network_error'));

      final res2 = await store.runLemmy(
        instanceHost,
        const GetPost(id: 1),
        refresh: true,
      );

      expect(store.asyncState, isA<AsyncStateData>());
      expect(store.errorTerm, null);
      expect(store.asyncState, AsyncState.data(res2!));
    });

    test('maps states correctly', () {
      final store = AsyncStore<int>();

      loading() => 'loading';
      data(data) => 'data';
      error(error) => 'error';

      expect(store.map(loading: loading, error: error, data: data), 'loading');

      store.asyncState = const AsyncState.loading();
      expect(store.map(loading: loading, error: error, data: data), 'loading');

      store.asyncState = const AsyncState.data(123);
      expect(store.map(loading: loading, error: error, data: data), 'data');

      store.asyncState = const AsyncState.data(123, 'error');
      expect(store.map(loading: loading, error: error, data: data), 'data');

      store.asyncState = const AsyncState.error('error');
      expect(store.map(loading: loading, error: error, data: data), 'error');
    });
  });
}

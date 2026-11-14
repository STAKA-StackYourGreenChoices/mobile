import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/models/user.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  const tokens = AuthTokens(accessToken: 'a1', refreshToken: 'r1');
  late InMemoryTokenStore store;
  late FakeHttpAdapter api;

  Future<ProviderContainer> start() async {
    final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
      ..httpClientAdapter = api;
    final container = ProviderContainer.test(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(dio, store),
        ),
      ],
    )..read(sessionControllerProvider);
    await pumpEventQueue();
    return container;
  }

  setUp(() => store = InMemoryTokenStore());

  test('no stored tokens: signed out without calling the API', () async {
    api = FakeHttpAdapter([]);
    final container = await start();

    expect(container.read(sessionControllerProvider), isA<SignedOut>());
    expect(api.requests, isEmpty);
  });

  test('stored tokens and a valid user: signed in', () async {
    store.tokens = tokens;
    api = FakeHttpAdapter([json(200, userJson(role: 'ADMIN'))]);
    final container = await start();

    final state = container.read(sessionControllerProvider);
    expect(state, isA<SignedIn>());
    expect((state as SignedIn).user.isAdmin, isTrue);
  });

  test('API unreachable at launch: keeps tokens and offers a retry', () async {
    store.tokens = tokens;
    api = FakeHttpAdapter([connectionError(), json(200, userJson())]);
    final container = await start();

    expect(
      container.read(sessionControllerProvider),
      isA<SessionUnreachable>(),
    );
    expect(store.tokens, tokens);

    await container.read(sessionControllerProvider.notifier).restore();
    expect(container.read(sessionControllerProvider), isA<SignedIn>());
  });

  test('API refuses the session: signed out as expired, tokens gone', () async {
    store.tokens = tokens;
    api = FakeHttpAdapter([json(401, {})]);
    final container = await start();

    final state = container.read(sessionControllerProvider);
    expect(state, isA<SignedOut>());
    expect((state as SignedOut).sessionExpired, isTrue);
    expect(store.tokens, isNull);
  });

  test('signIn stores the tokens and exposes the user', () async {
    api = FakeHttpAdapter([]);
    final container = await start();
    const user = User(
      id: 'u1',
      email: 'ada@example.com',
      name: 'Ada Lovelace',
      role: Role.user,
      emailVerified: false,
    );

    await container
        .read(sessionControllerProvider.notifier)
        .signIn(tokens: tokens, user: user);

    expect(store.tokens, tokens);
    expect((container.read(sessionControllerProvider) as SignedIn).user, user);
  });

  test(
    'signOut revokes the refresh token and signs out even if that fails',
    () async {
      store.tokens = tokens;
      api = FakeHttpAdapter([json(200, userJson()), connectionError()]);
      final container = await start();

      await container.read(sessionControllerProvider.notifier).signOut();

      expect(api.requests.last.path, '/auth/logout');
      expect(api.requests.last.data, {'refreshToken': 'r1'});
      expect(store.tokens, isNull);
      expect(container.read(sessionControllerProvider), isA<SignedOut>());
    },
  );
}

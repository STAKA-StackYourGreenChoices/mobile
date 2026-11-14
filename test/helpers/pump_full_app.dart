import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/app/app.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/core/auth/session_repository.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/auth/domain/repositories/auth_repository.dart';

import 'auth_fakes.dart';
import 'fake_http_adapter.dart';

/// Pumps the whole app with a fake API for the session (`replies`), an
/// in-memory token store, and optionally a scripted [AuthRepository].
Future<InMemoryTokenStore> pumpApp(
  WidgetTester tester, {
  AuthTokens? tokens,
  List<FakeReply> replies = const [],
  AuthRepository? auth,
}) async {
  final store = InMemoryTokenStore(tokens);
  final dio = Dio(BaseOptions(baseUrl: 'http://api.test'))
    ..httpClientAdapter = FakeHttpAdapter(replies);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionRepositoryProvider.overrideWithValue(
          SessionRepository(dio, store),
        ),
        if (auth != null) authRepositoryProvider.overrideWithValue(auth),
      ],
      child: const App(),
    ),
  );
  await tester.pumpAndSettle();
  return store;
}

/// Answers login/register from a script and records what it was asked.
class FakeAuthRepository implements AuthRepository {
  new(List<Result<AuthSession>> results) : _results = [...results];

  final List<Result<AuthSession>> _results;
  final List<Map<String, String>> calls = [];

  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) async {
    calls.add({'email': email, 'password': password});
    return _results.removeAt(0);
  }

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    calls.add({'name': name, 'email': email, 'password': password});
    return _results.removeAt(0);
  }
}

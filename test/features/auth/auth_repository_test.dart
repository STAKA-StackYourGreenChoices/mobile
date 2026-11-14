import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter api;

  AuthRepositoryImpl repository() => AuthRepositoryImpl(
    AuthRemoteDataSource(
      Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = api,
    ),
  );

  test(
    'login sends exactly email + password, publicly, trimmed email',
    () async {
      api = FakeHttpAdapter([json(201, authJson(access: 'a1'))]);

      final result = await repository().login(
        email: '  ada@example.com ',
        password: ' secret with spaces ',
      );

      final request = api.requests.single;
      expect(request.path, '/auth/login');
      expect(request.data, {
        'email': 'ada@example.com',
        'password': ' secret with spaces ',
      });
      expect(request.extra[AuthInterceptor.publicKey], isTrue);
      final session = (result as Ok<AuthSession>).value;
      expect(session.tokens.accessToken, 'a1');
      expect(session.user.role, Role.user);
    },
  );

  test('wrong credentials come back as UnauthorizedFailure', () async {
    api = FakeHttpAdapter([
      json(401, {'message': 'Invalid credentials'}),
    ]);

    final result = await repository().login(email: 'a@x.io', password: 'x');

    expect((result as Err<AuthSession>).failure, isA<UnauthorizedFailure>());
  });

  test(
    'register sends exactly name, email, password (API rejects extras)',
    () async {
      api = FakeHttpAdapter([json(201, authJson(access: 'a1'))]);

      await repository().register(
        name: ' Ada Lovelace ',
        email: 'ada@example.com',
        password: 'correct horse',
      );

      expect(api.requests.single.path, '/auth/register');
      expect(api.requests.single.data, {
        'name': 'Ada Lovelace',
        'email': 'ada@example.com',
        'password': 'correct horse',
      });
    },
  );

  test('a taken email comes back as ConflictFailure', () async {
    api = FakeHttpAdapter([
      json(409, {'message': 'Email already registered'}),
    ]);

    final result = await repository().register(
      name: 'Ada',
      email: 'ada@example.com',
      password: 'correct horse',
    );

    expect((result as Err<AuthSession>).failure, isA<ConflictFailure>());
  });
}

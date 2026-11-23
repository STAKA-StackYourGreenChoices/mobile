import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/account/data/datasources/account_remote_data_source.dart';
import 'package:staka/features/account/data/repositories/account_repository_impl.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter api;

  AccountRepositoryImpl repository() => AccountRepositoryImpl(
    AccountRemoteDataSource(
      Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = api,
    ),
  );

  test('a phone code goes to /me/phone, signed in', () async {
    api = FakeHttpAdapter([
      json(202, {
        'challengeId': 'c1',
        'expiresInSeconds': 300,
        'resendInSeconds': 30,
      }),
    ]);

    final result = await repository().requestPhoneCode(phone: '+919876543210');

    final request = api.requests.single;
    expect(request.method, 'POST');
    expect(request.path, '/me/phone');
    expect(request.data, {'phone': '+919876543210'});
    expect(request.extra[AuthInterceptor.publicKey], isNot(true));
    final challenge = (result as Ok<OtpChallenge>).value;
    expect(challenge.id, 'c1');
    expect(challenge.phone, '+919876543210');
  });

  test('a 409 means the number is on another account', () async {
    api = FakeHttpAdapter([
      json(409, {'message': 'Phone number already in use'}),
    ]);

    final result = await repository().requestPhoneCode(phone: '+919876543210');

    expect((result as Err).failure, isA<ConflictFailure>());
  });

  test('the code check returns the user; a 401 is not retried', () async {
    api = FakeHttpAdapter([
      json(200, {
        ...userJson(),
        'phone': '+919876543210',
        'phoneVerified': true,
      }),
    ]);

    final result = await repository().verifyPhone(
      challengeId: 'c1',
      code: '123456',
    );

    final request = api.requests.single;
    expect(request.path, '/me/phone/verify');
    expect(request.data, {'challengeId': 'c1', 'code': '123456'});
    expect(request.extra[AuthInterceptor.no401RetryKey], isTrue);
    final user = (result as Ok<User>).value;
    expect(user.phone, '+919876543210');
    expect(user.phoneVerified, isTrue);
  });

  test('remove, add email (trimmed), set password (as typed)', () async {
    api = FakeHttpAdapter([json(204, null), json(202, null), json(204, null)]);

    expect(await repository().removePhone(), isA<Ok<void>>());
    expect(
      await repository().addEmail(email: ' ada@example.com '),
      isA<Ok<void>>(),
    );
    expect(
      await repository().setPassword(newPassword: ' with spaces '),
      isA<Ok<void>>(),
    );

    final [remove, email, password] = api.requests;
    expect((remove.method, remove.path), ('DELETE', '/me/phone'));
    expect((email.method, email.path), ('POST', '/me/email'));
    expect(email.data, {'email': 'ada@example.com'});
    expect((password.method, password.path), ('POST', '/me/password'));
    expect(password.data, {'newPassword': ' with spaces '});
  });

  test('export returns the API file byte for byte', () async {
    api = FakeHttpAdapter([
      json(200, {
        'profile': {'name': 'Ada Lovelace'},
        'cards': <Object?>[],
      }),
    ]);

    final result = await repository().exportData();

    expect(api.requests.single.method, 'GET');
    expect(api.requests.single.path, '/me/export');
    expect(
      utf8.decode((result as Ok<Uint8List>).value),
      '{"profile":{"name":"Ada Lovelace"},"cards":[]}',
    );
  });

  test('delete sends the password or the code; a 401 is not retried', () async {
    api = FakeHttpAdapter([
      json(401, {'message': 'Invalid password'}),
      json(204, null),
    ]);

    final wrong = await repository().deleteWithPassword(password: ' pw ');
    final deleted = await repository().deleteWithCode(
      challengeId: 'c1',
      code: '123456',
    );

    expect((wrong as Err).failure, isA<UnauthorizedFailure>());
    expect(deleted, isA<Ok<void>>());
    final [byPassword, byCode] = api.requests;
    expect((byPassword.method, byPassword.path), ('DELETE', '/me'));
    expect(byPassword.data, {'password': ' pw '});
    expect(byPassword.extra[AuthInterceptor.no401RetryKey], isTrue);
    expect(byCode.data, {'challengeId': 'c1', 'code': '123456'});
  });
}

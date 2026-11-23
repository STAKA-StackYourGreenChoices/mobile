import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';
import 'package:staka/features/auth/domain/models/otp_verification.dart';

import '../../helpers/auth_fakes.dart';
import '../../helpers/fake_http_adapter.dart';

void main() {
  late FakeHttpAdapter api;

  AuthRepositoryImpl repository() => AuthRepositoryImpl(
    AuthRemoteDataSource(
      Dio(BaseOptions(baseUrl: 'http://api.test'))..httpClientAdapter = api,
    ),
  );

  Map<String, Object?> phoneUserJson() => {
    ...userJson(),
    'email': null,
    'emailVerified': false,
    'phone': '+919876543210',
    'phoneVerified': true,
    'hasPassword': false,
  };

  test('request sends the number publicly and reads the challenge', () async {
    api = FakeHttpAdapter([
      json(202, {
        'challengeId': 'c1',
        'expiresInSeconds': 300,
        'resendInSeconds': 30,
      }),
    ]);

    final result = await repository().requestOtp(phone: '+919876543210');

    final request = api.requests.single;
    expect(request.path, '/auth/otp/request');
    expect(request.data, {'phone': '+919876543210'});
    expect(request.extra[AuthInterceptor.publicKey], isTrue);
    final challenge = (result as Ok<OtpChallenge>).value;
    expect(challenge.id, 'c1');
    expect(challenge.phone, '+919876543210');
    expect(challenge.expiresIn, const Duration(minutes: 5));
    expect(challenge.resendIn, const Duration(seconds: 30));
  });

  test('a right code for a known number signs in', () async {
    api = FakeHttpAdapter([
      json(200, {
        'result': 'SIGNED_IN',
        'accessToken': 'a1',
        'refreshToken': 'r1',
        'user': phoneUserJson(),
        'isNewUser': false,
      }),
    ]);

    final result = await repository().verifyOtp(
      challengeId: 'c1',
      code: '123456',
    );

    expect(api.requests.single.path, '/auth/otp/verify');
    expect(api.requests.single.data, {'challengeId': 'c1', 'code': '123456'});
    expect(api.requests.single.extra[AuthInterceptor.publicKey], isTrue);
    final signedIn = (result as Ok<OtpVerification>).value as OtpSignedIn;
    expect(signedIn.isNewUser, isFalse);
    expect(signedIn.session.tokens.accessToken, 'a1');
    expect(signedIn.session.user.email, isNull);
    expect(signedIn.session.user.phone, '+919876543210');
    expect(signedIn.session.user.hasPassword, isFalse);
  });

  test('a new number asks for a name; the name goes trimmed', () async {
    api = FakeHttpAdapter([
      json(200, {'result': 'NAME_REQUIRED'}),
      json(200, {
        'result': 'SIGNED_IN',
        'accessToken': 'a1',
        'refreshToken': 'r1',
        'user': phoneUserJson(),
        'isNewUser': true,
      }),
    ]);

    final first = await repository().verifyOtp(
      challengeId: 'c1',
      code: '123456',
    );
    final second = await repository().verifyOtp(
      challengeId: 'c1',
      code: '123456',
      name: '  Ada Lovelace ',
    );

    expect((first as Ok<OtpVerification>).value, isA<OtpNameRequired>());
    expect(api.requests.last.data, {
      'challengeId': 'c1',
      'code': '123456',
      'name': 'Ada Lovelace',
    });
    final signedIn = (second as Ok<OtpVerification>).value as OtpSignedIn;
    expect(signedIn.isNewUser, isTrue);
  });

  test('wrong code is a 401; expired is a 410 bad request', () async {
    api = FakeHttpAdapter([
      json(401, {'message': 'Invalid code'}),
      json(410, {'message': 'Code expired'}),
    ]);

    final wrong = await repository().verifyOtp(challengeId: 'c1', code: '1');
    final expired = await repository().verifyOtp(challengeId: 'c1', code: '1');

    expect((wrong as Err).failure, isA<UnauthorizedFailure>());
    expect(
      (expired as Err).failure,
      isA<BadRequestFailure>().having((f) => f.statusCode, 'status', 410),
    );
  });
}

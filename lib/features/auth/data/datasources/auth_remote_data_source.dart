import 'package:dio/dio.dart';

import 'package:staka/core/api_models/auth_response_dto.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/dtos/otp_dtos.dart';

/// `/auth/login`, `/auth/register`, `/auth/forgot-password` (public: no
/// token, and a 401 never triggers a refresh) and `/auth/change-password`
/// (signed in). The API rejects unknown fields, so the bodies carry exactly
/// what it expects.
class AuthRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) => _post('/auth/login', {'email': email, 'password': password});

  Future<AuthResponseDto> register({
    required String name,
    required String email,
    required String password,
  }) => _post('/auth/register', {
    'name': name,
    'email': email,
    'password': password,
  });

  Future<void> requestPasswordReset({required String email}) => _dio.post<void>(
    '/auth/forgot-password',
    data: {'email': email},
    options: publicRequest(),
  );

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _dio.post<void>(
    '/auth/change-password',
    data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    options: passwordCheckRequest(),
  );

  Future<OtpChallengeDto> requestOtp({required String phone}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/otp/request',
      data: {'phone': phone},
      options: publicRequest(),
    );
    return OtpChallengeDto.fromJson(response.data!);
  }

  /// Public: a 401 here is a wrong code, never an expired session.
  Future<OtpVerifyDto> verifyOtp({
    required String challengeId,
    required String code,
    String? name,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/otp/verify',
      data: {'challengeId': challengeId, 'code': code, 'name': ?name},
      options: publicRequest(),
    );
    return OtpVerifyDto.fromJson(response.data!);
  }

  Future<AuthResponseDto> _post(String path, Map<String, String> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: publicRequest(),
    );
    return AuthResponseDto.fromJson(response.data!);
  }
}

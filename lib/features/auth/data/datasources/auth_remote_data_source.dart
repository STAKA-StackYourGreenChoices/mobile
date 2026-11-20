import 'package:dio/dio.dart';

import 'package:staka/core/api_models/auth_response_dto.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';

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

  Future<AuthResponseDto> _post(String path, Map<String, String> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: publicRequest(),
    );
    return AuthResponseDto.fromJson(response.data!);
  }
}

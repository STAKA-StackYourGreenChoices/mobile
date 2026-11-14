import 'package:dio/dio.dart';

import 'package:staka/core/api_models/auth_response_dto.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';

/// `POST /auth/login` and `POST /auth/register`. Both are public: they send
/// no token and a 401 here never triggers a refresh. The API rejects
/// unknown fields, so the bodies carry exactly what it expects.
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

  Future<AuthResponseDto> _post(String path, Map<String, String> body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      options: publicRequest(),
    );
    return AuthResponseDto.fromJson(response.data!);
  }
}

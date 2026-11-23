import 'package:dio/dio.dart';

import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/dtos/otp_dtos.dart';

/// `/me/phone`, `/me/phone/verify`, `/me/email`, `/me/password` (API plan
/// V2-1). All signed in. The API rejects unknown fields, so the bodies carry
/// exactly what it expects.
class AccountRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<OtpChallengeDto> requestPhoneCode({required String phone}) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/me/phone',
      data: {'phone': phone},
    );
    return OtpChallengeDto.fromJson(response.data!);
  }

  /// A 401 here is a wrong code, not an expired session: returned as is.
  Future<UserDto> verifyPhone({
    required String challengeId,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/me/phone/verify',
      data: {'challengeId': challengeId, 'code': code},
      options: passwordCheckRequest(),
    );
    return UserDto.fromJson(response.data!);
  }

  Future<void> removePhone() => _dio.delete<void>('/me/phone');

  Future<void> addEmail({required String email}) =>
      _dio.post<void>('/me/email', data: {'email': email});

  Future<void> setPassword({required String newPassword}) =>
      _dio.post<void>('/me/password', data: {'newPassword': newPassword});
}

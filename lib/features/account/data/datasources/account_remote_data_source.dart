import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/network/interceptors/auth_interceptor.dart';
import 'package:staka/features/auth/data/dtos/otp_dtos.dart';

/// `/me/phone`, `/me/phone/verify`, `/me/email`, `/me/password` (API plan
/// V2-1), `/me/export` and `DELETE /me` (V2-10). All signed in. The API rejects unknown fields, so the bodies carry
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

  /// The bytes as sent, so the saved file is exactly the API's JSON.
  Future<Uint8List> exportData() async {
    final response = await _dio.get<List<int>>(
      '/me/export',
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  /// [confirmation] is `{password}` or `{challengeId, code}`. A 401 here is
  /// a wrong password or code, not an expired session: returned as is.
  Future<void> deleteAccount(Map<String, String> confirmation) => _dio
      .delete<void>('/me', data: confirmation, options: passwordCheckRequest());
}

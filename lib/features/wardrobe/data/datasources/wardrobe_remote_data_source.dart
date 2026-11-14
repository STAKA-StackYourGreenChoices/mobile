import 'package:dio/dio.dart';

import 'package:staka/core/api_models/digital_card_dto.dart';

/// `GET /digital-cards/mine` and `POST /auth/resend-verification`.
class WardrobeRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<List<DigitalCardDto>> fetchMyCards() async {
    final response = await _dio.get<List<dynamic>>('/digital-cards/mine');
    return [
      for (final item in response.data!)
        DigitalCardDto.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// The API's message: "Verification email sent" or "Email is already
  /// verified".
  Future<String?> resendVerification() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/resend-verification',
    );
    return response.data?['message'] as String?;
  }
}

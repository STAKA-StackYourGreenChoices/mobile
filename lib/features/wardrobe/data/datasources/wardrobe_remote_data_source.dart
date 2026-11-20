import 'package:dio/dio.dart';

/// `POST /auth/resend-verification`. The tags themselves come from the
/// shared `CardsApi`.
class WardrobeRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  /// The API's message: "Verification email sent" or "Email is already
  /// verified".
  Future<String?> resendVerification() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/resend-verification',
    );
    return response.data?['message'] as String?;
  }
}

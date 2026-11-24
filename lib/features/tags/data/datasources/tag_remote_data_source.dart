import 'package:dio/dio.dart';
import 'package:staka/core/api_models/digital_card_dto.dart';
import 'package:staka/core/api_models/ownership_dto.dart';
import 'package:staka/features/tags/domain/models/card_stats.dart';
import 'package:staka/features/tags/domain/models/picked_receipt.dart';

/// `GET /digital-cards/:id` and the ownership claims under it.
class TagRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  Future<DigitalCardDto> fetchTag(String cardId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/digital-cards/${Uri.encodeComponent(cardId)}',
    );
    return DigitalCardDto.fromJson(response.data!);
  }

  /// `PATCH /digital-cards/:id` (V2-3): shown on the public wardrobe or
  /// not.
  Future<DigitalCardDto> setShowInWardrobe(
    String cardId, {
    required bool show,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '/digital-cards/${Uri.encodeComponent(cardId)}',
      data: {'showInWardrobe': show},
    );
    return DigitalCardDto.fromJson(response.data!);
  }

  /// `GET /me/cards/:id/stats` (V2-5).
  Future<CardStats> fetchStats(String cardId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/me/cards/${Uri.encodeComponent(cardId)}/stats',
    );
    return CardStats.fromJson(response.data!);
  }

  Future<OwnershipDto> matchOrder(String cardId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/digital-cards/${Uri.encodeComponent(cardId)}/ownership/order-match',
    );
    return OwnershipDto.fromJson(response.data!);
  }

  /// Multipart with the file in the `file` field, as the API expects. The
  /// API checks the real type from the bytes, not the name.
  Future<OwnershipDto> uploadReceipt(
    String cardId,
    PickedReceipt receipt,
  ) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(receipt.bytes, filename: receipt.name),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '/digital-cards/${Uri.encodeComponent(cardId)}/ownership/receipt',
      data: form,
    );
    return OwnershipDto.fromJson(response.data!);
  }

  /// Asks STAKA to look again at the brand's rejection. The answer (the
  /// new dispute) isn't read: the app marks the request open itself.
  Future<void> askToLookAgain(String cardId, String message) async {
    await _dio.post<void>(
      '/digital-cards/${Uri.encodeComponent(cardId)}/ownership/dispute',
      data: {'message': message},
    );
  }
}

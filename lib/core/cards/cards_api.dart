import 'package:dio/dio.dart';

import 'package:staka/core/api_models/digital_card_dto.dart';

/// Tag (`/digital-cards`) calls used by more than one feature: the wardrobe
/// lists them, the product screen checks ownership and adds one.
class CardsApi {
  const new(this._dio);

  final Dio _dio;

  /// `GET /digital-cards/mine`: the signed-in shopper's tags, newest first.
  Future<List<DigitalCardDto>> fetchMine() async {
    final response = await _dio.get<List<dynamic>>('/digital-cards/mine');
    return [
      for (final item in response.data!)
        DigitalCardDto.fromJson(item as Map<String, dynamic>),
    ];
  }

  /// `POST /digital-cards`: creates the tag, or returns the one the shopper
  /// already has for this product (200 instead of 201).
  Future<DigitalCardDto> create(String gtin) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/digital-cards',
      data: {'gtin': gtin},
    );
    return DigitalCardDto.fromJson(response.data!);
  }
}

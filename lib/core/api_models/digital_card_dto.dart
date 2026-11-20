import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/ownership_dto.dart';
import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/core/api_models/share_link_dto.dart';

part 'digital_card_dto.g.dart';

/// Wire format of a tag (`DigitalCardDto` in the API).
@JsonSerializable(createToJson: false)
class DigitalCardDto {
  const new({
    required this.id,
    required this.createdAt,
    required this.user,
    required this.product,
    required this.ownership,
    this.share,
  });

  factory fromJson(Map<String, dynamic> json) => _$DigitalCardDtoFromJson(json);

  final String id;
  final DateTime createdAt;
  final CardUserDto user;
  final ProductDto product;
  final OwnershipDto ownership;
  final ShareLinkDto? share;
}

/// Only what the API shows on a tag: never email or contact details.
@JsonSerializable(createToJson: false)
class CardUserDto {
  const new({required this.id, required this.name});

  factory fromJson(Map<String, dynamic> json) => _$CardUserDtoFromJson(json);

  final String id;
  final String name;
}

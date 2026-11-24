import 'package:json_annotation/json_annotation.dart';

import 'package:staka/core/api_models/ownership_dto.dart';
import 'package:staka/core/api_models/product_dto.dart';
import 'package:staka/core/api_models/product_variant_dto.dart';
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
    this.variant,
    this.variantId,
    this.showInWardrobe,
  });

  factory fromJson(Map<String, dynamic> json) => _$DigitalCardDtoFromJson(json);

  final String id;
  final DateTime createdAt;
  final CardUserDto user;
  final ProductDto product;
  final OwnershipDto ownership;
  final ShareLinkDto? share;

  /// The scanned size/colour (V2-2): the object if sent, else its id
  /// (looked up in the product's variants).
  final ProductVariantDto? variant;
  final String? variantId;

  /// V2-3; absent from an older API means shown.
  final bool? showInWardrobe;
}

/// Only what the API shows on a tag: never email or contact details.
@JsonSerializable(createToJson: false)
class CardUserDto {
  const new({required this.id, required this.name});

  factory fromJson(Map<String, dynamic> json) => _$CardUserDtoFromJson(json);

  final String id;
  final String name;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalCardDto _$DigitalCardDtoFromJson(Map<String, dynamic> json) =>
    DigitalCardDto(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      user: CardUserDto.fromJson(json['user'] as Map<String, dynamic>),
      product: ProductDto.fromJson(json['product'] as Map<String, dynamic>),
      ownership: OwnershipDto.fromJson(
        json['ownership'] as Map<String, dynamic>,
      ),
      share: json['share'] == null
          ? null
          : ShareLinkDto.fromJson(json['share'] as Map<String, dynamic>),
    );

CardUserDto _$CardUserDtoFromJson(Map<String, dynamic> json) =>
    CardUserDto(id: json['id'] as String, name: json['name'] as String);

import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:staka/features/brand_apply/domain/models/brand_application.dart';

part 'review_brand.freezed.dart';

/// A brand as a STAKA admin reviews it (V2-12): its application, how many
/// people run it and whether it sent a business document.
@freezed
abstract class ReviewBrand with _$ReviewBrand {
  const factory({
    required BrandApplication application,
    int? memberCount,
    @Default(false) bool hasDocument,
    DateTime? reviewedAt,
  }) = _ReviewBrand;

  const new _();

  String get id => application.id;
  String get name => application.name;
  BrandApplicationStatus get status => application.status;
}

/// The private business document a brand sent with its application.
@immutable
class BrandDocument {
  const new({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;

  bool get isPdf => mimeType == 'application/pdf';
}

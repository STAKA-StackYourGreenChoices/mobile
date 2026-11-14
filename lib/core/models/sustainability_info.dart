import 'package:freezed_annotation/freezed_annotation.dart';

part 'sustainability_info.freezed.dart';

/// A product's footprint figures. [isVerified] figures carry the
/// certifier's name; brand-stated ones must always look different (web
/// DESIGN.md principle 3).
@freezed
abstract class SustainabilityInfo with _$SustainabilityInfo {
  const factory({
    required int carbonScoreGrams,
    required int recyclabilityPercent,
    required bool isVerified,
    DateTime? verifiedAt,
    String? certifierName,
  }) = _SustainabilityInfo;
}

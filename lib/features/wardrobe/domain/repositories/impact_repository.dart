import 'package:staka/core/error/result.dart';
import 'package:staka/features/wardrobe/domain/models/impact.dart';

/// The shopper's impact summary and activity timeline (V2-5).
abstract interface class ImpactRepository {
  Future<Result<Impact>> fetchImpact();

  /// [page] starts at 1.
  Future<Result<ActivityPage>> fetchActivity(int page);
}

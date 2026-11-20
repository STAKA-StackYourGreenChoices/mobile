import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/brand_summary.dart';

/// The brands page's four states (guide §4.3).
sealed class AdminBrandsState {
  const new();
}

final class BrandsLoading extends AdminBrandsState {
  const new();
}

final class BrandsEmpty extends AdminBrandsState {
  const new();
}

final class BrandsLoaded extends AdminBrandsState {
  const new(this.brands, {this.refreshFailure});

  final List<BrandSummary> brands;

  /// Pull-to-refresh failed: the list stays and a snackbar says why.
  final Failure? refreshFailure;
}

final class BrandsFailed extends AdminBrandsState {
  const new(this.failure);

  final Failure failure;
}

import 'package:staka/core/error/failure.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';

/// The "Bring your brand to STAKA" screen: loading, the person's
/// applications (none = the intro), or why they couldn't load.
sealed class BrandApplicationsState {
  const new();
}

final class ApplicationsLoading extends BrandApplicationsState {
  const new();
}

final class ApplicationsLoaded extends BrandApplicationsState {
  const new(this.applications, {this.refreshFailure});

  /// Newest first. Empty: the person hasn't applied yet.
  final List<BrandApplication> applications;

  /// Pull-to-refresh failed: the list stays and a snackbar says why.
  final Failure? refreshFailure;
}

final class ApplicationsFailed extends BrandApplicationsState {
  const new(this.failure);

  final Failure failure;
}

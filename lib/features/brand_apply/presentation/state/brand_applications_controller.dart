import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/brand_apply/data/repositories/brand_application_repository_impl.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_state.dart';

part 'brand_applications_controller.g.dart';

/// The signed-in person's brand applications (`GET /me/brand-applications`).
@riverpod
class BrandApplicationsController extends _$BrandApplicationsController {
  @override
  BrandApplicationsState build() {
    unawaited(Future.microtask(_load));
    return const ApplicationsLoading();
  }

  Future<void> retry() async {
    state = const ApplicationsLoading();
    await _load();
  }

  /// Pull to refresh (an admin may have decided): the list stays while it
  /// reloads.
  Future<void> refresh() => _load(keepShowing: true);

  /// An application the form just sent: shown first, replacing its old
  /// copy, without asking the API again.
  void saved(BrandApplication application) {
    final others = switch (state) {
      ApplicationsLoaded(:final applications) => [
        for (final other in applications)
          if (other.id != application.id) other,
      ],
      _ => const <BrandApplication>[],
    };
    state = ApplicationsLoaded([application, ...others]);
  }

  Future<void> _load({bool keepShowing = false}) async {
    final result = await ref
        .read(brandApplicationRepositoryProvider)
        .fetchMine();
    if (!ref.mounted) return;
    state = switch ((result, state)) {
      (Ok(:final value), _) => ApplicationsLoaded(value),
      (Err(:final failure), ApplicationsLoaded(:final applications))
          when keepShowing =>
        ApplicationsLoaded(applications, refreshFailure: failure),
      (Err(:final failure), _) => ApplicationsFailed(failure),
    };
  }
}

/// The brands STAKA already lists, for "My brand is already on STAKA".
/// Loading while the future runs; a failed `Result` shows a retry.
@riverpod
Future<Result<List<BrandSummary>>> listedBrands(Ref ref) =>
    ref.read(brandApplicationRepositoryProvider).fetchListedBrands();

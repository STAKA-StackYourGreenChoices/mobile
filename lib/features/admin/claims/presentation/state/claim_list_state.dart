import 'package:staka/core/error/failure.dart';
import 'package:staka/features/admin/claims/domain/models/claim.dart';

/// One claim tab's four states (guide §4.3).
sealed class ClaimListState {
  const new();
}

final class ClaimListLoading extends ClaimListState {
  const new();
}

final class ClaimListEmpty extends ClaimListState {
  const new();
}

final class ClaimListLoaded extends ClaimListState {
  const new({
    required this.items,
    required this.total,
    required this.loadedPages,
    this.isLoadingMore = false,
    this.loadMoreFailure,
  });

  final List<Claim> items;
  final int total;
  final int loadedPages;
  final bool isLoadingMore;

  /// The next page failed; the list stays and offers to try again.
  final Failure? loadMoreFailure;

  bool get hasMore => items.length < total;

  ClaimListLoaded copy({
    bool isLoadingMore = false,
    Failure? loadMoreFailure,
  }) => ClaimListLoaded(
    items: items,
    total: total,
    loadedPages: loadedPages,
    isLoadingMore: isLoadingMore,
    loadMoreFailure: loadMoreFailure,
  );
}

final class ClaimListFailed extends ClaimListState {
  const new(this.failure);

  final Failure failure;
}

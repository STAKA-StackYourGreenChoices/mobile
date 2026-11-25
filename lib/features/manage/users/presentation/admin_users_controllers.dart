import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/rewards/points.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/users/data/admin_users_repository.dart';

part 'admin_users_controllers.g.dart';

sealed class UserSearchState {
  const new();
}

final class UserSearchIdle extends UserSearchState {
  const new();
}

final class UserSearchLoading extends UserSearchState {
  const new(this.query);

  final String query;
}

final class UserSearchDone extends UserSearchState {
  const new(this.query, this.page);

  final String query;
  final AdminUserPage page;
}

final class UserSearchFailed extends UserSearchState {
  const new(this.query, this.failure);

  final String query;
  final Failure failure;
}

/// Admin → Users: one search at a time; an older answer is dropped.
@riverpod
class UserSearchController extends _$UserSearchController {
  int _generation = 0;

  @override
  UserSearchState build() => const UserSearchIdle();

  Future<void> search(String text) async {
    final query = text.trim();
    final generation = ++_generation;
    if (query.isEmpty) {
      state = const UserSearchIdle();
      return;
    }
    state = UserSearchLoading(query);
    final result = await ref.read(adminUsersRepositoryProvider).search(query);
    if (!ref.mounted || generation != _generation) return;
    state = switch (result) {
      Ok(:final value) => UserSearchDone(query, value),
      Err(:final failure) => UserSearchFailed(query, failure),
    };
  }
}

/// Bumped after an adjustment so the user and their points reload.
@Riverpod(keepAlive: true)
class AdminUsersRevision extends _$AdminUsersRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

@riverpod
Future<Result<AdminUser>> adminUser(Ref ref, String id) {
  ref.watch(adminUsersRevisionProvider);
  return ref.read(adminUsersRepositoryProvider).fetchUser(id);
}

/// The latest 20 entries (enough to answer "where did my points go").
@riverpod
Future<Result<PointsPage>> adminUserPoints(Ref ref, String id) {
  ref.watch(adminUsersRevisionProvider);
  return ref.read(adminUsersRepositoryProvider).fetchPoints(id, 1);
}

@riverpod
class AdjustPointsController extends _$AdjustPointsController {
  @override
  RequestState<int> build(String userId) => const RequestIdle();

  Future<void> adjust({required int delta, required String note}) async {
    if (state is RequestSending) return;
    final revision = ref.read(adminUsersRevisionProvider.notifier);
    state = const RequestSending();
    final result = await ref
        .read(adminUsersRepositoryProvider)
        .adjustPoints(userId, delta: delta, note: note);
    if (result is Ok) revision.bump();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => RequestDone(delta),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

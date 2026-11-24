import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/notifications/notification_models.dart';
import 'package:staka/core/notifications/notifications_repository.dart';

part 'notification_settings_controller.g.dart';

sealed class NotificationSettingsState {
  const new();
}

final class NotificationSettingsLoading extends NotificationSettingsState {
  const new();
}

final class NotificationSettingsFailed extends NotificationSettingsState {
  const new(this.failure);

  final Failure failure;
}

final class NotificationSettingsLoaded extends NotificationSettingsState {
  const new(this.settings, {this.isSaving = false, this.saveFailure});

  final NotificationSettings settings;
  final bool isSaving;

  /// The last change failed and was undone; shown once in a snackbar.
  final Failure? saveFailure;
}

/// Account → Notifications (V2-9): push and email on or off. A switch
/// moves at once and goes back if the API says no.
@riverpod
class NotificationSettingsController extends _$NotificationSettingsController {
  @override
  NotificationSettingsState build() {
    unawaited(Future.microtask(_load));
    return const NotificationSettingsLoading();
  }

  Future<void> retry() async {
    state = const NotificationSettingsLoading();
    await _load();
  }

  Future<void> setPush({required bool on}) => _save(push: on);

  Future<void> setEmail({required bool on}) => _save(email: on);

  Future<void> _save({bool? push, bool? email}) async {
    final current = state;
    if (current is! NotificationSettingsLoaded || current.isSaving) return;
    final before = current.settings;
    state = NotificationSettingsLoaded(
      NotificationSettings(
        push: push ?? before.push,
        email: email ?? before.email,
      ),
      isSaving: true,
    );
    final result = await ref
        .read(notificationsRepositoryProvider)
        .updateSettings(push: push, email: email);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => NotificationSettingsLoaded(value),
      Err(:final failure) => NotificationSettingsLoaded(
        before,
        saveFailure: failure,
      ),
    };
  }

  Future<void> _load() async {
    final result = await ref
        .read(notificationsRepositoryProvider)
        .fetchSettings();
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => NotificationSettingsLoaded(value),
      Err(:final failure) => NotificationSettingsFailed(failure),
    };
  }
}

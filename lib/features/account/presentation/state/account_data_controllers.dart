import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/account/data/repositories/account_repository_impl.dart';
import 'package:staka/features/account/presentation/state/delete_account_state.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';
import 'package:staka/features/tags/presentation/state/share_actions.dart';

part 'account_data_controllers.g.dart';

/// Account → Download my data: the API's JSON file, handed to the share
/// sheet (Save to Files, Drive, email).
@riverpod
class ExportDataController extends _$ExportDataController {
  @override
  RequestState<void> build() => const RequestIdle();

  Future<void> download() async {
    if (state is RequestSending) return;
    final repository = ref.read(accountRepositoryProvider);
    final share = ref.read(shareActionsProvider);
    final today = ref.read(clockProvider)();
    state = const RequestSending();

    final result = await repository.exportData();
    switch (result) {
      case Ok(:final value):
        await share.shareFile(
          bytes: value,
          fileName: exportFileName(today),
          mimeType: 'application/json',
        );
        if (ref.mounted) state = const RequestDone(null);
      case Err(:final failure):
        if (ref.mounted) state = RequestFailed(failure);
    }
  }
}

/// "staka-data-2026-11-23.json", dated by the phone's calendar.
String exportFileName(DateTime now) {
  final local = now.toLocal();
  String two(int n) => n.toString().padLeft(2, '0');
  return 'staka-data-${local.year}-${two(local.month)}-${two(local.day)}.json';
}

/// Account → Delete my account. The screen signs out once it is done.
@riverpod
class DeleteAccountController extends _$DeleteAccountController {
  @override
  DeleteAccountState build() => const DeleteReady();

  bool get _isBusy => switch (state) {
    DeleteSendingCode() || DeleteDeleting() || DeleteDone() => true,
    _ => false,
  };

  Future<void> withPassword(String password) async {
    if (_isBusy) return;
    final repository = ref.read(accountRepositoryProvider);
    state = const DeleteDeleting();
    final result = await repository.deleteWithPassword(password: password);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const DeleteDone(),
      Err(:final failure) => DeleteReady(failure: failure),
    };
  }

  /// Texts a code to [phone] (the account's number); also "Resend code".
  ///
  /// The API plan names no signed-in endpoint for this code, so it uses the
  /// sign-in one (`/auth/otp/request`), whose challenge `DELETE /me` takes.
  Future<void> sendCode(String phone) async {
    if (_isBusy) return;
    final previous = state.sent;
    final repository = ref.read(authRepositoryProvider);
    state = DeleteSendingCode(sent: previous);

    final result = await repository.requestOtp(phone: phone);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => DeleteCodeSent(
        SentCode(value, sentAt: ref.read(clockProvider)()),
      ),
      Err(:final failure) => _failed(failure, previous),
    };
  }

  Future<void> withCode(String code) async {
    final current = state;
    if (current is! DeleteCodeSent) return;
    final repository = ref.read(accountRepositoryProvider);
    state = DeleteDeleting(sent: current.sent);

    final result = await repository.deleteWithCode(
      challengeId: current.sent.challenge.id,
      code: code,
    );
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const DeleteDone(),
      Err(:final failure) => DeleteCodeSent(current.sent, failure: failure),
    };
  }

  static DeleteAccountState _failed(Failure failure, SentCode? previous) =>
      previous == null
      ? DeleteReady(failure: failure)
      : DeleteCodeSent(previous, failure: failure);
}

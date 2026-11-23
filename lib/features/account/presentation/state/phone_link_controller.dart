import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/time/clock.dart';
import 'package:staka/features/account/data/repositories/account_repository_impl.dart';
import 'package:staka/features/account/presentation/state/phone_link_state.dart';
import 'package:staka/features/auth/presentation/state/otp_request_state.dart';

part 'phone_link_controller.g.dart';

@riverpod
class PhoneLinkController extends _$PhoneLinkController {
  @override
  PhoneLinkState build() => const PhoneLinkIdle();

  /// "Add" or "Change number": show the number form.
  void start() => state = const PhoneLinkEntering();

  /// Sends a code to [phone] (E.164); also the code step's "Resend code".
  Future<void> send(String phone) async {
    if (state case PhoneLinkSending() || PhoneLinkCode(isVerifying: true)) {
      return;
    }
    final previous = switch (state) {
      PhoneLinkCode(:final sent) => sent,
      _ => null,
    };
    final repository = ref.read(accountRepositoryProvider);
    state = PhoneLinkSending(sent: previous);

    final result = await repository.requestPhoneCode(phone: phone);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok(:final value) => PhoneLinkCode(
        SentCode(value, sentAt: ref.read(clockProvider)()),
      ),
      Err(:final failure) when previous != null => PhoneLinkCode(
        previous,
        failure: failure,
      ),
      Err(:final failure) => PhoneLinkEntering(failure: failure),
    };
  }

  Future<void> verify(String code) async {
    final current = state;
    if (current is! PhoneLinkCode || current.isVerifying) return;
    final repository = ref.read(accountRepositoryProvider);
    final session = ref.read(sessionControllerProvider.notifier);
    state = PhoneLinkCode(current.sent, isVerifying: true);

    final result = await repository.verifyPhone(
      challengeId: current.sent.challenge.id,
      code: code,
    );
    switch (result) {
      case Ok(:final value):
        session.updateUser(value);
        if (ref.mounted) state = const PhoneLinkDone();
      case Err(:final failure):
        if (ref.mounted) state = PhoneLinkCode(current.sent, failure: failure);
    }
  }
}

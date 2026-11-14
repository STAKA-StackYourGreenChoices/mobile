import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:staka/features/auth/presentation/state/request_state.dart';

part 'forgot_password_controller.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  RequestState build() => const RequestIdle();

  /// Can be sent again ("Send another link"), like on the website.
  Future<void> submit(String email) async {
    if (state is RequestSending) return;
    state = const RequestSending();
    final result = await ref
        .read(authRepositoryProvider)
        .requestPasswordReset(email: email);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => RequestDone(email: email.trim()),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/auth/data/repositories/auth_repository_impl.dart';

part 'forgot_password_controller.g.dart';

@riverpod
class ForgotPasswordController extends _$ForgotPasswordController {
  @override
  RequestState<String> build() => const RequestIdle();

  /// Can be sent again ("Send another link"), like on the website.
  Future<void> submit(String email) async {
    if (state is RequestSending) return;
    state = const RequestSending();
    final result = await ref
        .read(authRepositoryProvider)
        .requestPasswordReset(email: email);
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => RequestDone(email.trim()),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

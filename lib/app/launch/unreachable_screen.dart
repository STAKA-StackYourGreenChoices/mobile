import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// A saved session exists but the API couldn't be reached at launch. The
/// app is online-only, so it offers a retry, and a way out (sign out
/// locally) so nobody is stuck if the server stays down.
class UnreachableScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.read(sessionControllerProvider.notifier);
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppErrorState(
            failure: const NetworkFailure(),
            onRetryPressed: session.restore,
          ),
          AppButton(
            label: context.l10n.signOut,
            variant: AppButtonVariant.ghost,
            onPressed: session.signOut,
          ),
        ],
      ),
    );
  }
}

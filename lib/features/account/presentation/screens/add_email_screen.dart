import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/account/presentation/state/sign_in_method_controllers.dart';
import 'package:staka/features/account/presentation/widgets/add_email_form.dart';
import 'package:staka/features/auth/presentation/widgets/auth_page_heading.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Account → Email, for a phone-only account (V2-1). The API emails a
/// confirmation link; the wardrobe then shows the usual reminder until it
/// is opened.
class AddEmailScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final request = ref.watch(addEmailControllerProvider);

    ref.listen(addEmailControllerProvider, (_, next) {
      if (next case RequestDone(value: final email)) {
        AppSnackbar.show(context, message: l10n.emailAdded(email));
        context.pop();
      }
    });

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthPageHeading(title: l10n.addEmailTitle, lede: l10n.addEmailLede),
          AddEmailForm(
            alertMessage: switch (request) {
              RequestFailed(failure: ConflictFailure()) => l10n.emailTaken,
              RequestFailed(:final failure) => messageForFailure(failure, l10n),
              _ => null,
            },
            isSubmitting: request is RequestSending,
            onSubmitted: (email) => unawaited(
              ref.read(addEmailControllerProvider.notifier).submit(email),
            ),
          ),
        ],
      ),
    );
  }
}

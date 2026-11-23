import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_controller.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_state.dart';
import 'package:staka/features/brand_apply/presentation/widgets/brand_application_form.dart';
import 'package:staka/shared/widgets/feedback/app_empty_state.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The application form: a new one, or ([applicationId]) a rejected one
/// to fix and send again, taken from the applications list.
class BrandApplicationFormScreen extends ConsumerWidget {
  const new({this.applicationId, super.key});

  final String? applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final id = applicationId;
    if (id == null) {
      return AppScaffold(
        title: l10n.brandApplyTitle,
        body: const BrandApplicationForm(),
      );
    }

    final provider = brandApplicationsControllerProvider;
    final state = ref.watch(provider);
    final application = switch (state) {
      ApplicationsLoaded(:final applications) =>
        applications.where((application) => application.id == id).firstOrNull,
      _ => null,
    };
    return AppScaffold(
      title: l10n.brandEditTitle,
      isScrollable: application != null,
      body: switch (state) {
        ApplicationsLoading() => const AppLoader(),
        ApplicationsFailed(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: ref.read(provider.notifier).retry,
        ),
        ApplicationsLoaded() when application == null => AppEmptyState(
          icon: Icons.search_off_rounded,
          title: l10n.applicationNotFound,
          message: l10n.applicationNotFoundBody,
        ),
        // Keyed so a different application never inherits typed text.
        ApplicationsLoaded() => BrandApplicationForm(
          key: ValueKey(id),
          application: application,
        ),
      },
    );
  }
}

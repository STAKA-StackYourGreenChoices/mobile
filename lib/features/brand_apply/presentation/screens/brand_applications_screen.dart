import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/app/routes.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_controller.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_state.dart';
import 'package:staka/features/brand_apply/presentation/widgets/brand_application_card.dart';
import 'package:staka/features/brand_apply/presentation/widgets/brand_apply_intro.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Account → "Bring your brand to STAKA" (V2-12): the intro and Start
/// before the first application, then each application's status. Pull down
/// to see whether STAKA has decided.
class BrandApplicationsScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = brandApplicationsControllerProvider;
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    ref.listen(provider, (_, next) {
      if (next case ApplicationsLoaded(refreshFailure: final failure?)) {
        AppSnackbar.show(
          context,
          message: messageForFailure(failure, l10n),
          tone: AlertTone.error,
        );
      }
    });

    void apply() => context.pushNamed(AppRoute.brandApply.name);

    return AppScaffold(
      title: l10n.bringYourBrand,
      isScrollable: false,
      body: switch (state) {
        ApplicationsLoading() => const AppLoader(),
        ApplicationsFailed(:final failure) => AppErrorState(
          failure: failure,
          onRetryPressed: controller.retry,
        ),
        ApplicationsLoaded(:final applications) => RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              if (applications.isEmpty)
                BrandApplyIntro(onStartPressed: apply)
              else ...[
                for (final application in applications)
                  Padding(
                    key: ValueKey(application.id),
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: BrandApplicationCard(
                      application: application,
                      onEditPressed: () => context.pushNamed(
                        AppRoute.brandApplicationEdit.name,
                        pathParameters: {'id': application.id},
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xs),
                AppButton(
                  label: l10n.brandApplyAnother,
                  icon: Icons.add_rounded,
                  variant: AppButtonVariant.ghost,
                  isExpanded: true,
                  onPressed: apply,
                ),
              ],
            ],
          ),
        ),
      },
    );
  }
}

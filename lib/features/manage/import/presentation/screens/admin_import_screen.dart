import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/import/presentation/state/import_controller.dart';
import 'package:staka/features/manage/import/presentation/state/import_state.dart';
import 'package:staka/features/manage/import/presentation/state/template_controller.dart';
import 'package:staka/features/manage/import/presentation/widgets/choose_file_panel.dart';
import 'package:staka/features/manage/import/presentation/widgets/import_done_panel.dart';
import 'package:staka/features/manage/import/presentation/widgets/import_review_panel.dart';
import 'package:staka/features/manage/import/presentation/widgets/import_stepper.dart';
import 'package:staka/features/manage/shared/manage_routes.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// The website's `/admin/import`: choose a CSV, check it without saving,
/// then import the valid rows.
class AdminImportScreen extends ConsumerWidget {
  const new({required this.scope, super.key});

  /// Admin (every brand) or one brand's team.
  final ManageScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(importControllerProvider(scope));
    final controller = ref.read(importControllerProvider(scope).notifier);
    final template = ref.watch(templateControllerProvider(scope));

    ref.listen(templateControllerProvider(scope), (_, next) {
      if (next is! RequestFailed) return;
      AppSnackbar.show(
        context,
        message: l10n.templateUnavailable,
        tone: AlertTone.error,
      );
    });

    final error = switch (state) {
      ImportChoosing(:final error) || ImportReviewing(:final error) => error,
      ImportDone() => null,
    };

    return AppScaffold(
      showAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(l10n.importTitle, style: context.text.headingLarge),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.adminImportDescription,
            style: context.text.bodyLarge.copyWith(
              color: context.colors.inkMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ImportStepper(
            current: switch (state) {
              ImportChoosing() => 0,
              ImportReviewing() => 1,
              ImportDone() => 2,
            },
            isFinished: state is ImportDone,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (error != null) ...[
            AppFormAlert(message: _message(error, l10n), tone: AlertTone.error),
            const SizedBox(height: AppSpacing.lg),
          ],
          switch (state) {
            ImportChoosing(:final file, :final isChecking) => ChooseFilePanel(
              file: file,
              isChecking: isChecking,
              isFetchingTemplate: template is RequestSending,
              onChoosePressed: controller.chooseFile,
              onCheckPressed: controller.check,
              onTemplatePressed: (origin) => ref
                  .read(templateControllerProvider(scope).notifier)
                  .download(origin: origin),
            ),
            ImportReviewing(:final file, :final report, :final isImporting) =>
              ImportReviewPanel(
                report: report,
                fileName: file.name,
                isImporting: isImporting,
                onImportPressed: controller.importFile,
                onChooseAnotherPressed: controller.startOver,
              ),
            ImportDone(:final report) => ImportDonePanel(
              report: report,
              onViewProductsPressed: () =>
                  context.goNamed(scope.productsRoute.name),
              onImportAnotherPressed: controller.startOver,
            ),
          },
        ],
      ),
    );
  }

  static String _message(ImportError error, AppLocalizations l10n) =>
      switch (error) {
        ImportFileRejected(reason: FileRejection.missing) =>
          l10n.chooseCsvFirst,
        ImportFileRejected(reason: FileRejection.notCsv, :final fileName) =>
          l10n.notCsvFile(fileName),
        ImportFileRejected(reason: FileRejection.tooLarge) => l10n.csvTooLarge,
        ImportRequestFailed(:final failure) => messageForFailure(failure, l10n),
      };
}

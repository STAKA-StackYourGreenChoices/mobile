import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/brands/domain/models/brand_draft.dart';
import 'package:staka/features/manage/brands/presentation/state/brand_save_controller.dart';
import 'package:staka/features/manage/brands/presentation/widgets/brand_form_fields.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// Add a brand ([brand] null) or edit one: the website's `BrandDialog` as
/// a bottom sheet. The saved brand once the API accepts it; null if the
/// admin cancels.
Future<BrandSummary?> showBrandFormSheet(
  BuildContext context, {
  BrandSummary? brand,
}) {
  final container = ProviderScope.containerOf(context);
  return showModalBottomSheet<BrandSummary>(
    context: context,
    // Over the whole app, like dialogs: the tab bar is covered too.
    useRootNavigator: true,
    isScrollControlled: true,
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: _BrandFormSheet(brand: brand),
    ),
  );
}

class _BrandFormSheet extends ConsumerStatefulWidget {
  const new({this.brand});

  final BrandSummary? brand;

  @override
  ConsumerState<_BrandFormSheet> createState() => _BrandFormSheetState();
}

class _BrandFormSheetState extends ConsumerState<_BrandFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.brand?.name);
  late final _description = TextEditingController(
    text: widget.brand?.description,
  );
  late final _logoUrl = TextEditingController(text: widget.brand?.logoUrl);

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _logoUrl.dispose();
    super.dispose();
  }

  String? _optional(TextEditingController field) =>
      field.text.trim().isEmpty ? null : field.text.trim();

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(brandSaveControllerProvider(widget.brand?.id).notifier)
        .submit(
          BrandDraft(
            name: _name.text.trim(),
            description: _optional(_description),
            logoUrl: _optional(_logoUrl),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final brand = widget.brand;
    final provider = brandSaveControllerProvider(brand?.id);
    final save = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next case RequestDone(:final value)) Navigator.of(context).pop(value);
    });
    final failure = switch (save) {
      RequestFailed(:final failure) => failure,
      _ => null,
    };
    final isNameTaken = failure is ConflictFailure;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    brand == null
                        ? l10n.addBrand
                        : l10n.editBrandLabel(brand.name),
                    style: context.text.headingMedium,
                  ),
                ),
                Text(
                  brand == null
                      ? l10n.addBrandDescription
                      : l10n.editBrandDescription,
                  style: context.text.bodyMedium.copyWith(
                    color: context.colors.inkMuted,
                  ),
                ),
                if (failure != null && !isNameTaken)
                  AppFormAlert(
                    message: messageForFailure(failure, l10n),
                    tone: AlertTone.error,
                  ),
                BrandFormFields(
                  name: _name,
                  description: _description,
                  logoUrl: _logoUrl,
                  nameError: isNameTaken ? l10n.brandNameTaken : null,
                ),
                AppButton(
                  label: brand == null ? l10n.addBrand : l10n.saveChanges,
                  loadingLabel: l10n.saving,
                  isLoading: save is RequestSending,
                  isExpanded: true,
                  onPressed: _submit,
                ),
                AppButton(
                  label: l10n.cancel,
                  variant: AppButtonVariant.ghost,
                  isExpanded: true,
                  onPressed: save is RequestSending
                      ? null
                      : () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

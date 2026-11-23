import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/brand_apply/domain/models/brand_file.dart';
import 'package:staka/features/brand_apply/presentation/forms/brand_application_rules.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_file_picker.dart';
import 'package:staka/features/brand_apply/presentation/widgets/brand_file_field.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';
import 'package:staka/features/brand_portal/presentation/state/brand_settings_controllers.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The Settings fields, filled from [profile], with the application form's
/// rules. A new logo replaces the current one; none keeps it.
class BrandSettingsForm extends ConsumerStatefulWidget {
  const new({required this.profile, super.key});

  final BrandProfile profile;

  @override
  ConsumerState<BrandSettingsForm> createState() => _BrandSettingsFormState();
}

class _BrandSettingsFormState extends ConsumerState<BrandSettingsForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.profile.name);
  late final _description = TextEditingController(
    text: widget.profile.description,
  );
  late final _website = TextEditingController(text: widget.profile.websiteUrl);
  late final _contactEmail = TextEditingController(
    text: widget.profile.contactEmail,
  );
  late final _contactPhone = TextEditingController(
    text: switch (widget.profile.contactPhone) {
      final phone? => PhoneNumber.display(phone),
      null => null,
    },
  );
  BrandFile? _logo;
  String? _logoError;

  @override
  void dispose() {
    for (final controller in [
      _name,
      _description,
      _website,
      _contactEmail,
      _contactPhone,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _optional(TextEditingController field) =>
      field.text.trim().isEmpty ? null : field.text.trim();

  Future<void> _pickLogo() async {
    final file = await ref.read(brandFilePickerProvider).pickLogo();
    if (file == null || !mounted) return;
    final isTooLarge = file.sizeBytes > BrandFile.logoMaxBytes;
    setState(() {
      _logoError = isTooLarge ? context.l10n.logoTooLarge : null;
      if (!isTooLarge) _logo = file;
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(brandSettingsSaveControllerProvider(widget.profile.id).notifier)
        .save(
          BrandProfileDraft(
            name: _name.text.trim(),
            contactEmail: _contactEmail.text.trim(),
            description: _optional(_description),
            websiteUrl: _optional(_website),
            contactPhone: switch (_optional(_contactPhone)) {
              final phone? => PhoneNumber.toE164(phone),
              null => null,
            },
            logo: _logo,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rules = BrandApplicationRules(l10n);
    final provider = brandSettingsSaveControllerProvider(widget.profile.id);
    final save = ref.watch(provider);
    ref.listen(provider, (_, next) {
      if (next is RequestDone) {
        AppSnackbar.show(context, message: l10n.changesSaved);
        setState(() => _logo = null);
      }
    });
    final failure = switch (save) {
      RequestFailed(:final failure) => failure,
      _ => null,
    };
    final isNameTaken = failure is ConflictFailure;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg - AppSpacing.xxs,
        children: [
          if (failure != null && !isNameTaken)
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
          AppTextField(
            label: l10n.fieldBrandName,
            controller: _name,
            validator: rules.name,
            errorText: isNameTaken ? l10n.brandNameOnStaka : null,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            textInputAction: TextInputAction.next,
          ),
          AppTextField(
            label: l10n.fieldAboutBrand,
            controller: _description,
            helperText: l10n.aboutYourBrandHint,
            validator: rules.description,
            inputFormatters: [LengthLimitingTextInputFormatter(1000)],
            keyboardType: TextInputType.multiline,
            maxLines: 3,
          ),
          AppTextField(
            label: l10n.fieldWebsite,
            controller: _website,
            hint: l10n.websitePlaceholder,
            helperText: l10n.optionalHint,
            validator: rules.website,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
          ),
          AppTextField(
            label: l10n.fieldContactEmail,
            controller: _contactEmail,
            validator: rules.contactEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          AppTextField(
            label: l10n.fieldContactPhone,
            controller: _contactPhone,
            helperText: l10n.optionalHint,
            validator: rules.contactPhone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
          ),
          BrandFileField(
            title: l10n.brandLogo,
            hint: l10n.brandLogoHint,
            chooseLabel: l10n.chooseLogo,
            chooseIcon: Icons.image_outlined,
            file: _logo,
            keptNote: widget.profile.logoUrl != null ? l10n.logoKept : null,
            errorText: _logoError,
            onChoosePressed: _pickLogo,
            onRemovePressed: () => setState(() => _logo = null),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: l10n.saveChanges,
            loadingLabel: l10n.saving,
            isLoading: save is RequestSending,
            isExpanded: true,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}

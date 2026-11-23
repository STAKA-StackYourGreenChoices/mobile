import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/error/error_mapper.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/core/utils/phone_number.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';
import 'package:staka/features/brand_apply/domain/models/brand_file.dart';
import 'package:staka/features/brand_apply/presentation/forms/brand_application_rules.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_application_submit_controller.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_file_picker.dart';
import 'package:staka/features/brand_apply/presentation/widgets/brand_file_field.dart';
import 'package:staka/features/brand_apply/presentation/widgets/listed_brand_field.dart';
import 'package:staka/features/tags/presentation/widgets/receipt_source_sheet.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';
import 'package:staka/shared/widgets/feedback/app_snackbar.dart';
import 'package:staka/shared/widgets/inputs/app_text_field.dart';

/// The application in three steps: the brand, how STAKA reaches you, logo
/// and documents. Each step checks its own fields before Continue; the
/// back arrow goes to the previous step. [application] is a rejected one
/// being fixed and sent again (fields filled in from it).
class BrandApplicationForm extends ConsumerStatefulWidget {
  const new({this.application, super.key});

  final BrandApplication? application;

  @override
  ConsumerState<BrandApplicationForm> createState() =>
      _BrandApplicationFormState();
}

enum _Step { brand, contact, files }

class _BrandApplicationFormState extends ConsumerState<BrandApplicationForm> {
  final Map<_Step, GlobalKey<FormState>> _formKeys = {
    for (final step in _Step.values) step: GlobalKey<FormState>(),
  };
  _Step _step = _Step.brand;

  late final BrandApplication? _sent = widget.application;
  late final _name = TextEditingController(text: _sent?.name);
  late final _legalName = TextEditingController(text: _sent?.legalName);
  late final _description = TextEditingController(text: _sent?.description);
  late final _website = TextEditingController(text: _sent?.websiteUrl);
  late final _gstin = TextEditingController(text: _sent?.gstin);
  late final TextEditingController _contactEmail;
  late final TextEditingController _contactPhone;

  late var _isClaiming = _sent?.existingBrandId != null;
  late String? _listedBrandId = _sent?.existingBrandId;
  BrandFile? _logo;
  BrandFile? _document;
  String? _logoError;
  String? _documentError;

  @override
  void initState() {
    super.initState();
    // A new application starts with the person's own contact details.
    final session = ref.read(sessionControllerProvider);
    final user = session is SignedIn ? session.user : null;
    _contactEmail = TextEditingController(
      text: _sent?.contactEmail ?? (_sent == null ? user?.email : null),
    );
    final phone = _sent?.contactPhone ?? (_sent == null ? user?.phone : null);
    _contactPhone = TextEditingController(
      text: phone == null ? null : PhoneNumber.display(phone),
    );
  }

  @override
  void dispose() {
    for (final controller in [
      _name,
      _legalName,
      _description,
      _website,
      _gstin,
      _contactEmail,
      _contactPhone,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _optional(TextEditingController field) =>
      field.text.trim().isEmpty ? null : field.text.trim();

  BrandApplicationDraft _draft() {
    final gstin = BrandApplicationRules.normalisedGstin(_gstin.text);
    return BrandApplicationDraft(
      name: _name.text.trim(),
      legalName: _legalName.text.trim(),
      contactEmail: _contactEmail.text.trim(),
      contactPhone: switch (_optional(_contactPhone)) {
        final phone? => PhoneNumber.toE164(phone),
        null => null,
      },
      websiteUrl: _optional(_website),
      gstin: gstin.isEmpty ? null : gstin,
      description: _optional(_description),
      existingBrandId: _isClaiming ? _listedBrandId : null,
      logo: _logo,
      document: _document,
    );
  }

  void _goTo(_Step step) => setState(() => _step = step);

  Future<void> _continue() async {
    if (!(_formKeys[_step]!.currentState?.validate() ?? false)) return;
    switch (_step) {
      case _Step.brand:
        _goTo(_Step.contact);
      case _Step.contact:
        _goTo(_Step.files);
      case _Step.files:
        await ref
            .read(brandApplicationSubmitControllerProvider(_sent?.id).notifier)
            .submit(_draft());
    }
  }

  Future<void> _pickLogo() async {
    final file = await ref.read(brandFilePickerProvider).pickLogo();
    if (file == null || !mounted) return;
    final isTooLarge = file.sizeBytes > BrandFile.logoMaxBytes;
    setState(() {
      _logoError = isTooLarge ? context.l10n.logoTooLarge : null;
      if (!isTooLarge) _logo = file;
    });
  }

  Future<void> _pickDocument() async {
    final source = await showReceiptSourceSheet(context);
    if (source == null) return;
    final file = await ref.read(brandFilePickerProvider).pickDocument(source);
    if (file == null || !mounted) return;
    final isTooLarge = file.sizeBytes > BrandFile.documentMaxBytes;
    setState(() {
      _documentError = isTooLarge ? context.l10n.documentTooLarge : null;
      if (!isTooLarge) _document = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final provider = brandApplicationSubmitControllerProvider(_sent?.id);
    final submit = ref.watch(provider);
    ref.listen(provider, (_, next) {
      switch (next) {
        case RequestDone():
          AppSnackbar.show(context, message: l10n.applicationSent);
          context.pop();
        // The name is taken: back to the step where it can be changed.
        case RequestFailed(failure: ConflictFailure()):
          _goTo(_Step.brand);
        case RequestIdle() || RequestSending() || RequestFailed():
          break;
      }
    });
    final failure = switch (submit) {
      RequestFailed(:final failure) => failure,
      _ => null,
    };
    final isSending = submit is RequestSending;

    return PopScope(
      canPop: _step == _Step.brand && !isSending,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || isSending) return;
        _goTo(_Step.values[_step.index - 1]);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeader(step: _step),
          const SizedBox(height: AppSpacing.lg),
          if (failure != null && failure is! ConflictFailure) ...[
            AppFormAlert(
              message: messageForFailure(failure, l10n),
              tone: AlertTone.error,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Form(
            key: _formKeys[_step],
            child: switch (_step) {
              _Step.brand => _brandFields(
                nameError: failure is ConflictFailure
                    ? l10n.brandNameOnStaka
                    : null,
              ),
              _Step.contact => _contactFields(),
              _Step.files => _fileFields(),
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: _step == _Step.files
                ? l10n.sendApplication
                : l10n.continueStep,
            loadingLabel: l10n.sendingApplication,
            isLoading: isSending,
            isExpanded: true,
            onPressed: _continue,
          ),
          if (_step != _Step.brand) ...[
            const SizedBox(height: AppSpacing.xs),
            AppButton(
              label: l10n.back,
              variant: AppButtonVariant.ghost,
              isExpanded: true,
              onPressed: isSending
                  ? null
                  : () => _goTo(_Step.values[_step.index - 1]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _brandFields({required String? nameError}) {
    final l10n = context.l10n;
    final rules = BrandApplicationRules(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg - AppSpacing.xxs,
      children: [
        ListedBrandField(
          isClaiming: _isClaiming,
          brandId: _listedBrandId,
          validator: rules.listedBrand,
          onClaimingChanged: (value) => setState(() => _isClaiming = value),
          onBrandChanged: (brand) => setState(() {
            _listedBrandId = brand.id;
            _name.text = brand.name;
          }),
        ),
        AppTextField(
          label: l10n.fieldBrandName,
          controller: _name,
          validator: rules.name,
          errorText: nameError,
          inputFormatters: [LengthLimitingTextInputFormatter(100)],
          textInputAction: TextInputAction.next,
        ),
        AppTextField(
          label: l10n.fieldLegalName,
          controller: _legalName,
          helperText: l10n.legalNameHint,
          validator: rules.legalName,
          inputFormatters: [LengthLimitingTextInputFormatter(200)],
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
          label: l10n.fieldGstin,
          controller: _gstin,
          helperText: l10n.gstinHint,
          validator: rules.gstin,
          inputFormatters: [LengthLimitingTextInputFormatter(20)],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _continue(),
        ),
      ],
    );
  }

  Widget _contactFields() {
    final l10n = context.l10n;
    final rules = BrandApplicationRules(l10n);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg - AppSpacing.xxs,
      children: [
        Text(
          l10n.brandStepContactBody,
          style: context.text.bodyMedium.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        AppTextField(
          label: l10n.fieldContactEmail,
          controller: _contactEmail,
          validator: rules.contactEmail,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          textInputAction: TextInputAction.next,
        ),
        AppTextField(
          label: l10n.fieldContactPhone,
          controller: _contactPhone,
          helperText: l10n.optionalHint,
          validator: rules.contactPhone,
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _continue(),
        ),
      ],
    );
  }

  Widget _fileFields() {
    final l10n = context.l10n;
    final isResubmit = _sent != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.lg,
      children: [
        BrandFileField(
          title: l10n.brandLogo,
          hint: l10n.brandLogoHint,
          chooseLabel: l10n.chooseLogo,
          chooseIcon: Icons.image_outlined,
          file: _logo,
          keptNote: isResubmit && _sent.logoUrl != null ? l10n.logoKept : null,
          errorText: _logoError,
          onChoosePressed: _pickLogo,
          onRemovePressed: () => setState(() => _logo = null),
        ),
        BrandFileField(
          title: l10n.businessDocument,
          hint: l10n.businessDocumentHint,
          chooseLabel: l10n.addDocument,
          chooseIcon: Icons.upload_file_outlined,
          file: _document,
          keptNote: isResubmit ? l10n.documentKept : null,
          errorText: _documentError,
          onChoosePressed: _pickDocument,
          onRemovePressed: () => setState(() => _document = null),
        ),
      ],
    );
  }
}

/// "Step 2 of 3", a progress bar, and the step's heading.
class _StepHeader extends StatelessWidget {
  const new({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final number = step.index + 1;
    final total = _Step.values.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.brandApplyStepOf(number, total),
          style: context.text.bodySmall.copyWith(
            color: context.colors.inkMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        ExcludeSemantics(
          child: LinearProgressIndicator(
            value: number / total,
            borderRadius: AppRadius.allFull,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Semantics(
          header: true,
          child: Text(switch (step) {
            _Step.brand => l10n.brandStepBrand,
            _Step.contact => l10n.brandStepContact,
            _Step.files => l10n.brandStepFiles,
          }, style: context.text.headingLarge),
        ),
      ],
    );
  }
}

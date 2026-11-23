import 'package:material_ui/material_ui.dart';

import 'package:staka/core/design/app_spacing.dart';
import 'package:staka/core/design/app_typography.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/manage/products/domain/models/editable_product.dart';
import 'package:staka/features/manage/products/domain/models/product_draft.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_rules.dart';
import 'package:staka/features/manage/products/presentation/forms/product_form_values.dart';
import 'package:staka/features/manage/products/presentation/forms/product_save_errors.dart';
import 'package:staka/features/manage/products/presentation/widgets/figures_fields.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_details_fields.dart';
import 'package:staka/features/manage/products/presentation/widgets/product_tag_preview.dart';
import 'package:staka/shared/widgets/buttons/app_button.dart';
import 'package:staka/shared/widgets/feedback/app_form_alert.dart';

/// The website's `ProductForm`: the live tag preview first (as on a
/// phone), then the Product and Sustainability figures sections, then
/// Cancel and Save. Checks the website's rules before calling
/// [onSubmitted]; a refused save comes back as [saveErrors].
class ProductForm extends StatefulWidget {
  const new({
    required this.brands,
    required this.onSubmitted,
    required this.onCancelPressed,
    this.onAddBrandPressed,
    this.fixedBrandId,
    this.product,
    this.saveErrors,
    this.isSaving = false,
    super.key,
  });

  final List<BrandSummary> brands;

  /// The product being edited; null when adding one.
  final EditableProduct? product;
  final ProductSaveErrors? saveErrors;
  final bool isSaving;
  final ValueChanged<ProductDraft> onSubmitted;
  final VoidCallback onCancelPressed;

  /// Null hides "Missing one? Add it" (a brand can't add brands).
  final VoidCallback? onAddBrandPressed;

  /// A brand's own products: this brand, chosen and locked.
  final String? fixedBrandId;

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final _values = ProductFormValues(
    widget.product,
    defaultBrandId: widget.fixedBrandId,
  );
  bool _hasInvalidFields = false;

  @override
  void dispose() {
    _values.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _hasInvalidFields = !isValid);
    if (isValid) widget.onSubmitted(_values.toDraft());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rules = ProductFormRules(
      l10n,
      hasFigures: () => _values.hasFigures,
      isVerified: () => _values.isVerified,
    );
    final alert = _hasInvalidFields
        ? l10n.productFormInvalid
        : widget.saveErrors?.alert;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProductTagPreview(values: _values, brands: widget.brands),
          const SizedBox(height: AppSpacing.xl),
          if (alert != null) ...[
            AppFormAlert(message: alert, tone: AlertTone.error),
            const SizedBox(height: AppSpacing.lg),
          ],
          _SectionTitle(l10n.productSection),
          ProductDetailsFields(
            values: _values,
            rules: rules,
            brands: widget.brands,
            serverErrors: _hasInvalidFields
                ? const {}
                : widget.saveErrors?.fields ?? const {},
            onAddBrandPressed: widget.onAddBrandPressed,
            isBrandLocked: widget.fixedBrandId != null,
          ),
          const Divider(height: AppSpacing.xxl),
          _SectionTitle(l10n.figuresSection),
          FiguresFields(values: _values, rules: rules),
          const Divider(height: AppSpacing.xxl),
          AppButton(
            label: widget.product == null ? l10n.addProduct : l10n.saveChanges,
            loadingLabel: l10n.saving,
            isLoading: widget.isSaving,
            isExpanded: true,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: l10n.cancel,
            variant: AppButtonVariant.ghost,
            isExpanded: true,
            onPressed: widget.isSaving ? null : widget.onCancelPressed,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Semantics(
      header: true,
      child: Text(text, style: context.text.headingSmall),
    ),
  );
}

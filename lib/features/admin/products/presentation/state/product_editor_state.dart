import 'package:staka/core/error/failure.dart';
import 'package:staka/core/models/brand_summary.dart';
import 'package:staka/features/admin/products/domain/models/editable_product.dart';

/// The add / edit product page before the form is shown (guide §4.3).
sealed class ProductEditorState {
  const new();
}

final class EditorLoading extends ProductEditorState {
  const new();
}

/// Ready to edit [product], or to add one when it is null.
final class EditorReady extends ProductEditorState {
  const new({required this.brands, this.product});

  final List<BrandSummary> brands;
  final EditableProduct? product;
}

/// No product has this id (the website shows its 404 page).
final class EditorNotFound extends ProductEditorState {
  const new();
}

final class EditorFailed extends ProductEditorState {
  const new(this.failure);

  final Failure failure;
}

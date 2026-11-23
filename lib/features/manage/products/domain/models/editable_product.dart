import 'package:flutter/foundation.dart';

import 'package:staka/core/models/product.dart';

/// A product opened for editing. [product] is ready to show (its photo
/// address re-pointed so this phone can load it); [storedImageUrl] is the
/// address exactly as the API stores it, which the form edits and sends
/// back, so saving never rewrites a link the admin did not touch.
@immutable
class EditableProduct {
  const new({required this.product, this.storedImageUrl});

  final Product product;
  final String? storedImageUrl;
}

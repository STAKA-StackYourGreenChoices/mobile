import 'package:flutter/foundation.dart';

/// What the admin typed in the brand form, already checked: the body of
/// `POST /brands` or `PATCH /brands/:id`. Empty optional fields are null
/// (cleared on edit, like the website).
@immutable
class BrandDraft {
  const new({required this.name, this.description, this.logoUrl});

  final String name;
  final String? description;
  final String? logoUrl;
}

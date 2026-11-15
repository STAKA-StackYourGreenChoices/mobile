import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_catalog_revision.g.dart';

/// Bumped whenever a product is added, changed or deleted, so the product
/// list (kept under the form) reloads, like the website's `revalidatePath`.
@Riverpod(keepAlive: true)
class AdminCatalogRevision extends _$AdminCatalogRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_catalog_revision.g.dart';

/// Bumped whenever a product or brand is added, changed or deleted, so the
/// admin lists showing them reload, like the website's `revalidatePath`.
@Riverpod(keepAlive: true)
class AdminCatalogRevision extends _$AdminCatalogRevision {
  @override
  int build() => 0;

  void bump() => state++;
}

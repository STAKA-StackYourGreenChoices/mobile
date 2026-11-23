import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/features/manage/shared/manage_scope.dart';

part 'admin_catalog_revision.g.dart';

/// Bumped whenever a product or brand is added, changed or deleted, so the
/// lists in that [ManageScope] reload, like the website's `revalidatePath`.
@Riverpod(keepAlive: true)
class AdminCatalogRevision extends _$AdminCatalogRevision {
  @override
  int build(ManageScope scope) => 0;

  void bump() => state++;
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/features/manage/claims/domain/models/claim.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'claim_sort.g.dart';

/// The claims list's order for one side (V2-8): newest, or by the
/// automatic check's score. Kept while a claim is open above the list.
@Riverpod(keepAlive: true)
class ClaimSortChoice extends _$ClaimSortChoice {
  @override
  ClaimSort build(ManageScope scope) => ClaimSort.newest;

  // A method, not a setter: the list hands it on as a callback.
  // ignore: use_setters_to_change_properties
  void select(ClaimSort sort) => state = sort;
}

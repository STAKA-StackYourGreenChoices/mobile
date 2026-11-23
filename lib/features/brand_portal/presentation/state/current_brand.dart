import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/auth/session_state.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'current_brand.g.dart';

/// The brand chosen in the Brand tab's switcher; null until one is chosen.
/// Kept while the app runs, so the tab reopens on the same brand.
@Riverpod(keepAlive: true)
class SelectedBrandId extends _$SelectedBrandId {
  @override
  String? build() => null;

  // A verb reads better than a setter at the call site: select(id).
  // ignore: use_setters_to_change_properties
  void select(String brandId) => state = brandId;
}

/// The brands in the Brand tab (approved or paused), from the session.
@riverpod
List<BrandMembership> portalBrands(Ref ref) => ref.watch(
  sessionControllerProvider.select(
    (session) => switch (session) {
      SignedIn(:final user) => user.portalBrands,
      _ => const <BrandMembership>[],
    },
  ),
);

/// The brand the Brand tab shows: the chosen one while the person still
/// belongs to it, otherwise the first. Null without any (the router keeps
/// such people out of the tab).
@riverpod
BrandMembership? currentBrand(Ref ref) {
  final brands = ref.watch(portalBrandsProvider);
  final id = ref.watch(selectedBrandIdProvider);
  return brands.where((brand) => brand.id == id).firstOrNull ??
      brands.firstOrNull;
}

/// The current brand's scope for the shared management screens.
@riverpod
BrandScope? currentBrandScope(Ref ref) =>
    switch (ref.watch(currentBrandProvider.select((brand) => brand?.id))) {
      final id? => BrandScope(id),
      null => null,
    };

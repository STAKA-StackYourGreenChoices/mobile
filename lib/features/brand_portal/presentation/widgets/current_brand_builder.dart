import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/presentation/state/current_brand.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

/// Builds a Brand tab screen for the brand chosen in the tab, with its
/// [BrandScope] for the shared management screens. Keyed by the brand, so
/// switching brands never keeps the other brand's typed text or lists.
class CurrentBrandBuilder extends ConsumerWidget {
  const new({required this.builder, super.key});

  final Widget Function(BrandMembership brand, BrandScope scope) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brand = ref.watch(currentBrandProvider);
    // The router keeps people without a brand out; this covers the frame
    // in which it is leaving.
    if (brand == null) return const SizedBox.shrink();
    return KeyedSubtree(
      key: ValueKey(brand.id),
      child: builder(brand, BrandScope(brand.id)),
    );
  }
}

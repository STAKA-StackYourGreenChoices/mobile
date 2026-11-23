import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/l10n/l10n.dart';
import 'package:staka/core/models/brand_membership.dart';
import 'package:staka/features/brand_portal/presentation/state/brand_settings_controllers.dart';
import 'package:staka/features/brand_portal/presentation/widgets/brand_settings_form.dart';
import 'package:staka/shared/widgets/feedback/app_error_state.dart';
import 'package:staka/shared/widgets/feedback/app_loader.dart';
import 'package:staka/shared/widgets/layout/app_scaffold.dart';

/// Owners edit how [brand] appears on STAKA: name, logo, description,
/// website and contacts (`GET` / `PATCH /brand/:brandId`).
class BrandSettingsScreen extends ConsumerWidget {
  const new({required this.brand, super.key});

  final BrandMembership brand;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final provider = brandProfileProvider(brand.id);
    final profile = ref.watch(provider);
    return AppScaffold(
      title: l10n.brandSettings,
      isScrollable: profile is AsyncData && profile.value is Ok,
      body: switch (profile) {
        AsyncData(value: Ok(:final value)) => BrandSettingsForm(
          key: ValueKey(value.id),
          profile: value,
        ),
        AsyncData(value: Err(:final failure)) => AppErrorState(
          failure: failure,
          onRetryPressed: () => ref.invalidate(provider),
        ),
        _ => const AppLoader(),
      },
    );
  }
}

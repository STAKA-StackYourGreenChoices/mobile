import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/auth/session_controller.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/brand_portal/data/repositories/brand_portal_repository_impl.dart';
import 'package:staka/features/brand_portal/domain/models/brand_profile.dart';

part 'brand_settings_controllers.g.dart';

/// [brandId]'s profile for Settings. Loading while the future runs.
@riverpod
Future<Result<BrandProfile>> brandProfile(Ref ref, String brandId) =>
    ref.read(brandPortalRepositoryProvider).fetchProfile(brandId);

/// Saves Settings (`PATCH /brand/:brandId`). The brand's name and logo
/// also show in the tab's header and switcher, which come from the
/// session, so the user is re-read after a save.
@riverpod
class BrandSettingsSaveController extends _$BrandSettingsSaveController {
  @override
  RequestState<BrandProfile> build(String brandId) => const RequestIdle();

  Future<void> save(BrandProfileDraft draft) async {
    if (state is RequestSending) return;
    state = const RequestSending();
    final result = await ref
        .read(brandPortalRepositoryProvider)
        .updateProfile(brandId, draft);
    if (!ref.mounted) return;
    if (result case Ok()) {
      await ref.read(sessionControllerProvider.notifier).refreshUser();
      if (!ref.mounted) return;
    }
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

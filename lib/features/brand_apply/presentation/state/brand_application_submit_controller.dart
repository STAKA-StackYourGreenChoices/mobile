import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/brand_apply/data/repositories/brand_application_repository_impl.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application.dart';
import 'package:staka/features/brand_apply/domain/models/brand_application_draft.dart';
import 'package:staka/features/brand_apply/presentation/state/brand_applications_controller.dart';

part 'brand_application_submit_controller.g.dart';

/// Sends the application form: a new application ([applicationId] null)
/// or a rejected one again. The list shows the answer straight away.
@riverpod
class BrandApplicationSubmitController
    extends _$BrandApplicationSubmitController {
  @override
  RequestState<BrandApplication> build(String? applicationId) =>
      const RequestIdle();

  Future<void> submit(BrandApplicationDraft draft) async {
    if (state is RequestSending) return;
    state = const RequestSending();
    final repository = ref.read(brandApplicationRepositoryProvider);
    final result = switch (applicationId) {
      final id? => await repository.resubmit(id, draft),
      null => await repository.apply(draft),
    };
    if (!ref.mounted) return;
    if (result case Ok(:final value)) {
      ref.read(brandApplicationsControllerProvider.notifier).saved(value);
    }
    state = switch (result) {
      Ok(:final value) => RequestDone(value),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

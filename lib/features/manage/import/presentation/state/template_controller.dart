import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/state/request_state.dart';
import 'package:staka/features/manage/import/data/repositories/import_repository_impl.dart';
import 'package:staka/features/manage/import/presentation/state/import_file_actions.dart';
import 'package:staka/features/manage/shared/manage_scope.dart';

part 'template_controller.g.dart';

/// "Download the template": fetch it with the admin's token, then hand it
/// to the share sheet.
@riverpod
class TemplateController extends _$TemplateController {
  @override
  RequestState<void> build(ManageScope scope) => const RequestIdle();

  Future<void> download({Rect? origin}) async {
    if (state is RequestSending) return;
    final actions = ref.read(importFileActionsProvider);
    state = const RequestSending();
    final result = await ref
        .read(importRepositoryProvider(scope))
        .fetchTemplate();
    if (result case Ok(:final value)) {
      await actions.shareTemplate(value, origin: origin);
    }
    if (!ref.mounted) return;
    state = switch (result) {
      Ok() => const RequestDone(null),
      Err(:final failure) => RequestFailed(failure),
    };
  }
}

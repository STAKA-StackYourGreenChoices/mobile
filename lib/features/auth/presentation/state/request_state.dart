import 'package:staka/core/error/failure.dart';

/// A one-shot request from a form (send a reset link, change a password).
sealed class RequestState {
  const new();
}

final class RequestIdle extends RequestState {
  const new();
}

final class RequestSending extends RequestState {
  const new();
}

final class RequestDone extends RequestState {
  const new({this.email});

  /// Where a reset link was sent, for the confirmation message.
  final String? email;
}

final class RequestFailed extends RequestState {
  const new(this.failure);

  final Failure failure;
}

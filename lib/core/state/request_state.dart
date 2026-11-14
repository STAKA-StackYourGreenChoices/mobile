import 'package:staka/core/error/failure.dart';

/// A one-shot request a screen sends and shows the outcome of (send a
/// reset link, change a password, resend a confirmation email). [T] is
/// what success carries for the confirmation message.
sealed class RequestState<T> {
  const new();
}

final class RequestIdle<T> extends RequestState<T> {
  const new();
}

final class RequestSending<T> extends RequestState<T> {
  const new();
}

final class RequestDone<T> extends RequestState<T> {
  const new(this.value);

  final T value;
}

final class RequestFailed<T> extends RequestState<T> {
  const new(this.failure);

  final Failure failure;
}

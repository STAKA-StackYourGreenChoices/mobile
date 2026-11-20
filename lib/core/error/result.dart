import 'package:staka/core/error/failure.dart';

/// What every repository method returns: a value or a [Failure], never a
/// thrown exception (guide §10.1).
sealed class Result<T> {
  const new();

  /// Collapses both cases into one value.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Ok<T>(:final value) => onSuccess(value),
    Err<T>(:final failure) => onFailure(failure),
  };
}

final class Ok<T> extends Result<T> {
  const new(this.value);

  final T value;
}

final class Err<T> extends Result<T> {
  const new(this.failure);

  final Failure failure;
}

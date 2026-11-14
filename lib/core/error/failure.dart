/// Everything that can go wrong below the presentation layer, as data.
///
/// Repositories never throw across the layer boundary (guide §10.1); they
/// return one of these inside a `Result`. `switch` on it is exhaustive.
sealed class Failure {
  const new();
}

/// The API couldn't be reached: offline, DNS, refused, or timed out.
final class NetworkFailure extends Failure {
  const new();
}

/// The request was cancelled on purpose (screen closed). Never shown.
final class CancelledFailure extends Failure {
  const new();
}

/// Anything that isn't a network or API error, e.g. a parsing bug.
final class UnknownFailure extends Failure {
  const new(this.error);

  final Object error;
}

/// The API answered with an error status. [messages] are the API's own
/// human-readable messages (Nest's `message` field), possibly empty.
sealed class ApiFailure extends Failure {
  const new(this.statusCode, this.messages);

  final int statusCode;
  final List<String> messages;

  /// The first API message, which is what the website shows.
  String? get message => messages.isEmpty ? null : messages.first;
}

/// 400 and any other 4xx without its own type (e.g. 413, 422).
final class BadRequestFailure extends ApiFailure {
  const new(super.statusCode, super.messages);
}

/// 401: wrong credentials, or a session that can no longer be refreshed.
final class UnauthorizedFailure extends ApiFailure {
  const new(List<String> messages) : super(401, messages);
}

/// 403: signed in, but not allowed (e.g. not an admin, uploads used up).
final class ForbiddenFailure extends ApiFailure {
  const new(List<String> messages) : super(403, messages);
}

/// 404.
final class NotFoundFailure extends ApiFailure {
  const new(List<String> messages) : super(404, messages);
}

/// 409: duplicate email, GTIN, SKU or brand name; claim already pending.
final class ConflictFailure extends ApiFailure {
  const new(List<String> messages) : super(409, messages);
}

/// 5xx.
final class ServerFailure extends ApiFailure {
  const new(super.statusCode, super.messages);
}

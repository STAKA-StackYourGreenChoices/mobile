import 'package:dio/dio.dart';

import 'package:staka/core/error/failure.dart';

/// Turns a [DioException] into a [Failure]. `DioException` never leaves the
/// data layer (guide §10.1).
Failure failureFromDioException(DioException error) {
  return switch (error.type) {
    DioExceptionType.cancel => const CancelledFailure(),
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError => const NetworkFailure(),
    DioExceptionType.badResponse => _fromResponse(error.response),
    DioExceptionType.badCertificate ||
    DioExceptionType.unknown => UnknownFailure(error.error ?? error),
  };
}

Failure _fromResponse(Response<Object?>? response) {
  final status = response?.statusCode ?? 0;
  final messages = apiMessages(response?.data);
  return switch (status) {
    401 => UnauthorizedFailure(messages),
    403 => ForbiddenFailure(messages),
    404 => NotFoundFailure(messages),
    409 => ConflictFailure(messages),
    429 => TooManyRequestsFailure(
      messages,
      retryAfter: _retryAfter(response?.headers.value('retry-after')),
    ),
    >= 500 => ServerFailure(status, messages),
    _ => BadRequestFailure(status, messages),
  };
}

/// `Retry-After` in seconds (the API's form); dates and junk are ignored.
Duration? _retryAfter(String? header) => switch (int.tryParse(header ?? '')) {
  final int seconds when seconds >= 0 => Duration(seconds: seconds),
  _ => null,
};

/// Reads Nest's error body: `{"message": "..."}` or `{"message": ["..."]}`.
List<String> apiMessages(Object? body) {
  if (body is! Map<String, Object?>) return const [];
  return switch (body['message']) {
    final String message => [message],
    final List<Object?> list => [for (final item in list) '$item'],
    _ => const [],
  };
}

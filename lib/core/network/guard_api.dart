import 'package:dio/dio.dart';

import 'package:staka/core/error/failure.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/api_error_parser.dart';

/// Runs an API call and returns a [Result] instead of throwing.
///
/// Every repository method wraps its datasource call in this, so no
/// exception (Dio or otherwise) crosses into the domain layer.
Future<Result<T>> guardApi<T>(Future<T> Function() call) async {
  try {
    return Ok(await call());
  } on DioException catch (error) {
    return Err(failureFromDioException(error));
  } on Object catch (error) {
    return Err(UnknownFailure(error));
  }
}

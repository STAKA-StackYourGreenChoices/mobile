import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staka/core/error/failure.dart';
import 'package:staka/core/network/api_error_parser.dart';

DioException _response(int status, [Object? body]) {
  final options = RequestOptions(path: '/x');
  return DioException.badResponse(
    statusCode: status,
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: status, data: body),
  );
}

void main() {
  group('failureFromDioException', () {
    test('maps each status to its failure type', () {
      expect(
        failureFromDioException(_response(401)),
        isA<UnauthorizedFailure>(),
      );
      expect(failureFromDioException(_response(403)), isA<ForbiddenFailure>());
      expect(failureFromDioException(_response(404)), isA<NotFoundFailure>());
      expect(failureFromDioException(_response(409)), isA<ConflictFailure>());
      expect(failureFromDioException(_response(503)), isA<ServerFailure>());
      expect(failureFromDioException(_response(400)), isA<BadRequestFailure>());
      expect(failureFromDioException(_response(413)), isA<BadRequestFailure>());
    });

    test('keeps the status code and the API messages', () {
      final failure = failureFromDioException(
        _response(400, {'message': 'Invalid GTIN check digit'}),
      );
      expect(failure, isA<BadRequestFailure>());
      failure as ApiFailure;
      expect(failure.statusCode, 400);
      expect(failure.message, 'Invalid GTIN check digit');
    });

    test('network problems become NetworkFailure', () {
      final options = RequestOptions(path: '/x');
      expect(
        failureFromDioException(
          DioException.connectionError(requestOptions: options, reason: 'x'),
        ),
        isA<NetworkFailure>(),
      );
      expect(
        failureFromDioException(
          DioException.receiveTimeout(
            requestOptions: options,
            timeout: Duration.zero,
          ),
        ),
        isA<NetworkFailure>(),
      );
    });

    test('a cancelled request becomes CancelledFailure', () {
      final error = DioException.requestCancelled(
        requestOptions: RequestOptions(path: '/x'),
        reason: null,
      );
      expect(failureFromDioException(error), isA<CancelledFailure>());
    });
  });

  group('apiMessages', () {
    test('reads a string or a list, ignores anything else', () {
      expect(apiMessages({'message': 'one'}), ['one']);
      expect(
        apiMessages({
          'message': ['one', 'two'],
        }),
        ['one', 'two'],
      );
      expect(apiMessages({'error': 'Bad Request'}), isEmpty);
      expect(apiMessages('plain text'), isEmpty);
      expect(apiMessages(null), isEmpty);
    });
  });
}

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';

part 'device_repository.g.dart';

/// This phone's push token on the account (V2-9).
abstract interface class DeviceRepository {
  /// Upserts: sending the same token again is fine.
  Future<Result<void>> register(String token);
  Future<Result<void>> unregister(String token);
}

@riverpod
DeviceRepository deviceRepository(Ref ref) =>
    ApiDeviceRepository(ref.watch(dioProvider));

class ApiDeviceRepository implements DeviceRepository {
  const new(this._dio);

  final Dio _dio;

  @override
  Future<Result<void>> register(String token) => guardApi(
    () => _dio.post<void>(
      '/me/devices',
      data: {'token': token, 'platform': 'ANDROID'},
    ),
  );

  @override
  Future<Result<void>> unregister(String token) => guardApi(
    () => _dio.delete<void>('/me/devices/${Uri.encodeComponent(token)}'),
  );
}

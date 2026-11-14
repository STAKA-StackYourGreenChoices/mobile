import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/error/result.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:staka/features/auth/data/mappers/auth_session_mapper.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';
import 'package:staka/features/auth/domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(AuthRemoteDataSource(ref.watch(dioProvider)));

class AuthRepositoryImpl implements AuthRepository {
  const new(this._remote);

  final AuthRemoteDataSource _remote;

  /// Emails are trimmed like the website's form values; passwords are sent
  /// exactly as typed.
  @override
  Future<Result<AuthSession>> login({
    required String email,
    required String password,
  }) => guardApi(() async {
    final response = await _remote.login(
      email: email.trim(),
      password: password,
    );
    return response.toDomain();
  });

  @override
  Future<Result<AuthSession>> register({
    required String name,
    required String email,
    required String password,
  }) => guardApi(() async {
    final response = await _remote.register(
      name: name.trim(),
      email: email.trim(),
      password: password,
    );
    return response.toDomain();
  });
}

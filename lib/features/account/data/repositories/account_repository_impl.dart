import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:staka/core/api_models/user_mapper.dart';
import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/core/network/dio_client.dart';
import 'package:staka/core/network/guard_api.dart';
import 'package:staka/features/account/data/datasources/account_remote_data_source.dart';
import 'package:staka/features/account/domain/repositories/account_repository.dart';
import 'package:staka/features/auth/data/mappers/otp_mapper.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';

part 'account_repository_impl.g.dart';

@riverpod
AccountRepository accountRepository(Ref ref) =>
    AccountRepositoryImpl(AccountRemoteDataSource(ref.watch(dioProvider)));

class AccountRepositoryImpl implements AccountRepository {
  const new(this._remote);

  final AccountRemoteDataSource _remote;

  @override
  Future<Result<OtpChallenge>> requestPhoneCode({required String phone}) =>
      guardApi(() async {
        final response = await _remote.requestPhoneCode(phone: phone);
        return response.toDomain(phone: phone);
      });

  @override
  Future<Result<User>> verifyPhone({
    required String challengeId,
    required String code,
  }) => guardApi(() async {
    final response = await _remote.verifyPhone(
      challengeId: challengeId,
      code: code,
    );
    return response.toDomain();
  });

  @override
  Future<Result<void>> removePhone() => guardApi(_remote.removePhone);

  /// Trimmed like every email the app sends.
  @override
  Future<Result<void>> addEmail({required String email}) =>
      guardApi(() => _remote.addEmail(email: email.trim()));

  /// Sent exactly as typed, like every password.
  @override
  Future<Result<void>> setPassword({required String newPassword}) =>
      guardApi(() => _remote.setPassword(newPassword: newPassword));
}

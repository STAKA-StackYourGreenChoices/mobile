import 'package:staka/core/error/result.dart';
import 'package:staka/core/models/user.dart';
import 'package:staka/features/account/domain/repositories/account_repository.dart';
import 'package:staka/features/auth/domain/models/otp_challenge.dart';

/// Answers from scripts and records what it was asked: `codes` for phone
/// codes, `verified` for the code checks, `requests` for remove phone, add
/// email and set password (in the order the test makes them).
class FakeAccountRepository implements AccountRepository {
  new({
    List<Result<OtpChallenge>> codes = const [],
    List<Result<User>> verified = const [],
    List<Result<void>> requests = const [],
  }) : _codes = [...codes],
       _verified = [...verified],
       _requests = [...requests];

  final List<Result<OtpChallenge>> _codes;
  final List<Result<User>> _verified;
  final List<Result<void>> _requests;
  final List<Map<String, String>> calls = [];

  @override
  Future<Result<OtpChallenge>> requestPhoneCode({required String phone}) async {
    calls.add({'call': 'phoneCode', 'phone': phone});
    return _codes.removeAt(0);
  }

  @override
  Future<Result<User>> verifyPhone({
    required String challengeId,
    required String code,
  }) async {
    calls.add({
      'call': 'verifyPhone',
      'challengeId': challengeId,
      'code': code,
    });
    return _verified.removeAt(0);
  }

  @override
  Future<Result<void>> removePhone() async {
    calls.add({'call': 'removePhone'});
    return _requests.removeAt(0);
  }

  @override
  Future<Result<void>> addEmail({required String email}) async {
    calls.add({'call': 'addEmail', 'email': email});
    return _requests.removeAt(0);
  }

  @override
  Future<Result<void>> setPassword({required String newPassword}) async {
    calls.add({'call': 'setPassword', 'newPassword': newPassword});
    return _requests.removeAt(0);
  }
}

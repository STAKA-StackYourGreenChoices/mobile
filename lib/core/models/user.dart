import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

enum Role { user, admin }

/// The signed-in person, as `GET /auth/me` describes them.
@freezed
abstract class User with _$User {
  const factory({
    required String id,
    required String email,
    required String name,
    required Role role,
    required bool emailVerified,
  }) = _User;

  const new _();

  bool get isAdmin => role == Role.admin;

  /// "Ada" from "Ada Lovelace", as the website greets people.
  String get firstName => name.trim().split(' ').first;
}

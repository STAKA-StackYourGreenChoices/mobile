import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

enum Role { user, admin }

/// The signed-in person, as `GET /auth/me` describes them.
///
/// Since V2 an account may have only a phone number (`email` null) and no
/// password (`hasPassword` false), when it was made with a text-message code.
@freezed
abstract class User with _$User {
  const factory({
    required String id,
    required String? email,
    required String name,
    required Role role,
    required bool emailVerified,
    String? phone,
    @Default(false) bool phoneVerified,
    @Default(true) bool hasPassword,
  }) = _User;

  const new _();

  bool get isAdmin => role == Role.admin;

  /// "Ada" from "Ada Lovelace", as the website greets people.
  String get firstName => name.trim().split(' ').first;
}

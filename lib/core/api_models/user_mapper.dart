import 'package:staka/core/api_models/user_dto.dart';
import 'package:staka/core/models/user.dart';

extension UserDtoMapper on UserDto {
  /// An unknown role is treated as a shopper: the admin UI only appears for
  /// an explicit `ADMIN`, and the API checks the role on every call anyway.
  User toDomain() => User(
    id: id,
    email: email,
    name: name,
    role: role == 'ADMIN' ? Role.admin : Role.user,
    emailVerified: emailVerified,
  );
}

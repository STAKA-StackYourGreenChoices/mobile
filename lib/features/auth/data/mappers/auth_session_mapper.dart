import 'package:staka/core/api_models/auth_response_dto.dart';
import 'package:staka/core/api_models/user_mapper.dart';
import 'package:staka/core/auth/auth_tokens.dart';
import 'package:staka/features/auth/domain/models/auth_session.dart';

extension AuthResponseMapper on AuthResponseDto {
  AuthSession toDomain() =>
      AuthSession(tokens: AuthTokens.fromResponse(this), user: user.toDomain());
}

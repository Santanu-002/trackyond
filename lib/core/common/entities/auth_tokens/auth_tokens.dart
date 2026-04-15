import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';

@freezed
sealed class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
    required String accessExpireAt,
    required String refreshExpireAt,
    required String tokenIssuedAt,
  }) = _AuthTokens;
}

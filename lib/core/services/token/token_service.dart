import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';

abstract interface class TokenService {
  Future<void> saveTokens(AuthTokens tokens);

  Future<String?> getAccessToken();

  Future<String?> getAccessTokenExpireAt();

  Future<bool> isAccessTokenAboutToExpired();

  Future<String?> getRefreshToken();

  Future<bool> isRefreshTokenExpired();

  Future<String?> getRefreshTokenExpireAt();

  Future<String?> getTokenIssuedAt();

  Future<void> clearTokens();
}

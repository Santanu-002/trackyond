import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/services/token/token_service.dart';

class TokenServiceImpl implements TokenService {
  final FlutterSecureStorage _storage;

  TokenServiceImpl(this._storage);

  static final _keys = _TokenKeys();

  final _lock = Lock();

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await _lock.synchronized(() async {
      final existingIssuedAt = await _storage.read(key: _keys.tokenIssuedAt);

      // If existing token exists → compare timestamps
      if (existingIssuedAt != null) {
        try {
          final existing = DateTime.parse(existingIssuedAt);
          final incoming = DateTime.parse(tokens.tokenIssuedAt);

          // If incoming is older → ignore
          if (incoming.isBefore(existing)) {
            return;
          }
        } catch (_) {
          // If parsing fails, fallback to overwrite
        }
      }

      // Save tokens
      await Future.wait([
        _storage.write(key: _keys.accessToken, value: tokens.accessToken),
        _storage.write(key: _keys.refreshToken, value: tokens.refreshToken),
        _storage.write(key: _keys.accessExpireAt, value: tokens.accessExpireAt),
        _storage.write(
          key: _keys.refreshExpireAt,
          value: tokens.refreshExpireAt,
        ),
        _storage.write(key: _keys.tokenIssuedAt, value: tokens.tokenIssuedAt),
      ]);
    });
  }

  // ------------------ GETTERS ------------------

  @override
  Future<String?> getAccessToken() {
    return _storage.read(key: _keys.accessToken);
  }

  @override
  Future<String?> getAccessTokenExpireAt() {
    return _storage.read(key: _keys.accessExpireAt);
  }

  @override
  Future<String?> getRefreshToken() {
    return _storage.read(key: _keys.refreshToken);
  }

  @override
  Future<String?> getRefreshTokenExpireAt() {
    return _storage.read(key: _keys.refreshExpireAt);
  }

  @override
  Future<String?> getTokenIssuedAt() {
    return _storage.read(key: _keys.tokenIssuedAt);
  }

  // ------------------ EXPIRY ------------------

  @override
  Future<bool> isAccessTokenAboutToExpired() async {
    final expireAt = await _storage.read(key: _keys.accessExpireAt);

    if (expireAt == null) return true;

    try {
      final expiry = DateTime.parse(expireAt);
      final now = DateTime.now().toUtc();

      final remaining =
          expiry.millisecondsSinceEpoch - now.millisecondsSinceEpoch;

      return remaining < 10000;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<bool> isRefreshTokenExpired() async {
    final expireAt = await _storage.read(key: _keys.refreshExpireAt);

    if (expireAt == null) return true;

    try {
      final expiry = DateTime.parse(expireAt);
      final now = DateTime.now().toUtc();

      return now.isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  // ------------------ CLEAR ------------------

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keys.accessToken),
      _storage.delete(key: _keys.refreshToken),
      _storage.delete(key: _keys.accessExpireAt),
      _storage.delete(key: _keys.refreshExpireAt),
      _storage.delete(key: _keys.tokenIssuedAt),
    ]);
  }
}

class _TokenKeys {
  final accessToken = 'access_token';
  final refreshToken = 'refresh_token';
  final accessExpireAt = 'access_token_expire_at';
  final refreshExpireAt = 'refresh_token_expire_at';
  final tokenIssuedAt = 'token_issued_at';
}

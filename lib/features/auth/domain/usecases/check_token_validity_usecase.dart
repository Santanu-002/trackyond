import 'package:trackyond/core/services/token/token_service.dart';

class CheckTokenValidityUseCase {
  final TokenService _tokenService;

  CheckTokenValidityUseCase(this._tokenService);

  Future<bool> isRefreshValid() async {
    final isRefreshExpired = await _tokenService.isRefreshTokenExpired();
    return !isRefreshExpired;
  }
}

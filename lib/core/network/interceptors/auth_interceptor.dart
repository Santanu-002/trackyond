import 'package:dio/dio.dart';
import 'package:synchronized/synchronized.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/api/request_extras.dart';
import 'package:trackyond/core/network/interceptors/platform_info_interceptor.dart';
import 'package:trackyond/core/services/device_header/platform_info_service.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService tokenService;
  final PlatformInfoService platformInfoService;
  final UserService userService;

  final Lock _refreshLock = Lock();
  Dio? _refreshDio;

  AuthInterceptor(
    this.tokenService,
    this.platformInfoService,
    this.userService,
  );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = options.extra[RequestExtras.isPublic] ?? false;

    if (!isPublic) {
      // 1. Try to get role from RequestExtras (as an override)
      // 2. If not found, get from UserService
      final String? roleOverride = options.extra[RequestExtras.userRole];
      final UserRole? currentUserRole = userService.getUserRole();

      final UserRole? role = roleOverride != null
          ? UserRole.fromString(roleOverride)
          : currentUserRole;

      if (role == null) {
        throw StateError(
          'User role is missing for non-public request: ${options.path}. '
          'Either the user is not logged in (UserService role is null) '
          'or a role override was not provided in RequestExtras.',
        );
      }

      await _refreshLock.synchronized(() async {
        final isExpired = await tokenService.isAccessTokenAboutToExpired();
        if (isExpired) await _refreshToken(role: role);
      });

      final accessToken = await tokenService.getAccessToken();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    handler.next(options);
  }

  Future<void> _refreshToken({required UserRole role}) async {
    try {
      _refreshDio ??= Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          contentType: 'application/json',
        ),
      )..interceptors.add(PlatformInfoInterceptor(platformInfoService));

      final refreshToken = await tokenService.getRefreshToken();
      final accessToken = await tokenService.getAccessToken();

      if (refreshToken == null || refreshToken.isEmpty) return;

      final refreshEndpoint = role == UserRole.owner
          ? ApiEndpoints.admin.auth.refresh
          : ApiEndpoints.employee.auth.refresh;

      final response = await _refreshDio!.post(
        refreshEndpoint,
        data: null, // No body
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'x-refresh-token': refreshToken,
          },
          extra: {RequestExtras.isPublic: true},
        ),
      );

      final data = response.data?['data'];

      if (data != null) {
        await tokenService.saveTokens(
          AuthTokens(
            accessToken: data['accessToken'] ?? '',
            refreshToken: data['refreshToken'] ?? '',
            accessExpireAt: data['accessExpireAt'] ?? '',
            refreshExpireAt: data['refreshExpireAt'] ?? '',
            tokenIssuedAt: data['tokenIssuedAt'] ?? '',
          ),
        );
      }
    } catch (e) {
      await tokenService.clearTokens();
    }
  }
}

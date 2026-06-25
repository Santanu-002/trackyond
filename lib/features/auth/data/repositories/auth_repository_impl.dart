import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/token/token_service.dart';
import 'package:trackyond/core/services/user/user_service.dart';
import 'package:trackyond/features/auth/data/datasources/auth_datasource.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';
import 'package:trackyond/features/auth/domain/entities/verify_otp_entity.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource _dataSource;
  final TokenService _tokenService;
  final UserService _userService;
  final WebSocketService _webSocketService;

  AuthRepositoryImpl(
    this._dataSource,
    this._tokenService,
    this._userService,
    this._webSocketService,
  );

  @override
  Future<Either<AppFailure, SendOtpResponseEntity>> sendOtp({
    required String phone,
    required UserRole role,
  }) async {
    final ApiResponse response = await _dataSource.sendOtp(
      phone: phone,
      role: role,
    );
    return response.when(
      success: (_, message, data) {
        if (message.toLowerCase().contains('access denied')) {
          return Left(AccessDeniedFailure(message));
        }
        if (data != null) return Right(data);
        return Left(ServerFailure(message));
      },
      error: (_, message, _, _) {
        if (message.toLowerCase().contains('access denied')) {
          return Left(AccessDeniedFailure(message));
        }
        return Left(ServerFailure(message));
      },
    );
  }

  @override
  Future<Either<AppFailure, VerifyOtpEntity>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  }) async {
    final response = await _dataSource.verifyOtp(
      phone: phone,
      otpId: otpId,
      otp: otp,
      role: role,
    );
    return await response.when(
      success: (_, message, data) async {
        if (message.toLowerCase().contains('access denied')) {
          return Left(AccessDeniedFailure(message));
        }
        if (data != null) {
          await _tokenService.saveTokens(data.tokens);
          final userModel = data.getUser(role);
          await Future.wait([
            _userService.setUser(userModel),
            _userService.saveUserRole(role),
            if (data.profile != null) _userService.setProfile(data.profile!),
            if (data.company != null) _userService.setCompany(data.company!),
          ]);

          return Right(
            VerifyOtpEntity(
              user: userModel,
              isNewUser: data.isNewUser,
              role: role,
              profile: data.profile,
              company: data.company,
            ),
          );
        }
        return Left(ServerFailure(message));
      },
      error: (_, message, _, _) async {
        if (message.toLowerCase().contains('access denied')) {
          return Left(AccessDeniedFailure(message));
        }
        return Left(ServerFailure(message));
      },
    );
  }

  @override
  Future<Either<AppFailure, User?>> getAuthenticatedUser() async {
    return Right(_userService.getUser());
  }

  @override
  Future<Either<AppFailure, UserRole?>> getUserRole() async {
    return Right(_userService.getUserRole());
  }

  @override
  Future<Either<AppFailure, MemberProfile?>> getMemberProfile() async {
    final localProfile = _userService.getProfile();
    final role = _userService.getUserRole();

    if (localProfile == null && role != null) {
      final response = await _dataSource.getProfile(role: role);
      return response.when(
        success: (_, _, data) {
          if (data?.profile != null) {
            _userService.setProfile(data!.profile!);
            if (data.company != null) {
              _userService.setCompany(data.company!);
            }
            return Right(data.profile!);
          }
          return const Right(null);
        },
        error: (_, message, _, _) => Left(ServerFailure(message)),
      );
    }

    // If local exists, return it immediately but refresh in background
    if (localProfile != null && role != null) {
      _dataSource.getProfile(role: role).then((response) {
        response.when(
          success: (_, _, data) {
            if (data?.profile != null) {
              _userService.setProfile(data!.profile!);
              if (data.company != null) {
                _userService.setCompany(data.company!);
              }
            }
          },
          error: (_, _, _, _) {},
        );
      });
    }

    return Right(localProfile);
  }

  @override
  Future<Either<AppFailure, CompanyEntity?>> getCompany() async {
    final localCompany = _userService.getCompany();
    final role = _userService.getUserRole();

    if (localCompany == null && role != null) {
      final response = await _dataSource.getProfile(role: role);
      return response.when(
        success: (_, _, data) {
          if (data?.company != null) {
            _userService.setCompany(data!.company!);
            if (data.profile != null) {
              _userService.setProfile(data.profile!);
            }
            return Right(data.company!);
          }
          return const Right(null);
        },
        error: (_, message, _, _) => Left(ServerFailure(message)),
      );
    }
    return Right(localCompany);
  }

  @override
  Future<Either<AppFailure, bool>> checkAuthStatus() async {
    return Right(_userService.isLoggedIn);
  }

  @override
  Future<Either<AppFailure, bool>> checkOnboardingStatus() async {
    return Right(_userService.hasCompletedAddTeamMember);
  }

  @override
  Future<Either<AppFailure, bool>> checkTokenValidity() async {
    final isRefreshExpired = await _tokenService.isRefreshTokenExpired();
    return Right(!isRefreshExpired);
  }

  @override
  Future<Either<AppFailure, bool>> refreshAuthToken() async {
    final role = _userService.getUserRole();
    if (role == null) {
      return Left(ServerFailure('User role is missing'));
    }

    final accessToken = await _tokenService.getAccessToken();
    final refreshToken = await _tokenService.getRefreshToken();
    if (accessToken == null || refreshToken == null) {
      return Left(ServerFailure('Tokens are missing'));
    }

    final response = await _dataSource.refreshAuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
    );

    return response.fold(
      (error) => Left(ServerFailure(error.message)),
      (data) async {
        if (data != null) {
          await _tokenService.saveTokens(data);
          return const Right(true);
        }
        return Left(ServerFailure('Response data was null'));
      },
    );
  }

  @override
  Future<Either<AppFailure, Unit>> logout() async {
    final role = _userService.getUserRole();

    if (role != null) {
      await _dataSource.logout(role: role);
    }

    await _tokenService.clearTokens();
    await _userService.clear();

    return const Right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> connectWebSocket() async {
    try {
      if (Get.isRegistered<WebSocketService>()) {
        _webSocketService.connect();
      }
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> disconnectWebSocket() async {
    try {
      if (Get.isRegistered<WebSocketService>()) {
        await _webSocketService.disconnect();
      }
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

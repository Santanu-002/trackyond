import 'package:fpdart/fpdart.dart';
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

  AuthRepositoryImpl(this._dataSource, this._tokenService, this._userService);

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
        if (data != null) return Right(data.toEntity());
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
    return response.when(
      success: (_, message, data) {
        if (message.toLowerCase().contains('access denied')) {
          return Left(AccessDeniedFailure(message));
        }
        if (data != null) {
          _tokenService.saveTokens(data.tokens);
          final userModel = data.getUser(role);
          _userService.setUser(userModel);
          _userService.saveUserRole(role);

          if (data.profile != null) {
            _userService.setProfile(data.profile!);
          }
          if (data.company != null) {
            _userService.setCompany(data.company!);
          }

          return Right(
            VerifyOtpEntity(
              user: userModel.toEntity(),
              isNewUser: data.isNewUser,
              role: role,
              profile: data.profile?.toEntity(),
              company: data.company?.toEntity(),
            ),
          );
        }
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
  Future<Either<AppFailure, User?>> getAuthenticatedUser() async {
    return Right(_userService.getUser()?.toEntity());
  }

  @override
  Future<Either<AppFailure, UserRole?>> getUserRole() async {
    return Right(_userService.getUserRole());
  }

  @override
  Future<Either<AppFailure, MemberProfile?>> getMemberProfile() async {
    return Right(_userService.getProfile()?.toEntity());
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
  Future<Either<AppFailure, Unit>> logout() async {
    final role = _userService.getUserRole();

    if (role != null) {
      await _dataSource.logout(role: role);
    }

    await _tokenService.clearTokens();
    await _userService.clear();

    return const Right(unit);
  }
}

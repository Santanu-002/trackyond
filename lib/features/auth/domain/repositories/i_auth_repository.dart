import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/company/company_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/entities/user/user.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';
import 'package:trackyond/features/auth/domain/entities/verify_otp_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<AppFailure, SendOtpResponseEntity>> sendOtp({
    required String phone,
    required UserRole role,
  });

  Future<Either<AppFailure, VerifyOtpEntity>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  });

  /// Session state methods for UseCases
  Future<Either<AppFailure, User?>> getAuthenticatedUser();
  Future<Either<AppFailure, UserRole?>> getUserRole();
  Future<Either<AppFailure, MemberProfile?>> getMemberProfile();
  Future<Either<AppFailure, CompanyEntity?>> getCompany();
  Future<Either<AppFailure, bool>> checkAuthStatus();

  Future<Either<AppFailure, bool>> checkOnboardingStatus();

  Future<Either<AppFailure, bool>> checkTokenValidity();

  Future<Either<AppFailure, Unit>> logout();
}

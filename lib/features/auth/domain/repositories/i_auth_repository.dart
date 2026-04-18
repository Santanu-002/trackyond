import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<AppFailure, SendOtpResponseEntity>> sendOtp({
    required String phone,
    required UserRole role,
  });

  Future<Either<AppFailure, AuthTokens>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  });
}

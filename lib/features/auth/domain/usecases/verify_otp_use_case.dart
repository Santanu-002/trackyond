import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class VerifyOtpUseCase implements BaseUseCase<AuthTokens, VerifyOtpParams> {
  final IAuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthTokens>> call(VerifyOtpParams params) async {
    return await _repository.verifyOtp(
      phone: params.phone,
      otpId: params.otpId,
      otp: params.otp,
      role: params.role,
    );
  }
}

class VerifyOtpParams {
  final String phone;
  final String otpId;
  final String otp;
  final UserRole role;

  VerifyOtpParams({
    required this.phone,
    required this.otpId,
    required this.otp,
    required this.role,
  });
}

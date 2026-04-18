import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/usecase/usecase.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class SendOtpUseCase
    implements BaseUseCase<SendOtpResponseEntity, SendOtpParams> {
  final IAuthRepository _repository;

  SendOtpUseCase(this._repository);

  @override
  Future<Either<AppFailure, SendOtpResponseEntity>> call(
    SendOtpParams params,
  ) async {
    return await _repository.sendOtp(phone: params.phone, role: params.role);
  }
}

class SendOtpParams {
  final String phone;
  final UserRole role;

  SendOtpParams({required this.phone, required this.role});
}

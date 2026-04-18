import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/auth/data/datasources/auth_datasource.dart';
import 'package:trackyond/features/auth/domain/entities/send_otp_response_entity.dart';
import 'package:trackyond/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, SendOtpResponseEntity>> sendOtp({
    required String phone,
    required UserRole role,
  }) async {
    try {
      final response = await _dataSource.sendOtp(phone: phone, role: role);
      return response.when(
        success: (_, message, data) {
          if (data != null) return Right(data.toEntity());
          return Left(ServerFailure(message));
        },
        error: (_, message, _, _) => Left(ServerFailure(message)),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, AuthTokens>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  }) async {
    try {
      final response = await _dataSource.verifyOtp(
        phone: phone,
        otpId: otpId,
        otp: otp,
        role: role,
      );
      return response.when(
        success: (_, message, data) {
          if (data != null) return Right(data);
          return Left(ServerFailure(message));
        },
        error: (_, message, _, _) => Left(ServerFailure(message)),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

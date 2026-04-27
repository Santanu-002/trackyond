import 'package:dio/dio.dart';
import 'package:trackyond/core/common/enums/user_role.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/common/mixins/base_remote_data_source/base_remote_data_source.dart';
import 'package:trackyond/core/network/api/request_extras.dart';
import 'package:trackyond/features/auth/data/models/send_otp/send_otp_response_model.dart';
import 'package:trackyond/features/auth/data/models/verify_otp_response_model.dart';

abstract interface class IAuthDataSource {
  Future<ApiResponse<SendOtpResponseModel>> sendOtp({
    required String phone,
    required UserRole role,
  });

  Future<ApiResponse<VerifyOtpResponseModel>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  });

  Future<ApiResponse<void>> logout({required UserRole role});
}

class AuthDataSourceImpl with BaseRemoteDataSource implements IAuthDataSource {
  final Dio _dio;

  AuthDataSourceImpl(this._dio);

  @override
  Future<ApiResponse<SendOtpResponseModel>> sendOtp({
    required String phone,
    required UserRole role,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.auth.sendOtp
        : ApiEndpoints.employee.auth.sendOtp;

    return performApiRequest(
      _dio.post(
        endpoint,
        data: {'phone': phone},
        options: Options(extra: {RequestExtras.isPublic: true}),
      ),
      (json) => SendOtpResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<VerifyOtpResponseModel>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.auth.verifyOtp
        : ApiEndpoints.employee.auth.verifyOtp;

    return performApiRequest(
      _dio.post(
        endpoint,
        data: {'phone': phone, 'otpId': otpId, 'otp': otp},
        options: Options(extra: {RequestExtras.isPublic: true}),
      ),
      (json) => role == UserRole.owner
          ? VerifyOtpResponseModel.fromOwnerJson(json as Map<String, dynamic>)
          : VerifyOtpResponseModel.fromMemberJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<void>> logout({required UserRole role}) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.auth.logout
        : ApiEndpoints.employee.auth.logout;

    return performApiRequest(
      _dio.post(endpoint),
      (_) {},
    );
  }
}

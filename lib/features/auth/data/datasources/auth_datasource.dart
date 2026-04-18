import 'package:dio/dio.dart';
import 'package:trackyond/core/common/entities/user/user_role.dart';
import 'package:trackyond/core/common/models/api_response.dart';
import 'package:trackyond/core/common/models/auth_tokens/auth_tokens.dart';
import 'package:trackyond/core/exception/api_exception.dart';
import 'package:trackyond/core/network/api/api_endpoints.dart';
import 'package:trackyond/core/network/api/request_extras.dart';
import 'package:trackyond/features/auth/data/models/send_otp_response_model.dart';

abstract interface class IAuthDataSource {
  Future<ApiResponse<SendOtpResponseModel>> sendOtp({
    required String phone,
    required UserRole role,
  });

  Future<ApiResponse<AuthTokens>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  });
}

class AuthDataSourceImpl implements IAuthDataSource {
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

    try {
      final response = await _dio.post(
        endpoint,
        data: {'phone': phone},
        options: Options(extra: {RequestExtras.isPublic: true}),
      );

      return ApiResponse<SendOtpResponseModel>.fromJson(
        response.data,
        (json) => SendOtpResponseModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        final apiEx = e.error as ApiException;
        return ApiResponse.error(
          success: false,
          message: apiEx.message,
          statusCode: apiEx.statusCode,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ApiResponse<AuthTokens>> verifyOtp({
    required String phone,
    required String otpId,
    required String otp,
    required UserRole role,
  }) async {
    final endpoint = role == UserRole.owner
        ? ApiEndpoints.admin.auth.verifyOtp
        : ApiEndpoints.employee.auth.verifyOtp;

    try {
      final response = await _dio.post(
        endpoint,
        data: {'phone': phone, 'otpId': otpId, 'otp': otp},
        options: Options(extra: {RequestExtras.isPublic: true}),
      );

      return ApiResponse<AuthTokens>.fromJson(
        response.data,
        (json) => AuthTokens.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        final apiEx = e.error as ApiException;
        return ApiResponse.error(
          success: false,
          message: apiEx.message,
          statusCode: apiEx.statusCode,
        );
      }
      rethrow;
    }
  }
}

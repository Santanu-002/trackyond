import 'package:dio/dio.dart';
import 'package:trackyond/core/common/models/api_response/api_response.dart';
import 'package:trackyond/core/exception/api_exception.dart';

mixin BaseRemoteDataSource {
  /// A wrapper for Dio requests that handles mapping [DioException] to [ApiResponse.error]
  /// using the [ApiException] produced by the [NetworkErrorInterceptor].
  Future<ApiResponse<T>> performApiRequest<T>(
    Future<Response> call,
    T Function(Object? json) fromJsonT,
  ) async {
    try {
      final response = await call;
      return ApiResponse<T>.fromJson(
        response.data as Map<String, dynamic>,
        fromJsonT,
      );
    } on DioException catch (e) {
      // The NetworkErrorInterceptor puts an ApiException into DioException.error
      if (e.error is ApiException) {
        final apiEx = e.error as ApiException;
        return ApiResponse.error(
          success: false,
          message: apiEx.message,
          statusCode: apiEx.statusCode,
          data: apiEx.data,
        );
      }

      return ApiResponse.error(
        success: false,
        message: e.message ?? 'Something went wrong. Please try again later.',
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      return ApiResponse.error(success: false, message: e.toString());
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      debugPrint('================================================');
      debugPrint('[DioException] API Request Failed:');
      debugPrint('Path: ${e.requestOptions.path}');
      debugPrint('Method: ${e.requestOptions.method}');
      debugPrint('Status Code: ${e.response?.statusCode}');
      debugPrint('DioException Type: ${e.type}');
      debugPrint('Message: ${e.message}');
      debugPrint('Error: ${e.error}');
      if (e.response?.data != null) {
        debugPrint('Response Data: ${e.response?.data}');
      }
      debugPrint('================================================');

      final statusCode = e.response?.statusCode;
      String friendlyMessage = 'Something went wrong. Please try again later.';

      // Check for connection/network issues first
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        friendlyMessage = 'Connection timed out. Please check your internet connection.';
      } else if (e.type == DioExceptionType.connectionError) {
        friendlyMessage = 'No internet connection. Please check your network connection.';
      } else if (statusCode != null) {
        if (statusCode == 404) {
          friendlyMessage = 'The requested resource was not found.';
        } else if (statusCode == 429) {
          friendlyMessage = 'Too many requests. Please try again later.';
        } else if (statusCode >= 500) {
          friendlyMessage = 'Internal server error. Please try again later.';
        } else if (statusCode == 401) {
          friendlyMessage = 'Session expired. Please log in again.';
        } else if (statusCode == 403) {
          friendlyMessage = 'Access denied.';
        } else {
          // For other responses (like 400 Bad Request), try using the API message if available
          if (e.error is ApiException) {
            friendlyMessage = (e.error as ApiException).message;
          } else if (e.response?.data is Map) {
            final data = e.response?.data as Map;
            friendlyMessage = data['message'] ?? friendlyMessage;
          }
        }
      }

      return ApiResponse.error(
        success: false,
        message: friendlyMessage,
        statusCode: statusCode,
      );
    } catch (e, stack) {
      debugPrint('================================================');
      debugPrint('[GeneralException] API Request Failed:');
      debugPrint('Exception: $e');
      debugPrint('Stack Trace:\n$stack');
      debugPrint('================================================');

      return ApiResponse.error(
        success: false,
        message: 'Something went wrong. Please try again later.',
      );
    }
  }
}

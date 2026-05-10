import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';

@Freezed(genericArgumentFactories: true)
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({
    required bool success,
    required String message,
    T? data,
  }) = ApiResponseSuccess<T>;

  const factory ApiResponse.error({
    required bool success,
    required String message,
    T? data,
    int? statusCode,
  }) = ApiResponseError<T>;

  const ApiResponse._();

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final success = json['success'] as bool? ?? false;
    final message = json['message'] as String? ?? (success ? 'Success' : 'Something went wrong');
    final data = json['data'];

    if (success) {
      return ApiResponse<T>.success(
        success: true,
        message: message,
        data: data != null ? fromJsonT(data) : null,
      );
    } else {
      return ApiResponse<T>.error(
        success: false,
        message: message,
        statusCode: json['statusCode'] as int?,
      );
    }
  }

  R fold<R>(
    R Function(ApiResponseError<T> error) onError,
    R Function(T? data) onSuccess,
  ) {
    return when(
      success: (success, message, data) => onSuccess(data),
      error: (success, message, data, statusCode) => onError(this as ApiResponseError<T>),
    );
  }
}

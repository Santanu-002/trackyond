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
        // Error payloads are never typed models — skip deserialization.
        statusCode: json['statusCode'] as int?,
      );
    }
  }
}

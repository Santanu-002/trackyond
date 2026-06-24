import 'package:freezed_annotation/freezed_annotation.dart';

part 'queue_response.freezed.dart';
part 'queue_response.g.dart';

@freezed
sealed class QueueResponse with _$QueueResponse {
  const factory QueueResponse({
    required String action,
    required bool success,
    String? error,
    Map<String, dynamic>? data,
    String? requestId,
  }) = _QueueResponse;

  const QueueResponse._();

  factory QueueResponse.fromWebSocketFrame(String action, Map<String, dynamic> frameData) {
    final status = frameData['status'] as String?;
    final success = status == 'success' || frameData['success'] == true || status != 'error';
    final error = frameData['error'] as String? ?? frameData['message'] as String?;
    final nestedData = frameData['data'] as Map<String, dynamic>? ?? frameData;
    final requestId = frameData['requestId'] as String? ?? frameData['localId'] as String?;

    return QueueResponse(
      action: action,
      success: success,
      error: error,
      data: nestedData,
      requestId: requestId,
    );
  }

  factory QueueResponse.fromJson(Map<String, dynamic> json) => _$QueueResponseFromJson(json);
}

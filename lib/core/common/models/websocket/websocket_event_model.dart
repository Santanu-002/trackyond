import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';

part 'websocket_event_model.freezed.dart';

@Freezed(genericArgumentFactories: true)
sealed class WebSocketEventModel<T> with _$WebSocketEventModel<T> {
  const factory WebSocketEventModel({
    required WebSocketEvents event,
    required dynamic type,
    required Map<String, dynamic>? headers,
    required T? data,
  }) = _WebSocketEventModel<T>;

  const WebSocketEventModel._();

  factory WebSocketEventModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final eventStr = json['event'] as String;
    final typeStr = json['type'] as String;
    final headers = json['headers'] as Map<String, dynamic>?;
    final dataJson = json['data'];

    final event = WebSocketEvents.values.firstWhere(
      (e) => e.value == eventStr,
      orElse: () => throw ArgumentError('Unknown WebSocketEvent: $eventStr'),
    );

    dynamic type;
    switch (event) {
      case WebSocketEvents.connection:
        type = WebSocketConnectionType.values.firstWhere(
          (t) => t.value == typeStr,
          orElse: () => throw ArgumentError('Unknown ConnectionType: $typeStr'),
        );
        break;
      case WebSocketEvents.heartbeat:
        type = WebSocketHeartbeatType.values.firstWhere(
          (t) => t.value == typeStr,
          orElse: () => throw ArgumentError('Unknown HeartbeatType: $typeStr'),
        );
        break;
      case WebSocketEvents.token:
        type = WebSocketTokenType.values.firstWhere(
          (t) => t.value == typeStr,
          orElse: () => throw ArgumentError('Unknown TokenType: $typeStr'),
        );
        break;
      case WebSocketEvents.message:
        type = WebSocketMessageType.values.firstWhere(
          (t) => t.value == typeStr,
          orElse: () => throw ArgumentError('Unknown MessageType: $typeStr'),
        );
        break;
      case WebSocketEvents.error:
        type = WebSocketErrorType.values.firstWhere(
          (t) => t.value == typeStr,
          orElse: () => throw ArgumentError('Unknown ErrorType: $typeStr'),
        );
        break;
    }

    return WebSocketEventModel<T>(
      event: event,
      type: type,
      headers: headers,
      data: dataJson != null ? fromJsonT(dataJson) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    final typeStr = type is WebSocketConnectionType
        ? (type as WebSocketConnectionType).value
        : type is WebSocketHeartbeatType
            ? (type as WebSocketHeartbeatType).value
            : type is WebSocketTokenType
                ? (type as WebSocketTokenType).value
                : type is WebSocketMessageType
                    ? (type as WebSocketMessageType).value
                    : type is WebSocketErrorType
                        ? (type as WebSocketErrorType).value
                        : type.toString();

    return {
      'event': event.value,
      'type': typeStr,
      'headers': headers,
      'data': data != null ? toJsonT(data as T) : null,
    };
  }
}

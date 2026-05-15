import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'dart:convert';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
sealed class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    String? dataPayload,
    required String status,
    @JsonKey(name: 'read') required bool isRead,
    @JsonKey(name: 'seen') required bool isSeen,
    required DateTime createdAt,
  }) = _NotificationModel;

  const NotificationModel._();

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  NotificationEntity toEntity() {
    Map<String, dynamic>? data;
    if (dataPayload != null) {
      try {
        data = jsonDecode(dataPayload!);
      } catch (_) {}
    }

    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      data: data,
      isRead: isRead,
      isSeen: isSeen,
    );
  }
}

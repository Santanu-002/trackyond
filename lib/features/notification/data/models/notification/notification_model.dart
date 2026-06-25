import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/notification/domain/entities/notification_entity.dart';
import 'dart:convert';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
sealed class NotificationModel with _$NotificationModel implements NotificationEntity {
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

  @override
  Map<String, dynamic>? get data {
    if (dataPayload != null) {
      try {
        return jsonDecode(dataPayload!);
      } catch (_) {}
    }
    return null;
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, data, isRead, isSeen];

  @override
  bool? get stringify => null;

  @override
  NotificationEntity copyWithEntity({
    String? id,
    String? title,
    String? body,
    DateTime? createdAt,
    Map<String, dynamic>? data,
    bool? isRead,
    bool? isSeen,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}

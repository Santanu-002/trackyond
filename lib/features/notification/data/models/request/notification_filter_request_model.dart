import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/features/notification/domain/entities/notification_filter_options.dart';

part 'notification_filter_request_model.freezed.dart';
part 'notification_filter_request_model.g.dart';

@freezed
sealed class NotificationFilterRequestModel with _$NotificationFilterRequestModel {
  const factory NotificationFilterRequestModel({
    required int limit,
    required int offset,
    @JsonKey(includeIfNull: false) bool? isRead,
    required bool isNewestFirst,
  }) = _NotificationFilterRequestModel;

  factory NotificationFilterRequestModel.fromEntity(NotificationFilterOptions entity) {
    return NotificationFilterRequestModel(
      limit: entity.limit,
      offset: entity.offset,
      isRead: entity.isRead,
      isNewestFirst: entity.isNewestFirst,
    );
  }

  factory NotificationFilterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationFilterRequestModelFromJson(json);
}

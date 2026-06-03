import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/utils/json_converters.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

part 'job_chat_message_model.freezed.dart';
part 'job_chat_message_model.g.dart';

@freezed
sealed class JobChatMessageModel with _$JobChatMessageModel {
  const factory JobChatMessageModel({
    @JsonKey(includeToJson: false) required String uid,
    String? localId,
    required String jobId,
    String? senderUid,
    required List<JobChatMessageContentModel> content,
    
    @JsonKey(unknownEnumValue: JobChatMessageType.message)
    @Default(JobChatMessageType.message) JobChatMessageType type,
    
    Map<String, dynamic>? metadata,
    String? actionPerformed,
    
    @DateTimeConverter() required DateTime createdByAuthorAt,
    
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? createdAt,
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? updatedAt,
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? seenAt,
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? deliveredAt,
    
    @JsonKey(includeToJson: false) @Default(true) bool? active,
    @JsonKey(includeToJson: false) @Default(false) bool? deleted,
    
    String? deletedByUid,
    String? deletedByUserType,
    @Default([]) List<String> deletedFor,
    @DateTimeNullableConverter() DateTime? deletedAt,
    @DateTimeNullableConverter() DateTime? deletedByUserAt,
  }) = _JobChatMessageModel;

  const JobChatMessageModel._();

  DateTime get timestamp => createdByAuthorAt;

  String get status {
    if (seenAt != null) return 'seen';
    if (deliveredAt != null) return 'delivered';
    return 'sent';
  }

  factory JobChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$JobChatMessageModelFromJson(json);

  JobChatMessageEntity toEntity({bool? isMe}) {
    return JobChatMessageEntity(
      uid: uid,
      localId: localId,
      jobId: jobId,
      senderUid: senderUid,
      content: content.map((e) => e.toEntity()).toList(),
      type: type,
      metadata: metadata,
      actionPerformed: actionPerformed,
      createdByAuthorAt: createdByAuthorAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      seenAt: seenAt,
      deliveredAt: deliveredAt,
      isMe: isMe ?? false,
      active: active ?? true,
      deleted: deleted ?? false,
      deletedByUid: deletedByUid,
      deletedByUserType: deletedByUserType,
      deletedFor: deletedFor,
      deletedAt: deletedAt,
      deletedByUserAt: deletedByUserAt,
    );
  }
}

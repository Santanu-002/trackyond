import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/utils/json_converters.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

part 'job_chat_message_model.freezed.dart';
part 'job_chat_message_model.g.dart';

@freezed
sealed class JobChatMessageModel with _$JobChatMessageModel {
  const factory JobChatMessageModel({
    required String uid,
    String? localId,
    required String jobId,
    String? senderUid,
    required List<JobChatMessageContentModel> content,
    @Default('message') String type,
    Map<String, dynamic>? metadata,
    String? actionPerformed,
    
    @DateTimeConverter() required DateTime createdByAuthorAt,
    @DateTimeNullableConverter() DateTime? createdAt,
    @DateTimeNullableConverter() DateTime? updatedAt,
    @DateTimeNullableConverter() DateTime? seenAt,
    @DateTimeNullableConverter() DateTime? deliveredAt,
    
    @Default(true) bool? active,
    @Default(false) bool? deleted,
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
    );
  }
}


import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/utils/json_converters.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';

part 'send_message_model.freezed.dart';
part 'send_message_model.g.dart';

@freezed
sealed class SendMessageModel with _$SendMessageModel {
  const factory SendMessageModel({
    String? localId,
    required String jobId,
    String? senderUid,
    @JsonKey(unknownEnumValue: JobChatMessageType.message)
    @Default(JobChatMessageType.message) JobChatMessageType type,
    Map<String, dynamic>? metadata,
    String? actionPerformed,
    @DateTimeConverter() required DateTime createdByAuthorAt,
    required List<JobChatMessageContentModel> content,
  }) = _SendMessageModel;

  const SendMessageModel._();

  factory SendMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageModelFromJson(json);

  factory SendMessageModel.fromEntity(SendMessageEntity entity) {
    return SendMessageModel(
      localId: entity.localId,
      jobId: entity.jobId,
      senderUid: entity.senderUid,
      type: entity.type,
      metadata: entity.metadata,
      actionPerformed: entity.actionPerformed,
      createdByAuthorAt: entity.createdByAuthorAt,
      content: entity.content.map((e) => JobChatMessageContentModel.fromEntity(e)).toList(),
    );
  }

  SendMessageEntity toEntity() {
    return SendMessageEntity(
      localId: localId,
      jobId: jobId,
      senderUid: senderUid,
      type: type,
      metadata: metadata,
      actionPerformed: actionPerformed,
      createdByAuthorAt: createdByAuthorAt,
      content: content.map((e) => e.toEntity()).toList(),
    );
  }
}

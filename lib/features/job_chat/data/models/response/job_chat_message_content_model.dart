import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';

part 'job_chat_message_content_model.freezed.dart';
part 'job_chat_message_content_model.g.dart';

@freezed
sealed class JobChatMessageContentModel with _$JobChatMessageContentModel {
  const factory JobChatMessageContentModel({
    @JsonKey(unknownEnumValue: JobChatMessageContentType.unknown)
    required JobChatMessageContentType type,
    String? content,
    ChatMessageMetadataModel? metadata,
  }) = _JobChatMessageContentModel;

  const JobChatMessageContentModel._();

  factory JobChatMessageContentModel.fromJson(Map<String, dynamic> json) =>
      _$JobChatMessageContentModelFromJson(json);

  factory JobChatMessageContentModel.fromEntity(JobChatMessageContentEntity entity) {
    return JobChatMessageContentModel(
      type: entity.type,
      content: entity.content,
      metadata: entity.metadata != null
          ? ChatMessageMetadataModel.fromJson(entity.metadata!)
          : null,
    );
  }

  JobChatMessageContentEntity toEntity() {
    return JobChatMessageContentEntity(
      type: type,
      content: content,
      metadata: metadata?.toJson(),
    );
  }
}

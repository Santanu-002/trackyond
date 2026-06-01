import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';

part 'job_chat_message_content_model.freezed.dart';
part 'job_chat_message_content_model.g.dart';

@freezed
@JsonSerializable(explicitToJson: true)
sealed class JobChatMessageContentModel with _$JobChatMessageContentModel {
  const factory JobChatMessageContentModel({
    @JsonKey(unknownEnumValue: JobChatMessageContentType.unknown)
    required JobChatMessageContentType type,
    String? content,
    Map<String, dynamic>? metadata,
  }) = _JobChatMessageContentModel;

  const JobChatMessageContentModel._();

  factory JobChatMessageContentModel.fromJson(Map<String, dynamic> json) =>
      _$JobChatMessageContentModelFromJson(json);

  factory JobChatMessageContentModel.fromEntity(JobChatMessageContentEntity entity) {
    return JobChatMessageContentModel(
      type: entity.type,
      content: entity.content,
      metadata: entity.metadata,
    );
  }

  JobChatMessageContentEntity toEntity() {
    return JobChatMessageContentEntity(
      type: type,
      content: content,
      metadata: metadata,
    );
  }
}

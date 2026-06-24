import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/utils/json_converters.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';

part 'send_message_model.freezed.dart';
part 'send_message_model.g.dart';

@freezed
sealed class SendMessageModel with _$SendMessageModel implements SendMessageEntity {
  const factory SendMessageModel({
    @JsonKey(readValue: SendMessageModel._readLocalUid) String? localUid,
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

  static Object? _readLocalUid(Map json, String key) =>
      json['localUid'] ?? json['local_uid'] ?? json['localId'] ?? json['local_id'];

  factory SendMessageModel.fromJson(Map<String, dynamic> json) =>
      _$SendMessageModelFromJson(json);

  factory SendMessageModel.fromEntity(SendMessageEntity entity) {
    return SendMessageModel(
      localUid: entity.localUid,
      jobId: entity.jobId,
      senderUid: entity.senderUid,
      type: entity.type,
      metadata: entity.metadata,
      actionPerformed: entity.actionPerformed,
      createdByAuthorAt: entity.createdByAuthorAt,
      content: entity.content.map((e) {
        if (e is JobChatMessageContentModel) {
          return e;
        }
        final meta = e.metadata;
        return JobChatMessageContentModel(
          type: e.type,
          content: e.content,
          metadata: meta is Map<String, dynamic>
              ? ChatMessageMetadataModel.fromJson(meta)
              : meta as ChatMessageMetadataModel?,
        );
      }).toList(),
    );
  }

  @override
  List<Object?> get props => [
        localUid,
        jobId,
        senderUid,
        type,
        metadata,
        actionPerformed,
        createdByAuthorAt,
        content,
      ];

  @override
  bool? get stringify => true;
}

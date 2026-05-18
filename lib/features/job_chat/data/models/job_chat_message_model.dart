import 'package:freezed_annotation/freezed_annotation.dart';
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
    @Default('user') String authorType,
    String? createdByUid,
    String? createdByProfileUid,
    
    // We'll mock these for now as they might not be in the initial JSON from old code
    String? senderName,
    String? senderId,

    required List<JobChatMessageContentModel> contents,
    
    required DateTime createdByAuthorAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? seenAt,
    DateTime? deliveredAt,
    
    @Default('sent') String status,
    @Default(false) bool isMe,
    @Default(true) bool active,
    @Default(false) bool deleted,
  }) = _JobChatMessageModel;

  const JobChatMessageModel._();

  factory JobChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$JobChatMessageModelFromJson(json);

  JobChatMessageEntity toEntity() {
    return JobChatMessageEntity(
      id: uid,
      localId: localId,
      jobId: jobId,
      authorType: authorType,
      senderName: senderName,
      senderId: senderId,
      senderProfileUid: createdByProfileUid,
      contents: contents.map((e) => e.toEntity()).toList(),
      timestamp: createdByAuthorAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      seenAt: seenAt,
      deliveredAt: deliveredAt,
      status: status,
      isMe: isMe,
      active: active,
      deleted: deleted,
    );
  }
}

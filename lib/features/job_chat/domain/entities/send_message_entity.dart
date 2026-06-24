import 'package:equatable/equatable.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';

class SendMessageEntity extends Equatable {
  final String? localUid;
  final String jobId;
  final String? senderUid;
  final JobChatMessageType type;
  final Map<String, dynamic>? metadata;
  final String? actionPerformed;
  final DateTime createdByAuthorAt;
  final List<JobChatMessageContentEntity> content;

  const SendMessageEntity({
    this.localUid,
    required this.jobId,
    this.senderUid,
    required this.type,
    this.metadata,
    this.actionPerformed,
    required this.createdByAuthorAt,
    required this.content,
  });

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
}

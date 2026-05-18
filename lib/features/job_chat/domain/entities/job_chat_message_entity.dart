import 'package:equatable/equatable.dart';
import 'job_chat_message_content_entity.dart';

class JobChatMessageEntity extends Equatable {
  final String id;
  final String? localId;
  final String jobId;
  final String authorType; // 'user', 'system'
  final String? senderName;
  final String? senderId;
  final String? senderProfileUid;
  
  final List<JobChatMessageContentEntity> contents;
  
  final DateTime timestamp;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? seenAt;
  final DateTime? deliveredAt;
  
  final String status; // 'sent', 'delivered', 'seen'
  final bool isMe;
  final bool active;
  final bool deleted;

  const JobChatMessageEntity({
    required this.id,
    this.localId,
    required this.jobId,
    this.authorType = 'user',
    this.senderName,
    this.senderId,
    this.senderProfileUid,
    required this.contents,
    required this.timestamp,
    this.createdAt,
    this.updatedAt,
    this.seenAt,
    this.deliveredAt,
    this.status = 'sent',
    required this.isMe,
    this.active = true,
    this.deleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        localId,
        jobId,
        authorType,
        senderName,
        senderId,
        senderProfileUid,
        contents,
        timestamp,
        createdAt,
        updatedAt,
        seenAt,
        deliveredAt,
        status,
        isMe,
        active,
        deleted,
      ];
}

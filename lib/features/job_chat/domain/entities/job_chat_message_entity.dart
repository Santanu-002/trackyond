import 'package:equatable/equatable.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';

class JobChatMessageEntity extends Equatable {
  final String uid;
  final String? localId;
  final String jobId;
  final String authorType; // 'user', 'system'
  final String senderName;
  final String senderId;
  final String? senderProfileUid;
  
  final List<JobChatMessageContentEntity> content;
  final String type; // 'message', 'activity'
  final Map<String, dynamic>? metadata;
  
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
    required this.uid,
    this.localId,
    required this.jobId,
    this.authorType = 'user',
    required this.senderName,
    required this.senderId,
    this.senderProfileUid,
    required this.content,
    this.type = 'message',
    this.metadata,
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

  JobChatMessageEntity copyWith({
    String? uid,
    String? localId,
    String? jobId,
    String? authorType,
    String? senderName,
    String? senderId,
    String? senderProfileUid,
    List<JobChatMessageContentEntity>? content,
    String? type,
    Map<String, dynamic>? metadata,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? seenAt,
    DateTime? deliveredAt,
    String? status,
    bool? isMe,
    bool? active,
    bool? deleted,
  }) {
    return JobChatMessageEntity(
      uid: uid ?? this.uid,
      localId: localId ?? this.localId,
      jobId: jobId ?? this.jobId,
      authorType: authorType ?? this.authorType,
      senderName: senderName ?? this.senderName,
      senderId: senderId ?? this.senderId,
      senderProfileUid: senderProfileUid ?? this.senderProfileUid,
      content: content ?? this.content,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seenAt: seenAt ?? this.seenAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      status: status ?? this.status,
      isMe: isMe ?? this.isMe,
      active: active ?? this.active,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        localId,
        jobId,
        authorType,
        senderName,
        senderId,
        senderProfileUid,
        content,
        type,
        metadata,
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


import 'package:equatable/equatable.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';

class JobChatMessageEntity extends Equatable {
  final String uid;
  final String? localId;
  final String jobId;
  final String? senderUid;
  
  final List<JobChatMessageContentEntity> content;
  final String type; // 'message', 'activity'
  final Map<String, dynamic>? metadata;
  final String? actionPerformed;
  
  final DateTime createdByAuthorAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? seenAt;
  final DateTime? deliveredAt;
  
  final bool isMe;
  final bool active;
  final bool deleted;

  const JobChatMessageEntity({
    required this.uid,
    this.localId,
    required this.jobId,
    this.senderUid,
    required this.content,
    this.type = 'message',
    this.metadata,
    this.actionPerformed,
    required this.createdByAuthorAt,
    this.createdAt,
    this.updatedAt,
    this.seenAt,
    this.deliveredAt,
    required this.isMe,
    this.active = true,
    this.deleted = false,
  });

  DateTime get timestamp => createdByAuthorAt;

  String get status {
    if (seenAt != null) return 'seen';
    if (deliveredAt != null) return 'delivered';
    return 'sent';
  }

  JobChatMessageEntity copyWith({
    String? uid,
    String? localId,
    String? jobId,
    String? senderUid,
    List<JobChatMessageContentEntity>? content,
    String? type,
    Map<String, dynamic>? metadata,
    String? actionPerformed,
    DateTime? createdByAuthorAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? seenAt,
    DateTime? deliveredAt,
    bool? isMe,
    bool? active,
    bool? deleted,
  }) {
    return JobChatMessageEntity(
      uid: uid ?? this.uid,
      localId: localId ?? this.localId,
      jobId: jobId ?? this.jobId,
      senderUid: senderUid ?? this.senderUid,
      content: content ?? this.content,
      type: type ?? this.type,
      metadata: metadata ?? this.metadata,
      actionPerformed: actionPerformed ?? this.actionPerformed,
      createdByAuthorAt: createdByAuthorAt ?? this.createdByAuthorAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seenAt: seenAt ?? this.seenAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
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
        senderUid,
        content,
        type,
        metadata,
        actionPerformed,
        createdByAuthorAt,
        createdAt,
        updatedAt,
        seenAt,
        deliveredAt,
        isMe,
        active,
        deleted,
      ];
}


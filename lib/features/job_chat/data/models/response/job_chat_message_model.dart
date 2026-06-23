import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/services/database/tables/chat_message_table.dart';
import 'package:trackyond/core/utils/json_converters.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

part 'job_chat_message_model.freezed.dart';
part 'job_chat_message_model.g.dart';

@freezed
sealed class JobChatMessageModel with _$JobChatMessageModel {
  const factory JobChatMessageModel({
    @JsonKey(includeToJson: false) required String uid,
    String? localId,
    required String jobId,
    String? senderUid,
    required List<JobChatMessageContentModel> content,
    
    @JsonKey(unknownEnumValue: JobChatMessageType.message)
    @Default(JobChatMessageType.message) JobChatMessageType type,
    
    Map<String, dynamic>? metadata,
    String? actionPerformed,
    
    @DateTimeConverter() required DateTime createdByAuthorAt,
    
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? createdAt,
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? updatedAt,
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? seenAt,
    @JsonKey(includeToJson: false) @DateTimeNullableConverter() DateTime? deliveredAt,
    
    @JsonKey(includeToJson: false) @Default(true) bool? active,
    @JsonKey(includeToJson: false) @Default(false) bool? deleted,
    
    String? deletedByUid,
    String? deletedByUserType,
    @Default([]) List<String> deletedFor,
    @DateTimeNullableConverter() DateTime? deletedAt,
    @DateTimeNullableConverter() DateTime? deletedByUserAt,
  }) = _JobChatMessageModel;

  const JobChatMessageModel._();

  DateTime get timestamp => createdByAuthorAt;

  String get status {
    if (uid.startsWith('temp_') || (localId != null && uid == localId)) {
      return 'pending';
    }
    if (seenAt != null) return 'seen';
    if (deliveredAt != null) return 'delivered';
    return 'sent';
  }

  factory JobChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$JobChatMessageModelFromJson(json);

  Map<String, dynamic> toDbMap() {
    return {
      ChatMessageTable.columnNames.uid: uid,
      ChatMessageTable.columnNames.localId: localId,
      ChatMessageTable.columnNames.jobId: jobId,
      ChatMessageTable.columnNames.senderUid: senderUid,
      ChatMessageTable.columnNames.type: type.value,
      ChatMessageTable.columnNames.actionPerformed: actionPerformed,
      ChatMessageTable.columnNames.createdByAuthorAt: createdByAuthorAt.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.createdAt: createdAt?.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.updatedAt: updatedAt?.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.seenAt: seenAt?.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.deliveredAt: deliveredAt?.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.active: (active ?? true) ? 1 : 0,
      ChatMessageTable.columnNames.deleted: (deleted ?? false) ? 1 : 0,
      ChatMessageTable.columnNames.deletedByUid: deletedByUid,
      ChatMessageTable.columnNames.deletedByUserType: deletedByUserType,
      ChatMessageTable.columnNames.deletedFor: jsonEncode(deletedFor),
      ChatMessageTable.columnNames.deletedAt: deletedAt?.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.deletedByUserAt: deletedByUserAt?.toUtc().toIso8601String(),
      ChatMessageTable.columnNames.content: jsonEncode(content.map((c) => c.toJson()).toList()),
      ChatMessageTable.columnNames.metadata: jsonEncode(metadata ?? {}),
    };
  }

  factory JobChatMessageModel.fromDbMap(Map<String, dynamic> map) {
    final rawContent = map[ChatMessageTable.columnNames.content] as String;
    final List<dynamic> contentList = jsonDecode(rawContent) as List<dynamic>;
    final contents = contentList
        .map((e) => JobChatMessageContentModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return JobChatMessageModel(
      uid: map[ChatMessageTable.columnNames.uid] as String,
      localId: map[ChatMessageTable.columnNames.localId] as String?,
      jobId: map[ChatMessageTable.columnNames.jobId] as String,
      senderUid: map[ChatMessageTable.columnNames.senderUid] as String?,
      type: JobChatMessageType.values.firstWhere(
        (e) => e.value == (map[ChatMessageTable.columnNames.type] as String? ?? 'message'),
        orElse: () => JobChatMessageType.message,
      ),
      actionPerformed: map[ChatMessageTable.columnNames.actionPerformed] as String?,
      createdByAuthorAt: DateTime.parse(map[ChatMessageTable.columnNames.createdByAuthorAt] as String).toLocal(),
      createdAt: map[ChatMessageTable.columnNames.createdAt] != null
          ? DateTime.parse(map[ChatMessageTable.columnNames.createdAt] as String).toLocal()
          : null,
      updatedAt: map[ChatMessageTable.columnNames.updatedAt] != null
          ? DateTime.parse(map[ChatMessageTable.columnNames.updatedAt] as String).toLocal()
          : null,
      seenAt: map[ChatMessageTable.columnNames.seenAt] != null
          ? DateTime.parse(map[ChatMessageTable.columnNames.seenAt] as String).toLocal()
          : null,
      deliveredAt: map[ChatMessageTable.columnNames.deliveredAt] != null
          ? DateTime.parse(map[ChatMessageTable.columnNames.deliveredAt] as String).toLocal()
          : null,
      active: (map[ChatMessageTable.columnNames.active] as int) == 1,
      deleted: (map[ChatMessageTable.columnNames.deleted] as int) == 1,
      deletedByUid: map[ChatMessageTable.columnNames.deletedByUid] as String?,
      deletedByUserType: map[ChatMessageTable.columnNames.deletedByUserType] as String?,
      deletedFor: List<String>.from(
        jsonDecode(map[ChatMessageTable.columnNames.deletedFor] as String? ?? '[]'),
      ),
      deletedAt: map[ChatMessageTable.columnNames.deletedAt] != null
          ? DateTime.parse(map[ChatMessageTable.columnNames.deletedAt] as String).toLocal()
          : null,
      deletedByUserAt: map[ChatMessageTable.columnNames.deletedByUserAt] != null
          ? DateTime.parse(map[ChatMessageTable.columnNames.deletedByUserAt] as String).toLocal()
          : null,
      content: contents,
      metadata: jsonDecode(map[ChatMessageTable.columnNames.metadata] as String? ?? '{}') as Map<String, dynamic>,
    );
  }

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
      deletedByUid: deletedByUid,
      deletedByUserType: deletedByUserType,
      deletedFor: deletedFor,
      deletedAt: deletedAt,
      deletedByUserAt: deletedByUserAt,
    );
  }
}

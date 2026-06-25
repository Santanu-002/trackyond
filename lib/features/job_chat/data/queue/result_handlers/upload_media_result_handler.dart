import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/common/events/chat_event.dart';
import 'package:trackyond/core/common/repositories/i_event_bus_repository.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/common/enums/queue_priority.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/queue_service.dart';
import 'package:trackyond/core/services/queue_service/result_handler/queue_task_result_handler.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_content_model.dart';

class UploadMediaResultHandler implements TaskResultHandler {
  final IJobChatLocalDataSource _localDataSource;
  final IEventBusRepository _eventBus;

  UploadMediaResultHandler({
    required IJobChatLocalDataSource localDataSource,
    required IEventBusRepository eventBus,
  })  : _localDataSource = localDataSource,
        _eventBus = eventBus;

  @override
  QueueTaskType get type => QueueTaskType.uploadMedia;

  @override
  Future<void> handle(WorkResult result) async {
    if (!result.success) return;

    final task = result.task;
    final payload = task.payload as Map<String, dynamic>;
    final jobId = payload['jobId'] as String;
    final items = List<Map<String, dynamic>>.from(payload['items'] as List);
    final caption = payload['caption'] as String;
    final replyContent = payload['replyContent'] != null
        ? List<Map<String, dynamic>>.from(payload['replyContent'] as List)
        : null;
    final createdByAuthorAt = payload['createdByAuthorAt'] as String;

    final remotePaths = List<String>.from(result.data!['remotePaths'] as List);

    // Save updated paths into local database
    final existingMsg = await _localDataSource.getMessageByUid(task.id);
    if (existingMsg == null) return;

    final List<JobChatMessageContentModel> updatedContent = [];

    if (replyContent != null) {
      for (final reply in replyContent) {
        final meta = reply['metadata'];
        updatedContent.add(JobChatMessageContentModel(
          type: JobChatMessageContentType.fromString(reply['type'] as String),
          content: reply['content'] as String?,
          metadata: meta is Map<String, dynamic> ? ChatMessageMetadataModel.fromJson(meta) : null,
        ));
      }
    }

    for (int i = 0; i < remotePaths.length; i++) {
      final originalItem = items[i];
      final meta = originalItem['metadata'];
      updatedContent.add(JobChatMessageContentModel(
        type: JobChatMessageContentType.fromString(originalItem['type'] as String),
        content: remotePaths[i],
        metadata: meta is Map<String, dynamic> ? ChatMessageMetadataModel.fromJson(meta) : null,
      ));
    }

    if (caption.isNotEmpty) {
      updatedContent.add(JobChatMessageContentModel(
        type: JobChatMessageContentType.text,
        content: caption,
      ));
    }

    final updatedMessage = existingMsg.copyWith(
      content: updatedContent,
    );

    await _localDataSource.saveMessages([updatedMessage]);

    // Fire complete event
    _eventBus.fire(ChatUploadCompleteEvent(task.id));

    // Auto-enqueue SendMessage task
    final sendTask = QueueTask(
      id: task.id,
      type: QueueTaskType.sendMessage,
      priority: QueuePriority.high,
      payload: {
        'jobId': jobId,
        'messages': [
          {
            'localUid': task.id,
            'jobId': jobId,
            'senderUid': existingMsg.senderUid,
            'content': updatedContent.map((c) => c.toJson()).toList(),
            'createdByAuthorAt': createdByAuthorAt,
            'type': existingMsg.type.name,
            'metadata': existingMsg.metadata,
          }
        ],
      },
      status: QueueTaskStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await QueueService.find.enqueue(sendTask);
  }
}

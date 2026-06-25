import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/services/queue_service/models/work_result.dart';
import 'package:trackyond/core/services/queue_service/worker/queue_worker.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_commands.dart';

class DeleteMessagesWorker implements QueueWorker {
  final WebSocketService _webSocketService;
  final IJobChatRemoteDataSource _remoteDataSource;

  DeleteMessagesWorker({
    required WebSocketService webSocketService,
    required IJobChatRemoteDataSource remoteDataSource,
  })  : _webSocketService = webSocketService,
        _remoteDataSource = remoteDataSource;

  @override
  QueueTaskType get type => QueueTaskType.deleteMessages;

  @override
  Future<WorkResult> execute(QueueTask task) async {
    final payload = task.payload as Map<String, dynamic>;
    final jobId = payload['jobId'] as String;
    final deleteType = payload['deleteType'] as String;
    final messageUids = List<String>.from(payload['messageUids'] as List);
    final deletedByUserAt = DateTime.parse(payload['deletedByUserAt'] as String);

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (!isOnline) {
      return WorkResult.failure(task: task, message: 'Offline');
    }

    final command = DeleteMessagesCommand(
      jobId: jobId,
      deleteType: deleteType,
      messageUids: messageUids,
      deletedByUserAt: deletedByUserAt,
    );

    // Try WS first
    if (_webSocketService.isConnected) {
      try {
        final enqueueTask = EnqueueTask.fromCommand(command);
        final response = await _webSocketService.sendRequestWithResponse(
          enqueueTask,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.deleteMessage,
        );
        if (response.success) {
          return WorkResult.success(task: task, message: 'Deleted via WS');
        }
      } catch (e) {
        debugPrint('DeleteMessagesWorker: Delete via WebSocket failed: $e. Falling back to REST...');
      }
    }

    // Fallback to REST
    try {
      final response = await _remoteDataSource.deleteMessages(
        jobId: jobId,
        deleteType: deleteType,
        messageUids: messageUids,
        deletedByUserAt: deletedByUserAt,
      );

      return response.fold(
        (failure) => WorkResult.failure(task: task, message: failure.message),
        (_) => WorkResult.success(task: task, message: 'Deleted via REST'),
      );
    } catch (e) {
      return WorkResult.failure(task: task, message: e.toString());
    }
  }
}

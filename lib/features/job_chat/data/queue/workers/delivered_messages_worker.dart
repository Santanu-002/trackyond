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

class DeliveredMessagesWorker implements QueueWorker {
  final WebSocketService _webSocketService;
  final IJobChatRemoteDataSource _remoteDataSource;

  DeliveredMessagesWorker({
    required WebSocketService webSocketService,
    required IJobChatRemoteDataSource remoteDataSource,
  })  : _webSocketService = webSocketService,
        _remoteDataSource = remoteDataSource;

  @override
  QueueTaskType get type => QueueTaskType.deliveredMessages;

  @override
  Future<WorkResult> execute(QueueTask task) async {
    final payload = task.payload as Map<String, dynamic>;
    final jobId = payload['jobId'] as String;
    final messageUids = List<String>.from(payload['messageUids'] as List);

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (!isOnline) {
      return WorkResult.failure(task: task, message: 'Offline');
    }

    final command = DeliveredMessagesCommand(
      jobId: jobId,
      messageUids: messageUids,
    );

    // Try WS first
    if (_webSocketService.isConnected) {
      try {
        final enqueueTask = EnqueueTask.fromCommand(command);
        final response = await _webSocketService.sendRequestWithResponse(
          enqueueTask,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.ack,
        );
        if (response.success) {
          return WorkResult.success(task: task, message: 'Marked delivered via WS');
        }
      } catch (e) {
        debugPrint('DeliveredMessagesWorker: Mark delivered via WebSocket failed: $e. Falling back to REST...');
      }
    }

    // Fallback to REST
    try {
      final response = await _remoteDataSource.markMessagesAsDelivered(
        jobId: jobId,
        messageUids: messageUids,
      );

      return response.fold(
        (failure) => WorkResult.failure(task: task, message: failure.message),
        (_) => WorkResult.success(task: task, message: 'Marked delivered via REST'),
      );
    } catch (e) {
      return WorkResult.failure(task: task, message: e.toString());
    }
  }
}

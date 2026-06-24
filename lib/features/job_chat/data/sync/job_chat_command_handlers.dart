import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/sync/models/sync_command.dart';
import 'package:trackyond/core/services/sync/models/sync_result.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_commands.dart';
import 'package:trackyond/features/job_chat/data/models/response/send_message_response_model.dart';

class SendMessageCommandHandler extends SyncCommandHandler<SendMessageCommand> {
  final IJobChatLocalDataSource _localDataSource;
  final IJobChatRemoteDataSource _remoteDataSource;

  SendMessageCommandHandler({
    required IJobChatLocalDataSource localDataSource,
    required IJobChatRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  @override
  Future<SyncResult> handle(SendMessageCommand command, int taskId) async {
    try {
      if (command.messages.isEmpty) return const SyncSuccess();

      final wsService = Get.find<WebSocketService>();
      if (wsService.isConnected) {
        try {
          final task = EnqueueTask.fromCommand(command);
          final response = await wsService.sendRequestWithResponse(
            task,
            event: WebSocketEvents.message,
            type: WebSocketMessageType.sendMessage,
          );
          if (response.success && response.data != null) {
            final resModel = SendMessageResponseModel.fromJson(response.data!);
            await _localDataSource.saveMessages(resModel.messages);
            return const SyncSuccess();
          }
        } catch (e) {
          debugPrint('SendMessageCommandHandler: WebSocket send failed: $e. Falling back to REST API.');
        }
      }

      // REST API Fallback
      final response = await _remoteDataSource.sendMessage(messages: command.messages);
      return response.fold(
        (failure) => SyncRetry(failure.message),
        (data) async {
          if (data != null) {
            await _localDataSource.saveMessages(data.messages);
          }
          return const SyncSuccess();
        },
      );
    } catch (e) {
      return SyncRetry(e.toString());
    }
  }
}

class DeleteMessagesCommandHandler extends SyncCommandHandler<DeleteMessagesCommand> {
  final IJobChatRemoteDataSource _remoteDataSource;

  DeleteMessagesCommandHandler(this._remoteDataSource);

  @override
  Future<SyncResult> handle(DeleteMessagesCommand command, int taskId) async {
    try {
      final wsService = Get.find<WebSocketService>();
      if (wsService.isConnected) {
        try {
          final task = EnqueueTask.fromCommand(command);
          final response = await wsService.sendRequestWithResponse(
            task,
            event: WebSocketEvents.message,
            type: WebSocketMessageType.deleteMessage,
          );
          if (response.success) {
            return const SyncSuccess();
          }
        } catch (e) {
          debugPrint('DeleteMessagesCommandHandler: WebSocket send failed: $e. Falling back to REST.');
        }
      }

      // REST API Fallback
      final response = await _remoteDataSource.deleteMessages(
        jobId: command.jobId,
        deleteType: command.deleteType,
        messageUids: command.messageUids,
        deletedByUserAt: command.deletedByUserAt,
      );
      return response.fold(
        (failure) => SyncRetry(failure.message),
        (_) => const SyncSuccess(),
      );
    } catch (e) {
      return SyncRetry(e.toString());
    }
  }
}

class SeenMessagesCommandHandler extends SyncCommandHandler<SeenMessagesCommand> {
  final IJobChatRemoteDataSource _remoteDataSource;

  SeenMessagesCommandHandler(this._remoteDataSource);

  @override
  Future<SyncResult> handle(SeenMessagesCommand command, int taskId) async {
    try {
      final wsService = Get.find<WebSocketService>();
      if (wsService.isConnected) {
        try {
          final task = EnqueueTask.fromCommand(command);
          final response = await wsService.sendRequestWithResponse(
            task,
            event: WebSocketEvents.message,
            type: WebSocketMessageType.readMessage,
          );
          if (response.success) {
            return const SyncSuccess();
          }
        } catch (e) {
          debugPrint('SeenMessagesCommandHandler: WebSocket send failed: $e. Falling back to REST.');
        }
      }

      // REST API Fallback
      final response = await _remoteDataSource.markMessagesAsSeen(
        jobId: command.jobId,
        messageUids: command.messageUids,
      );
      return response.fold(
        (failure) => SyncRetry(failure.message),
        (_) => const SyncSuccess(),
      );
    } catch (e) {
      return SyncRetry(e.toString());
    }
  }
}

class DeliveredMessagesCommandHandler extends SyncCommandHandler<DeliveredMessagesCommand> {
  final IJobChatRemoteDataSource _remoteDataSource;

  DeliveredMessagesCommandHandler(this._remoteDataSource);

  @override
  Future<SyncResult> handle(DeliveredMessagesCommand command, int taskId) async {
    try {
      final wsService = Get.find<WebSocketService>();
      if (wsService.isConnected) {
        try {
          final task = EnqueueTask.fromCommand(command);
          final response = await wsService.sendRequestWithResponse(
            task,
            event: WebSocketEvents.message,
            type: WebSocketMessageType.ack,
          );
          if (response.success) {
            return const SyncSuccess();
          }
        } catch (e) {
          debugPrint('DeliveredMessagesCommandHandler: WebSocket send failed: $e. Falling back to REST.');
        }
      }

      // REST API Fallback
      final response = await _remoteDataSource.markMessagesAsDelivered(
        jobId: command.jobId,
        messageUids: command.messageUids,
      );
      return response.fold(
        (failure) => SyncRetry(failure.message),
        (_) => const SyncSuccess(),
      );
    } catch (e) {
      return SyncRetry(e.toString());
    }
  }
}

class UpdateJobStatusCommandHandler extends SyncCommandHandler<UpdateJobStatusCommand> {
  final IJobChatRemoteDataSource _remoteDataSource;

  UpdateJobStatusCommandHandler(this._remoteDataSource);

  @override
  Future<SyncResult> handle(UpdateJobStatusCommand command, int taskId) async {
    try {
      final response = await _remoteDataSource.updateJobStatus(
        jobId: command.jobId,
        status: command.status,
      );
      return response.fold(
        (failure) => SyncRetry(failure.message),
        (_) => const SyncSuccess(),
      );
    } catch (e) {
      return SyncRetry(e.toString());
    }
  }
}

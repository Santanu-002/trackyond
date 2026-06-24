import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/core/common/repositories/base_sync_repository.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/sync/sync_service.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/request/message_query_options_model.dart';
import 'package:trackyond/features/job_chat/data/models/request/send_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/send_message_response_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/core/services/sync/models/sync_command.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/core/services/sync/models/sync_priority.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_sync_queries.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_commands.dart';

class JobChatRepositoryImpl extends BaseSyncRepository implements IJobChatRepository {
  final IJobChatRemoteDataSource _remoteDataSource;
  final IJobChatLocalDataSource _localDataSource;
  final WebSocketService _webSocketService;
  final SyncService _syncService;

  JobChatRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._webSocketService,
    this._syncService,
  );

  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(
    String jobId, {
    MessageQueryOptions? options,
  }) async {
    final isInitialLoad = (options?.offset ?? 0) == 0;

    if (!isInitialLoad) {
      // ── Pagination: read local DB only ──────────────────────────────────
      // No background sync is triggered per page — that would cause
      // remote events to arrive mid-scroll and scatter the message list.
      try {
        final cached = await _localDataSource.getCachedMessages(
          jobId,
          limit: options?.limit,
          offset: options?.offset,
        );
        return right(cached.cast<JobChatMessageEntity>().toList());
      } catch (e) {
        return left(CacheFailure(e.toString()));
      }
    }

    // ── Initial load: return local immediately, sync 100 msgs in background ─
    // Cache key is per-job only (no offset) so the background sync fires
    // at most once per cacheDuration regardless of how many pages are loaded.
    return syncData<List<JobChatMessageEntity>, List<JobChatMessageModel>>(
      query: GetChatMessagesQuery(jobId: jobId),
      fetchLocal: () async {
        final cached = await _localDataSource.getCachedMessages(
          jobId,
          limit: options?.limit,
          offset: 0,
        );
        return cached.cast<JobChatMessageEntity>().toList();
      },
      fetchRemote: () async {
        // Fetch a larger batch to warm the local cache so that subsequent
        // pagination pages can be served entirely from local storage.
        const warmupBatchSize = 100;
        final response = await _remoteDataSource.getMessages(
          jobId: jobId,
          options: MessageQueryOptionsModel(limit: warmupBatchSize, offset: 0),
        );
        return response.fold(
          (error) => throw Exception(error.message),
          (data) => data ?? [],
        );
      },
      updateLocal: (data) async {
        await _localDataSource.saveMessages(data);
      },
    );
  }

  @override
  Future<Either<AppFailure, SendMessageResult>> sendMessage(
    List<SendMessageEntity> messages,
  ) async {
    final models = messages
        .map((message) => SendMessageModel.fromEntity(message))
        .toList();

    if (models.isEmpty) {
      return Left(ServerFailure('No messages to send'));
    }

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    final wsService = _webSocketService;
    final jobId = models.first.jobId;

    final tempUid = models.first.localUid ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final previewMessage = JobChatMessageModel(
      uid: tempUid,
      serverUid: null,
      jobId: models.first.jobId,
      senderUid: models.first.senderUid,
      content: models.first.content,
      type: models.first.type,
      metadata: models.first.metadata,
      actionPerformed: models.first.actionPerformed,
      createdByAuthorAt: models.first.createdByAuthorAt,
    );

    // Save to local cache immediately for optimistic UI updates
    await _localDataSource.saveMessages([previewMessage]);

    final command = SendMessageCommand(jobId: jobId, messages: models);

    if (isOnline && wsService.isConnected) {
      try {
        final task = EnqueueTask.fromCommand(command, requestId: tempUid);
        final response = await wsService.sendRequestWithResponse(
          task,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.sendMessage,
        );

        if (response.success && response.data != null) {
          final resModel = SendMessageResponseModel.fromJson(response.data!);
          await _localDataSource.saveMessages(resModel.messages);
          return Right(resModel);
        }
      } catch (e) {
        debugPrint('JobChatRepositoryImpl: Send message via WebSocket failed: $e. Falling back to REST...');
      }
    }

    if (isOnline) {
      final response = await _remoteDataSource.sendMessage(messages: models);
      return response.fold(
        (error) async {
          // If REST fails, enqueue for sync later (High priority for messages)
          await _enqueueAndTrigger(command, priority: SyncPriority.high);
          final previewResponse = SendMessageResponseModel(
            message: previewMessage,
            messages: [previewMessage],
            allowedActions: [],
          );
          return Right(previewResponse);
        },
        (data) async {
          if (data == null) return Left(ServerFailure('No data returned'));
          // Replace preview with the server-acknowledged message
          await _localDataSource.saveMessages(data.messages);
          return Right(data);
        },
      );
    } else {
      // Offline: Enqueue in sync queue with high priority
      await _enqueueAndTrigger(command, priority: SyncPriority.high);

      final previewResponse = SendMessageResponseModel(
        message: previewMessage,
        messages: [previewMessage],
        allowedActions: [],
      );

      return Right(previewResponse);
    }
  }

  @override
  Future<Either<AppFailure, JobEntity>> updateJobStatus(
    String jobId,
    String status,
  ) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (isOnline) {
      final response = await _remoteDataSource.updateJobStatus(
        jobId: jobId,
        status: status,
      );

      return response.fold(
        (error) => Left(ServerFailure(error.message)),
        (data) async {
          if (data == null) return Left(ServerFailure('No data returned'));
          return Right(data.toEntity());
        },
      );
    } else {
      // Offline: queue status update (Normal priority)
      await _enqueueAndTrigger(
        UpdateJobStatusCommand(jobId: jobId, status: status),
        priority: SyncPriority.normal,
      );
      return Left(CacheFailure('Offline. Status update queued.'));
    }
  }

  @override
  Future<Either<AppFailure, List<MemberProfile>>> getChatMembers(
    String jobId,
  ) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (isOnline) {
      final response = await _remoteDataSource.getChatMembers(jobId: jobId);

      return response.fold(
        (error) async {
          final cached = await _localDataSource.getCachedChatMembers(jobId);
          return Right(cached.map((m) => m.toEntity()).toList());
        },
        (data) async {
          if (data == null) return Left(ServerFailure('No data returned'));
          await _localDataSource.saveChatMembers(data);
          return Right(data.map((m) => m.toEntity()).toList());
        },
      );
    } else {
      final cached = await _localDataSource.getCachedChatMembers(jobId);
      return Right(cached.map((m) => m.toEntity()).toList());
    }
  }

  @override
  Future<Either<AppFailure, void>> deleteMessages({
    required String jobId,
    required String deleteType,
    required List<String> messageUids,
    required DateTime deletedByUserAt,
  }) async {
    // Delete locally first (optimistic UI delete)
    String? deletedByUid;
    String? deletedByUserType;
    if (Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final userProfile = await authController.profile;
      final role = await authController.userRole;
      deletedByUid = userProfile?.uid;
      deletedByUserType = role?.value;
    }

    await _localDataSource.deleteCachedMessages(
      messageUids,
      deleteType: deleteType,
      deletedByUid: deletedByUid,
      deletedByUserType: deletedByUserType,
      deletedByUserAt: deletedByUserAt,
    );

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    final command = DeleteMessagesCommand(
      jobId: jobId,
      deleteType: deleteType,
      messageUids: messageUids,
      deletedByUserAt: deletedByUserAt.toUtc(),
    );

    if (isOnline && _webSocketService.isConnected) {
      try {
        final task = EnqueueTask.fromCommand(command);
        final response = await _webSocketService.sendRequestWithResponse(
          task,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.deleteMessage,
        );
        if (response.success) {
          return const Right(null);
        }
      } catch (e) {
        debugPrint('JobChatRepositoryImpl: Delete via WebSocket failed: $e. Falling back to REST...');
      }
    }

    if (isOnline) {
      final response = await _remoteDataSource.deleteMessages(
        jobId: jobId,
        deleteType: deleteType,
        messageUids: messageUids,
        deletedByUserAt: deletedByUserAt,
      );
      return response.fold(
        (error) async {
          // If remote delete fails, queue for sync
          await _enqueueAndTrigger(command, priority: SyncPriority.normal);
          return const Right(null);
        },
        (data) => const Right(null),
      );
    } else {
      // Offline: Queue delete task
      await _enqueueAndTrigger(command, priority: SyncPriority.normal);
      return const Right(null);
    }
  }

  @override
  Future<Either<AppFailure, void>> markMessagesAsSeen(String jobId, {List<String>? messageUids}) async {
    final now = DateTime.now();
    await _localDataSource.markMessagesAsSeen(jobId, messageUids ?? [], now);

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    final wsService = _webSocketService;
    final command = SeenMessagesCommand(
      jobId: jobId,
      messageUids: messageUids,
    );

    if (isOnline && wsService.isConnected) {
      try {
        final task = EnqueueTask.fromCommand(command);
        final response = await wsService.sendRequestWithResponse(
          task,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.readMessage,
        );
        if (response.success) {
          return const Right(null);
        }
      } catch (e) {
        debugPrint('JobChatRepositoryImpl: Mark seen via WebSocket failed: $e. Falling back to REST...');
      }
    }

    if (isOnline) {
      final response = await _remoteDataSource.markMessagesAsSeen(
        jobId: jobId,
        messageUids: messageUids,
      );
      return response.fold(
        (error) async {
          await _enqueueAndTrigger(command, priority: SyncPriority.low);
          return const Right(null);
        },
        (_) => const Right(null),
      );
    } else {
      await _enqueueAndTrigger(command, priority: SyncPriority.low);
      return const Right(null);
    }
  }

  @override
  Future<Either<AppFailure, void>> markMessagesAsDelivered(String jobId, List<String> messageUids) async {
    if (messageUids.isEmpty) return const Right(null);
    final now = DateTime.now();
    await _localDataSource.markMessagesAsDelivered(jobId, messageUids, now);

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    final wsService = _webSocketService;
    final command = DeliveredMessagesCommand(
      jobId: jobId,
      messageUids: messageUids,
    );

    if (isOnline && wsService.isConnected) {
      try {
        final task = EnqueueTask.fromCommand(command);
        final response = await wsService.sendRequestWithResponse(
          task,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.ack,
        );
        if (response.success) {
          return const Right(null);
        }
      } catch (e) {
        debugPrint('JobChatRepositoryImpl: Mark delivered via WebSocket failed: $e. Falling back to REST...');
      }
    }

    if (isOnline) {
      final response = await _remoteDataSource.markMessagesAsDelivered(
        jobId: jobId,
        messageUids: messageUids,
      );
      return response.fold(
        (error) async {
          await _enqueueAndTrigger(command, priority: SyncPriority.low);
          return const Right(null);
        },
        (_) => const Right(null),
      );
    } else {
      await _enqueueAndTrigger(command, priority: SyncPriority.low);
      return const Right(null);
    }
  }

  Future<void> _enqueueAndTrigger(SyncCommand command, {SyncPriority priority = SyncPriority.normal}) async {
    await _syncService.enqueue(command, priority: priority);
  }
}

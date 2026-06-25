import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/websocket_events.dart';
import 'package:trackyond/core/common/repositories/base_sync_repository.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/core/services/sync/models/enqueue_task.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_local_datasource.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/data/models/response/chat_message_metadata_model.dart';
import 'package:trackyond/features/job_chat/data/models/request/message_query_options_model.dart';
import 'package:trackyond/features/job_chat/data/models/request/send_message_model.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';
import 'package:trackyond/features/auth/presentation/controllers/auth_controller.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_sync_queries.dart';
import 'package:trackyond/features/job_chat/data/sync/job_chat_commands.dart';
import 'package:trackyond/core/services/queue_service/queue_service.dart';
import 'package:trackyond/core/common/models/queue/queue_task.dart';
import 'package:trackyond/core/common/enums/queue_task_type.dart';
import 'package:trackyond/core/common/enums/queue_priority.dart';
import 'package:trackyond/core/common/enums/queue_task_status.dart';
import 'package:trackyond/core/services/database/database_service.dart';
import 'package:trackyond/core/services/database/tables/queue_tasks_table.dart';
import 'package:nanoid/nanoid.dart';

class JobChatRepositoryImpl extends BaseSyncRepository implements IJobChatRepository {
  final IJobChatRemoteDataSource _remoteDataSource;
  final IJobChatLocalDataSource _localDataSource;
  final WebSocketService _webSocketService;

  JobChatRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._webSocketService,
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
  Future<Either<AppFailure, Unit>> sendMessage(
    List<SendMessageEntity> messages,
  ) async {
    if (messages.isEmpty) return const Right(unit);

    final model = messages.first;
    final tempUid = model.localUid ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final previewMessage = JobChatMessageModel(
      uid: tempUid,
      serverUid: null,
      jobId: model.jobId,
      senderUid: model.senderUid,
      content: model.content.map((c) {
        if (c is JobChatMessageContentModel) return c;
        return JobChatMessageContentModel(
          type: c.type,
          content: c.content,
          metadata: c.metadata is Map<String, dynamic>
              ? ChatMessageMetadataModel.fromJson(c.metadata as Map<String, dynamic>)
              : c.metadata as ChatMessageMetadataModel?,
        );
      }).toList(),
      type: model.type,
      metadata: model.metadata,
      actionPerformed: model.actionPerformed,
      createdByAuthorAt: model.createdByAuthorAt,
    );

    await _localDataSource.saveMessages([previewMessage]);

    final hasMediaContent = model.content.any((c) =>
        c.type != JobChatMessageContentType.text &&
        c.type != JobChatMessageContentType.reply &&
        c.type != JobChatMessageContentType.header);

    if (hasMediaContent) {
      final uploadItems = model.content
          .where((c) =>
              c.type != JobChatMessageContentType.text &&
              c.type != JobChatMessageContentType.reply &&
              c.type != JobChatMessageContentType.header)
          .map((c) => {
                'path': c.content,
                'type': c.type.value,
                'metadata': c.metadata is Map ? c.metadata : (c.metadata as dynamic)?.toJson(),
              })
          .toList();

      final caption = model.content
          .where((c) => c.type == JobChatMessageContentType.text)
          .map((c) => c.content)
          .join();

      final replyContent = model.content
          .where((c) => c.type == JobChatMessageContentType.reply)
          .map((c) => {
                'type': c.type.value,
                'content': c.content,
                'metadata': c.metadata is Map ? c.metadata : (c.metadata as dynamic)?.toJson(),
              })
          .toList();

      final task = QueueTask(
        id: tempUid,
        type: QueueTaskType.uploadMedia,
        priority: QueuePriority.high,
        payload: {
          'jobId': model.jobId,
          'items': uploadItems,
          'caption': caption,
          'replyContent': replyContent.isNotEmpty ? replyContent : null,
          'createdByAuthorAt': model.createdByAuthorAt.toIso8601String(),
        },
        status: QueueTaskStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await QueueService.find.enqueue(task);
    } else {
      final sendModels = messages.map((m) => SendMessageModel.fromEntity(m)).toList();
      final task = QueueTask(
        id: tempUid,
        type: QueueTaskType.sendMessage,
        priority: QueuePriority.high,
        payload: {
          'jobId': model.jobId,
          'messages': sendModels.map((m) => m.toJson()).toList(),
        },
        status: QueueTaskStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await QueueService.find.enqueue(task);
    }

    return const Right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> cancelMessageUpload(String messageUid) async {
    try {
      await QueueService.find.cancel(messageUid);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> retryMessageUpload(String messageUid) async {
    try {
      final db = Get.find<IDatabaseService>();
      final rows = await db.query(
        QueueTasksTable.tableName,
        where: 'id = ?',
        whereArgs: [messageUid],
        limit: 1,
      );

      if (rows.isEmpty) {
        debugPrint('JobChatRepositoryImpl: Task $messageUid is missing from queue_tasks DB. Self-healing...');
        
        final localMsg = await _localDataSource.getMessageByUid(messageUid);
        if (localMsg != null) {
          final hasLocalMedia = localMsg.content.any((c) =>
              (c.type == JobChatMessageContentType.image ||
               c.type == JobChatMessageContentType.video ||
               c.type == JobChatMessageContentType.document ||
               c.type == JobChatMessageContentType.pdf) &&
              c.content != null &&
              !c.content!.startsWith('http') &&
              !c.content!.startsWith('uploads/'));

          if (hasLocalMedia) {
            final uploadItems = localMsg.content
                .where((c) =>
                    c.type == JobChatMessageContentType.image ||
                    c.type == JobChatMessageContentType.video ||
                    c.type == JobChatMessageContentType.document ||
                    c.type == JobChatMessageContentType.pdf)
                .map((c) => {
                      'path': c.content,
                      'type': c.type.value,
                      'metadata': c.metadata?.toJson(),
                    })
                .toList();

            final caption = localMsg.content
                .where((c) => c.type == JobChatMessageContentType.text)
                .map((c) => c.content)
                .join();

            final replyContent = localMsg.content
                .where((c) => c.type == JobChatMessageContentType.reply)
                .map((c) => {
                      'type': c.type.value,
                      'content': c.content,
                      'metadata': c.metadata?.toJson(),
                    })
                .toList();

            final task = QueueTask(
              id: messageUid,
              type: QueueTaskType.uploadMedia,
              priority: QueuePriority.high,
              payload: {
                'jobId': localMsg.jobId,
                'items': uploadItems,
                'caption': caption,
                'replyContent': replyContent.isNotEmpty ? replyContent : null,
                'createdByAuthorAt': localMsg.createdByAuthorAt.toIso8601String(),
              },
              status: QueueTaskStatus.pending,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await QueueService.find.enqueue(task);
            debugPrint('JobChatRepositoryImpl: Re-enqueued uploadMedia task for $messageUid');
          } else {
            final List<Map<String, dynamic>> sendMessagesPayload = [
              {
                'localUid': localMsg.uid,
                'jobId': localMsg.jobId,
                'senderUid': localMsg.senderUid,
                'content': localMsg.content.map((c) => c.toJson()).toList(),
                'createdByAuthorAt': localMsg.createdByAuthorAt.toIso8601String(),
                'type': localMsg.type.name,
                'metadata': localMsg.metadata,
              }
            ];

            final task = QueueTask(
              id: messageUid,
              type: QueueTaskType.sendMessage,
              priority: QueuePriority.high,
              payload: {
                'jobId': localMsg.jobId,
                'messages': sendMessagesPayload,
              },
              status: QueueTaskStatus.pending,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await QueueService.find.enqueue(task);
            debugPrint('JobChatRepositoryImpl: Re-enqueued sendMessage task for $messageUid');
          }
        } else {
          debugPrint('JobChatRepositoryImpl: Failed self-healing. Local message not found for $messageUid');
          return Left(CacheFailure('Message not found locally'));
        }
      } else {
        await QueueService.find.retry(messageUid);
      }
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
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
          return Right(data);
        },
      );
    } else {
      // Offline: queue status update (medium priority)
      final task = QueueTask(
        id: 'status_${jobId}_${nanoid()}',
        type: QueueTaskType.updateJobStatus,
        priority: QueuePriority.medium,
        payload: {
          'jobId': jobId,
          'status': status,
        },
        status: QueueTaskStatus.pending,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await QueueService.find.enqueue(task);
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
          return Right(cached);
        },
        (data) async {
          if (data == null) return Left(ServerFailure('No data returned'));
          await _localDataSource.saveChatMembers(data);
          return Right(data);
        },
      );
    } else {
      final cached = await _localDataSource.getCachedChatMembers(jobId);
      return Right(cached);
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteMessages({
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

    final List<String> serverUids = [];
    for (final uid in messageUids) {
      final localMsg = await _localDataSource.getMessageByUid(uid);
      if (localMsg != null && localMsg.serverUid != null) {
        serverUids.add(localMsg.serverUid!);
      }
    }

    if (serverUids.isEmpty) {
      return const Right(unit);
    }

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    
    final task = QueueTask(
      id: 'delete_${jobId}_${nanoid()}',
      type: QueueTaskType.deleteMessages,
      priority: QueuePriority.medium,
      payload: {
        'jobId': jobId,
        'deleteType': deleteType,
        'messageUids': serverUids,
        'deletedByUserAt': deletedByUserAt.toUtc().toIso8601String(),
      },
      status: QueueTaskStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (isOnline && _webSocketService.isConnected) {
      try {
        final command = DeleteMessagesCommand(
          jobId: jobId,
          deleteType: deleteType,
          messageUids: serverUids,
          deletedByUserAt: deletedByUserAt.toUtc(),
        );
        final eqTask = EnqueueTask.fromCommand(command);
        final response = await _webSocketService.sendRequestWithResponse(
          eqTask,
          event: WebSocketEvents.message,
          type: WebSocketMessageType.deleteMessage,
        );
        if (response.success) {
          return const Right(unit);
        }
      } catch (e) {
        debugPrint('JobChatRepositoryImpl: Delete via WebSocket failed: $e. Falling back to REST...');
      }
    }

    if (isOnline) {
      final response = await _remoteDataSource.deleteMessages(
        jobId: jobId,
        deleteType: deleteType,
        messageUids: serverUids,
        deletedByUserAt: deletedByUserAt,
      );
      return response.fold(
        (error) async {
          // If remote delete fails, queue for sync
          await QueueService.find.enqueue(task);
          return const Right(unit);
        },
        (data) => const Right(unit),
      );
    } else {
      // Offline: Queue delete task
      await QueueService.find.enqueue(task);
      return const Right(unit);
    }
  }

  @override
  Future<Either<AppFailure, Unit>> markMessagesAsSeen(String jobId, {List<String>? messageUids}) async {
    final now = DateTime.now();
    await _localDataSource.markMessagesAsSeen(jobId, messageUids ?? [], now);

    final task = QueueTask(
      id: 'seen_${jobId}_${nanoid()}',
      type: QueueTaskType.seenMessages,
      priority: QueuePriority.low,
      payload: {
        'jobId': jobId,
        'messageUids': messageUids,
      },
      status: QueueTaskStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    await QueueService.find.enqueue(task);
    return const Right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> markMessagesAsDelivered(String jobId, List<String> messageUids) async {
    if (messageUids.isEmpty) return const Right(unit);
    final now = DateTime.now();
    await _localDataSource.markMessagesAsDelivered(jobId, messageUids, now);

    final task = QueueTask(
      id: 'delivered_${jobId}_${nanoid()}',
      type: QueueTaskType.deliveredMessages,
      priority: QueuePriority.low,
      payload: {
        'jobId': jobId,
        'messageUids': messageUids,
      },
      status: QueueTaskStatus.pending,
      createdAt: now,
      updatedAt: now,
    );

    await QueueService.find.enqueue(task);
    return const Right(unit);
  }

  @override
  Future<Either<AppFailure, Unit>> saveMessages(List<JobChatMessageEntity> messages) async {
    try {
      final models = messages.map((e) {
        if (e is JobChatMessageModel) {
          return e;
        }
        return JobChatMessageModel(
          uid: e.uid,
          serverUid: e.serverUid,
          jobId: e.jobId,
          senderUid: e.senderUid,
          content: e.content.map((c) {
            if (c is JobChatMessageContentModel) return c;
            return JobChatMessageContentModel(
              type: c.type,
              content: c.content,
              metadata: c.metadata as ChatMessageMetadataModel?,
            );
          }).toList(),
          type: e.type,
          metadata: e.metadata,
          actionPerformed: e.actionPerformed,
          createdByAuthorAt: e.createdByAuthorAt,
          createdAt: e.createdAt,
          updatedAt: e.updatedAt,
          seenAt: e.seenAt,
          deliveredAt: e.deliveredAt,
          isMe: e.isMe,
          active: e.active,
          deleted: e.deleted,
          deletedByUid: e.deletedByUid,
          deletedByUserType: e.deletedByUserType,
          deletedFor: e.deletedFor,
          deletedAt: e.deletedAt,
          deletedByUserAt: e.deletedByUserAt,
        );
      }).toList();
      await _localDataSource.saveMessages(models);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

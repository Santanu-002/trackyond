import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
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

class JobChatRepositoryImpl implements IJobChatRepository {
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
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

    if (isOnline) {
      final queryOptionsModel = options != null
          ? MessageQueryOptionsModel.fromEntity(options)
          : null;
      final response = await _remoteDataSource.getMessages(
        jobId: jobId,
        options: queryOptionsModel,
      );

      return response.fold(
        (error) async {
          final cached = await _localDataSource.getCachedMessages(
            jobId,
            limit: options?.limit,
            offset: options?.offset,
          );
          return Right(cached.map((m) => m.toEntity()).toList());
        },
        (data) async {
          if (data == null) return Left(ServerFailure('No data returned'));
          await _localDataSource.saveMessages(data);
          return Right(data.map((m) => m.toEntity()).toList());
        },
      );
    } else {
      final cached = await _localDataSource.getCachedMessages(
        jobId,
        limit: options?.limit,
        offset: options?.offset,
      );
      return Right(cached.map((m) => m.toEntity()).toList());
    }
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
    final payload = models.map((m) => m.toJson()).toList();

    final tempUid = models.first.localId ?? 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final previewMessage = JobChatMessageModel(
      uid: tempUid,
      localId: models.first.localId,
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

    if (isOnline && wsService.isConnected) {
      final data = {
        'jobId': jobId,
        'messages': payload,
      };

      wsService.sendEvent('chat', 'send', data);

      final previewResponse = SendMessageResponseModel(
        message: previewMessage,
        messages: [previewMessage],
        allowedActions: [],
      );

      return Right(previewResponse.toEntity());
    } else if (isOnline) {
      final response = await _remoteDataSource.sendMessage(messages: models);
      return response.fold(
        (error) async {
          // If REST fails, enqueue for sync later
          await _enqueueAndTrigger('send_message', {
            'jobId': jobId,
            'messages': payload,
          });
          final previewResponse = SendMessageResponseModel(
            message: previewMessage,
            messages: [previewMessage],
            allowedActions: [],
          );
          return Right(previewResponse.toEntity());
        },
        (data) async {
          if (data == null) return Left(ServerFailure('No data returned'));
          // Replace preview with the server-acknowledged message
          await _localDataSource.saveMessages(data.messages);
          return Right(data.toEntity());
        },
      );
    } else {
      // Offline: Enqueue in sync queue
      await _enqueueAndTrigger('send_message', {
        'jobId': jobId,
        'messages': payload,
      });

      final previewResponse = SendMessageResponseModel(
        message: previewMessage,
        messages: [previewMessage],
        allowedActions: [],
      );

      return Right(previewResponse.toEntity());
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
      // Offline: queue status update
      await _enqueueAndTrigger('update_job_status', {
        'jobId': jobId,
        'status': status,
      });
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
    await _localDataSource.deleteCachedMessages(messageUids);

    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);

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
          await _enqueueAndTrigger('delete_messages', {
            'jobId': jobId,
            'deleteType': deleteType,
            'messageUids': messageUids,
            'deletedByUserAt': deletedByUserAt.toUtc().toIso8601String(),
          });
          return const Right(null);
        },
        (data) => const Right(null),
      );
    } else {
      // Offline: Queue delete task
      await _enqueueAndTrigger('delete_messages', {
        'jobId': jobId,
        'deleteType': deleteType,
        'messageUids': messageUids,
        'deletedByUserAt': deletedByUserAt.toUtc().toIso8601String(),
      });
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

    if (isOnline && wsService.isConnected) {
      wsService.sendEvent('chat', 'seen', {
        'jobId': jobId,
        ...?messageUids != null ? {'messageUids': messageUids} : null,
      });
      return const Right(null);
    } else if (isOnline) {
      final response = await _remoteDataSource.markMessagesAsSeen(
        jobId: jobId,
        messageUids: messageUids,
      );
      return response.fold(
        (error) async {
          await _enqueueAndTrigger('seen_messages', {
            'jobId': jobId,
            'messageUids': messageUids,
          });
          return const Right(null);
        },
        (_) => const Right(null),
      );
    } else {
      await _enqueueAndTrigger('seen_messages', {
        'jobId': jobId,
        'messageUids': messageUids,
      });
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

    if (isOnline && wsService.isConnected) {
      wsService.sendEvent('chat', 'delivered', {
        'jobId': jobId,
        'messageUids': messageUids,
      });
      return const Right(null);
    } else if (isOnline) {
      final response = await _remoteDataSource.markMessagesAsDelivered(
        jobId: jobId,
        messageUids: messageUids,
      );
      return response.fold(
        (error) async {
          await _enqueueAndTrigger('delivered_messages', {
            'jobId': jobId,
            'messageUids': messageUids,
          });
          return const Right(null);
        },
        (_) => const Right(null),
      );
    } else {
      await _enqueueAndTrigger('delivered_messages', {
        'jobId': jobId,
        'messageUids': messageUids,
      });
      return const Right(null);
    }
  }

  Future<void> _enqueueAndTrigger(String actionType, Map<String, dynamic> payload) async {
    await _localDataSource.enqueueSyncTask(actionType, payload);
    _syncService.triggerSync();
  }
}

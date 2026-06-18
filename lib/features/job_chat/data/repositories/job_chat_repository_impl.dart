import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/services/websocket/websocket_service.dart';
import 'package:trackyond/core/services/websocket/priority_queue_manager.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/data/models/send_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/data/models/send_message_response_model.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';
import 'package:trackyond/features/job_chat/data/models/message_query_options_model.dart';

class JobChatRepositoryImpl implements IJobChatRepository {
  final IJobChatDataSource _remoteDataSource;

  JobChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(
    String jobId, {
    MessageQueryOptions? options,
  }) async {
    final queryOptionsModel = options != null
        ? MessageQueryOptionsModel.fromEntity(options)
        : null;
    final response = await _remoteDataSource.getMessages(
      jobId: jobId,
      options: queryOptionsModel,
    );

    return response.fold((error) => Left(ServerFailure(error.message)), (data) {
      if (data == null) return Left(ServerFailure('No data returned'));
      return Right(data.map((m) => m.toEntity()).toList());
    });
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
    final wsService = Get.find<WebSocketService>();

    if (isOnline && wsService.isConnected) {
      final jobId = models.first.jobId;
      final payload = models.map((m) => m.toJson()).toList();
      
      final data = {
        'jobId': jobId,
        'messages': payload,
      };

      wsService.sendEvent('chat', 'send', data);

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

      final previewResponse = SendMessageResponseModel(
        message: previewMessage,
        messages: [previewMessage],
        allowedActions: [],
      );

      return Right(previewResponse.toEntity());
    } else if (isOnline) {
      final response = await _remoteDataSource.sendMessage(messages: models);
      return response.fold(
        (error) => Left(ServerFailure(error.message)),
        (data) {
          if (data == null) return Left(ServerFailure('No data returned'));
          debugPrint("DEBUG: Job response after sending message: ${data.job?.toJson()}");
          return Right(data.toEntity());
        },
      );
    } else {
      final jobId = models.first.jobId;
      final payload = models.map((m) => m.toJson()).toList();
      
      final data = {
        'jobId': jobId,
        'messages': payload,
      };

      Get.find<PriorityQueueManager>().enqueue(
        event: 'chat',
        type: 'send',
        data: data,
        priority: QueuePriority.high,
      );

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
    final response = await _remoteDataSource.updateJobStatus(
      jobId: jobId,
      status: status,
    );

    return response.fold((error) => Left(ServerFailure(error.message)), (data) {
      if (data == null) return Left(ServerFailure('No data returned'));
      return Right(data.toEntity());
    });
  }

  @override
  Future<Either<AppFailure, List<MemberProfile>>> getChatMembers(
    String jobId,
  ) async {
    final response = await _remoteDataSource.getChatMembers(jobId: jobId);

    return response.fold((error) => Left(ServerFailure(error.message)), (data) {
      if (data == null) return Left(ServerFailure('No data returned'));
      return Right(data.map((m) => m.toEntity()).toList());
    });
  }

  @override
  Future<Either<AppFailure, void>> deleteMessages({
    required String jobId,
    required String deleteType,
    required List<String> messageUids,
    required DateTime deletedByUserAt,
  }) async {
    final response = await _remoteDataSource.deleteMessages(
      jobId: jobId,
      deleteType: deleteType,
      messageUids: messageUids,
      deletedByUserAt: deletedByUserAt,
    );
    return response.fold(
      (error) => Left(ServerFailure(error.message)),
      (data) => const Right(null),
    );
  }

  @override
  Future<Either<AppFailure, void>> markMessagesAsSeen(String jobId, {List<String>? messageUids}) async {
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    final wsService = Get.find<WebSocketService>();

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
        (error) => Left(ServerFailure(error.message)),
        (_) => const Right(null),
      );
    } else {
      return const Right(null);
    }
  }

  @override
  Future<Either<AppFailure, void>> markMessagesAsDelivered(String jobId, List<String> messageUids) async {
    if (messageUids.isEmpty) return const Right(null);
    
    final connectivityResults = await Connectivity().checkConnectivity();
    final isOnline = connectivityResults.any((result) => result != ConnectivityResult.none);
    final wsService = Get.find<WebSocketService>();

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
        (error) => Left(ServerFailure(error.message)),
        (_) => const Right(null),
      );
    } else {
      return const Right(null);
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/data/models/send_message_model.dart';
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

    final response = await _remoteDataSource.sendMessage(messages: models);

    return response.fold((error) => Left(ServerFailure(error.message)), (data) {
      if (data == null) return Left(ServerFailure('No data returned'));
      debugPrint(
        "DEBUG: Job response after sending message: ${data.job?.toJson()}",
      );
      return Right(data.toEntity());
    });
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
}

import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class JobChatRepositoryImpl implements IJobChatRepository {
  final IJobChatDataSource _remoteDataSource;

  JobChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(String jobId) async {
    final response = await _remoteDataSource.getMessages(jobId: jobId);
    
    return response.fold(
      (error) => Left(ServerFailure(error.message)),
      (data) {
        if (data == null) return Left(ServerFailure('No data returned'));
        return Right(data.map((m) => m.toEntity()).toList());
      },
    );
  }

  @override
  Future<Either<AppFailure, SendMessageResult>> sendMessage(JobChatMessageEntity message) async {
    final model = JobChatMessageModel(
      uid: message.uid,
      localId: message.localId,
      jobId: message.jobId,
      authorType: message.authorType,
      createdByUid: message.senderId,
      createdByProfileUid: message.senderProfileUid,
      senderName: message.senderName,
      senderId: message.senderId,
      content: message.content.map((c) => JobChatMessageContentModel(
        id: 0, // Mock id for new creation, backend generates real one
        type: c.type,
        content: c.content,
        metadata: c.metadata,
        actionPerformed: c.actionPerformed,
      )).toList(),
      type: message.type,
      metadata: message.metadata,
      createdByAuthorAt: message.timestamp,
      createdAt: message.createdAt,
      updatedAt: message.updatedAt,
      seenAt: message.seenAt,
      deliveredAt: message.deliveredAt,
      status: message.status,
      isMe: message.isMe,
      active: message.active,
      deleted: message.deleted,
    );

    final response = await _remoteDataSource.sendMessage(message: model);
    
    return response.fold(
      (error) => Left(ServerFailure(error.message)),
      (data) {
        if (data == null) return Left(ServerFailure('No data returned'));
        return Right(data.toEntity());
      },
    );
  }

  @override
  Future<Either<AppFailure, JobEntity>> updateJobStatus(String jobId, String status) async {
    final response = await _remoteDataSource.updateJobStatus(jobId: jobId, status: status);
    
    return response.fold(
      (error) => Left(ServerFailure(error.message)),
      (data) {
        if (data == null) return Left(ServerFailure('No data returned'));
        return Right(data.toEntity());
      },
    );
  }

  @override
  Future<Either<AppFailure, List<MemberProfile>>> getChatMembers(String jobId) async {
    final response = await _remoteDataSource.getChatMembers(jobId: jobId);
    
    return response.fold(
      (error) => Left(ServerFailure(error.message)),
      (data) {
        if (data == null) return Left(ServerFailure('No data returned'));
        return Right(data.map((m) => m.toEntity()).toList());
      },
    );
  }
}

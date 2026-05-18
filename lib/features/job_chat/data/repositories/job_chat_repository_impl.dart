import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/data/datasources/job_chat_remote_datasource.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_content_model.dart';
import 'package:trackyond/features/job_chat/data/models/job_chat_message_model.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

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
  Future<Either<AppFailure, JobChatMessageEntity>> sendMessage(JobChatMessageEntity message) async {
    // Map Entity to Model
    final model = JobChatMessageModel(
      uid: message.id,
      localId: message.localId,
      jobId: message.jobId,
      authorType: message.authorType,
      createdByUid: message.senderId,
      createdByProfileUid: message.senderProfileUid,
      senderName: message.senderName,
      senderId: message.senderId,
      contents: message.contents.map((c) => JobChatMessageContentModel(
        id: 0, // Mock id for new creation, backend generates real one
        type: c.type,
        message: c.message,
        metadata: c.metadata,
      )).toList(),
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
}

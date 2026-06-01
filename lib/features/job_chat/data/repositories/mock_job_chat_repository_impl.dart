import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/common/enums/job_status.dart';
import 'package:trackyond/core/common/enums/job_chat_message_type.dart';
import 'package:trackyond/core/common/enums/job_chat_message_content_type.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';

class MockJobChatRepositoryImpl implements IJobChatRepository {
  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(
    String jobId, {
    MessageQueryOptions? options,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right([
      JobChatMessageEntity(
        uid: '1',
        jobId: jobId,
        senderUid: 'system',
        type: JobChatMessageType.activity,
        content: const [
          JobChatMessageContentEntity(
            type: JobChatMessageContentType.activity,
            content: 'Job created by Admin',
          ),
        ],
        createdByAuthorAt: DateTime.now().subtract(const Duration(days: 1)),
        isMe: false,
      ),
      JobChatMessageEntity(
        uid: '2',
        jobId: jobId,
        senderUid: 'worker_1',
        type: JobChatMessageType.message,
        content: const [
          JobChatMessageContentEntity(
            type: JobChatMessageContentType.text,
            content: 'Hello, I am on my way.',
          ),
        ],
        createdByAuthorAt: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
    ]);
  }

  @override
  Future<Either<AppFailure, SendMessageResult>> sendMessage(List<JobChatMessageEntity> messages) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (messages.isEmpty) {
      return Left(ServerFailure('No messages to send'));
    }
    return Right(SendMessageResult(
      message: messages.last,
      messages: messages,
      allowedActions: const [],
      job: null,
    ));
  }

  @override
  Future<Either<AppFailure, JobEntity>> updateJobStatus(String jobId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(JobEntity(
      jobId: jobId,
      jobTitle: 'Mock Job',
      customerName: 'Customer',
      customerPhone: '1234567890',
      workerProfileUid: 'worker',
      status: JobStatus.fromString(status),
      requirePhotoOnStart: false,
      requirePhotoOnComplete: false,
      captureLocation: false,
      createdAt: DateTime.now(),
    ));
  }

  @override
  Future<Either<AppFailure, List<MemberProfile>>> getChatMembers(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const Right([]);
  }
}

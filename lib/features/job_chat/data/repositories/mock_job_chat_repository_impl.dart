import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_type.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_content_entity.dart';

import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class MockJobChatRepositoryImpl implements IJobChatRepository {
  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(String jobId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right([
      JobChatMessageEntity(
        uid: '1',
        jobId: jobId,
        authorType: 'system',
        senderName: 'System',
        senderId: 'system',
        contents: [
          JobChatMessageContentEntity(
            type: JobChatMessageType.activity.value,
            message: 'Job created by Admin',
          ),
        ],
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isMe: false,
      ),
      JobChatMessageEntity(
        uid: '2',
        jobId: jobId,
        senderName: 'John Doe',
        senderId: 'worker_1',
        contents: [
          JobChatMessageContentEntity(
            type: JobChatMessageType.text.value,
            message: 'Hello, I am on my way.',
          ),
        ],
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
    ]);
  }

  @override
  Future<Either<AppFailure, SendMessageResult>> sendMessage(JobChatMessageEntity message) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(SendMessageResult(message: message, allowedActions: []));
  }

  @override
  Future<Either<AppFailure, JobEntity>> updateJobStatus(String jobId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Left(ServerFailure('Mock status update not implemented'));
  }
}

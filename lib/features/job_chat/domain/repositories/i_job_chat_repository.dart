import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';

abstract interface class IJobChatRepository {
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(String jobId);
  Future<Either<AppFailure, JobChatMessageEntity>> sendMessage(JobChatMessageEntity message);
}

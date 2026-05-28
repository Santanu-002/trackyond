import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/entities/member/member_profile.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';

abstract interface class IJobChatRepository {
  Future<Either<AppFailure, List<JobChatMessageEntity>>> getMessages(
    String jobId, {
    MessageQueryOptions? options,
  });
  Future<Either<AppFailure, SendMessageResult>> sendMessage(JobChatMessageEntity message);
  Future<Either<AppFailure, JobEntity>> updateJobStatus(String jobId, String status);
  Future<Either<AppFailure, List<MemberProfile>>> getChatMembers(String jobId);
}

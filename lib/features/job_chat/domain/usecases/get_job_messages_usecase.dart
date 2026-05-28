import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/message_query_options.dart';

class GetJobMessagesParams {
  final String jobId;
  final MessageQueryOptions? options;

  GetJobMessagesParams({
    required this.jobId,
    this.options,
  });
}

class GetJobMessagesUseCase implements BaseUseCase<List<JobChatMessageEntity>, GetJobMessagesParams> {
  final IJobChatRepository _repository;

  GetJobMessagesUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> call(GetJobMessagesParams params) {
    return _repository.getMessages(params.jobId, options: params.options);
  }
}

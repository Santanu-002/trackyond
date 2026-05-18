import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class GetJobMessagesUseCase implements BaseUseCase<List<JobChatMessageEntity>, String> {
  final IJobChatRepository _repository;

  GetJobMessagesUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<JobChatMessageEntity>>> call(String jobId) {
    return _repository.getMessages(jobId);
  }
}

import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class MarkMessagesSeenParams {
  final String jobId;
  final List<String>? messageUids;

  const MarkMessagesSeenParams({required this.jobId, this.messageUids});
}

class MarkMessagesSeenUseCase implements BaseUseCase<void, MarkMessagesSeenParams> {
  final IJobChatRepository _repository;

  MarkMessagesSeenUseCase(this._repository);

  @override
  Future<Either<AppFailure, void>> call(MarkMessagesSeenParams params) async {
    return await _repository.markMessagesAsSeen(params.jobId, messageUids: params.messageUids);
  }
}

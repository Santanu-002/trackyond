import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class MarkMessagesAsDeliveredParams {
  final String jobId;
  final List<String> messageUids;

  const MarkMessagesAsDeliveredParams({required this.jobId, required this.messageUids});
}

class MarkMessagesAsDeliveredUseCase implements BaseUseCase<Unit, MarkMessagesAsDeliveredParams> {
  final IJobChatRepository _repository;

  MarkMessagesAsDeliveredUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(MarkMessagesAsDeliveredParams params) async {
    return await _repository.markMessagesAsDelivered(params.jobId, params.messageUids);
  }
}

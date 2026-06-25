import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class DeleteMessagesParams {
  final String jobId;
  final String deleteType;
  final List<String> messageUids;
  final DateTime deletedByUserAt;

  DeleteMessagesParams({
    required this.jobId,
    required this.deleteType,
    required this.messageUids,
    required this.deletedByUserAt,
  });
}

class DeleteMessagesUseCase implements BaseUseCase<Unit, DeleteMessagesParams> {
  final IJobChatRepository _repository;

  DeleteMessagesUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(DeleteMessagesParams params) {
    return _repository.deleteMessages(
      jobId: params.jobId,
      deleteType: params.deleteType,
      messageUids: params.messageUids,
      deletedByUserAt: params.deletedByUserAt,
    );
  }
}

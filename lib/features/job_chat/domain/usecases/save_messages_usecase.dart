import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class SaveMessagesUseCase implements BaseUseCase<Unit, List<JobChatMessageEntity>> {
  final IJobChatRepository _repository;

  SaveMessagesUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(List<JobChatMessageEntity> params) {
    return _repository.saveMessages(params);
  }
}

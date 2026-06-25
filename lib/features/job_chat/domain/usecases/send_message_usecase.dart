import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';


class SendMessageParams {
  final List<SendMessageEntity> messages;

  SendMessageParams({required this.messages});
}

class SendMessageUseCase implements BaseUseCase<Unit, SendMessageParams> {
  final IJobChatRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(SendMessageParams params) {
    return _repository.sendMessage(params.messages);
  }
}

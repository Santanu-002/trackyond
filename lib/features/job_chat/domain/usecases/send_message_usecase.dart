import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/send_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class SendMessageParams {
  final List<SendMessageEntity> messages;

  SendMessageParams({required this.messages});
}

class SendMessageUseCase implements BaseUseCase<SendMessageResult, SendMessageParams> {
  final IJobChatRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<AppFailure, SendMessageResult>> call(SendMessageParams params) {
    return _repository.sendMessage(params.messages);
  }
}

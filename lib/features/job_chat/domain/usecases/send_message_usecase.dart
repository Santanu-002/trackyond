import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/entities/job_chat_message_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

import 'package:trackyond/features/job_chat/domain/entities/send_message_result.dart';

class SendMessageParams {
  final JobChatMessageEntity message;

  SendMessageParams({required this.message});
}

class SendMessageUseCase implements BaseUseCase<SendMessageResult, SendMessageParams> {
  final IJobChatRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<AppFailure, SendMessageResult>> call(SendMessageParams params) {
    return _repository.sendMessage(params.message);
  }
}

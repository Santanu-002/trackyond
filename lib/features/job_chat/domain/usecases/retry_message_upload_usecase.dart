import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class RetryMessageUploadParams {
  final String messageUid;

  RetryMessageUploadParams({required this.messageUid});
}

class RetryMessageUploadUseCase implements BaseUseCase<Unit, RetryMessageUploadParams> {
  final IJobChatRepository _repository;

  RetryMessageUploadUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(RetryMessageUploadParams params) {
    return _repository.retryMessageUpload(params.messageUid);
  }
}

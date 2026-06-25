import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class CancelMessageUploadParams {
  final String messageUid;

  CancelMessageUploadParams({required this.messageUid});
}

class CancelMessageUploadUseCase implements BaseUseCase<Unit, CancelMessageUploadParams> {
  final IJobChatRepository _repository;

  CancelMessageUploadUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(CancelMessageUploadParams params) {
    return _repository.cancelMessageUpload(params.messageUid);
  }
}

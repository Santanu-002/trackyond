import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/features/job_chat/domain/repositories/i_job_chat_repository.dart';

class UpdateJobStatusParams {
  final String jobId;
  final String status;

  UpdateJobStatusParams({required this.jobId, required this.status});
}

class UpdateJobStatusUseCase implements BaseUseCase<JobEntity, UpdateJobStatusParams> {
  final IJobChatRepository _repository;

  UpdateJobStatusUseCase(this._repository);

  @override
  Future<Either<AppFailure, JobEntity>> call(UpdateJobStatusParams params) {
    return _repository.updateJobStatus(params.jobId, params.status);
  }
}

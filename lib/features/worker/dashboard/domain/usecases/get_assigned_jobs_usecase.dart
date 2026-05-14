import 'package:fpdart/fpdart.dart';
import 'package:trackyond/core/common/entities/job/job_entity.dart';
import 'package:trackyond/core/common/usecase/usecase.dart';
import 'package:trackyond/core/exception/app_failures.dart';
import 'package:trackyond/features/worker/dashboard/domain/repositories/i_job_repository.dart';

class GetAssignedJobsUseCase
    implements BaseUseCase<List<JobEntity>, GetAssignedJobsParams> {
  final IJobRepository _repository;

  GetAssignedJobsUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<JobEntity>>> call(
    GetAssignedJobsParams params,
  ) {
    return _repository.getAssignedJobs(
      limit: params.limit,
      offset: params.offset,
      status: params.status,
    );
  }
}

class GetAssignedJobsParams {
  final int limit;
  final int offset;
  final String? status;

  GetAssignedJobsParams({this.limit = 20, this.offset = 0, this.status});
}
